#!/usr/bin/env python

# Python prototype of simple nettest-like functionality to check whether
# or not one netns can reach another with a TCP connection -- but
# without any sleep in the successful case. (Unsuccessful cases may fail
# immediately or after a specified socket timeout, depending on the
# specific failure reason.)

# Exits with success or failure, depending on whether the connection
# worked.

import socket
import signal
import time
import os
import ctypes
import sys

# the environment this is looking for was created with
# ip netns add wow; ip netns add yow
# ip link add foo netns wow type veth peer name bar netns yow
# ip -n wow address add 192.168.11.3/24 dev foo; ip -n wow link set foo up
# ip -n yow address add 192.168.11.5/24 dev bar; ip -n yow link set bar up

parent_ns="wow"
parent_ip="192.168.11.3"
port=12345
child_ns="yow"
ret=0
done=False
socket.setdefaulttimeout(3)

def netns(s):
    print("in netns")
    # Attempt to join the network namespace s by means of
    # a system-level call to open(2) followed by setns(2).
    libc = ctypes.CDLL("/lib/x86_64-linux-gnu/libc.so.6")
    ns_location = "/run/netns/" + s
    fd = libc.open(ns_location, 0)
    if fd < 0:
        raise ValueError
    result = libc.setns(fd, 0)
    print(ctypes.get_errno())
    if result < 0:
        raise OSError
    libc.close(fd)

def parent(child_pid, ns=parent_ns):
    global ret
    netns(ns)
    print('PARENT: Switched to network namespace {}'.format(ns))
    # TODO: Check return codes instead of relying on exceptions
    #       (since some failures may be reported in return code)
    # Timeout is a slower path in case of a failure on the client
    # side or in the connectivity between the client and server.
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind((parent_ip, port))
    sock.listen(1)
    print('PARENT: port bound; going to signal the child')
    os.kill(child_pid, signal.SIGUSR1)
    print('PARENT: signal sent')
    a, b = sock.accept()
    data = a.recv(100)
    print('PARENT: -------> Received "{}" <------ (success)'.format(data))
    print('PARENT: Going to wait for child...')
    pid, code = os.wait()
    print('PARENT: Done waiting with {}'.format(code))
    ret += code

def handler(signum, frame, ns=child_ns):
    global done
    global ret
    if signum == signal.SIGUSR1:
        try:
            print('CHILD:  Received the signal')
            netns(ns)
            print('CHILD:  Switched to network namespace {}'.format(ns))
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            print('CHILD:  Connecting')
            sock.connect((parent_ip, port))
            print('CHILD:  Sending data')
            sock.send("hello world")
            print('CHILD:  Data sent')
        except:
            ret += 1
    else:
        print('CHILD:  I got some other signal')
        ret += 1
    done=True

def child(ppid):
    while not done:
        # While waiting for the handler to execute, make sure the parent
        # is still alive!
        try:
            os.kill(ppid, 0)
        except OSError:
            print('CHILD:  The parent died')
            raise OSError
        pass
    print('CHILD:  going to exit')

if os.getuid():
    print("need to be root for netns manipulation")
    sys.exit(1)

signal.signal(signal.SIGUSR1, handler) # set before fork to avoid race!
ppid = os.getpid()
pid = os.fork()
if pid:
    print('PARENT: child PID is {}'.format(pid))
    try:
        parent(pid)
    except:
        print('PARENT: exception encountered')
        ret += 1
else:
    print('CHILD:  parent PID is {}'.format(ppid))
    try:
        child(ppid)
    except:
        print('CHILD:  exception encountered')
        ret += 1

sys.exit(ret)
