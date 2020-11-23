/*
 * SPDX-License-Identifier: GPL-2.0
 * fast-fork-test.c by Seth Schoen (2020), with improvements by David Ahern
 *
 * This should eventually be merged into nettest.c, as it implements a
 * subset of the latter's functionality, but with the addition of built-in
 * netns switching, and use of pipe IPC to speed up the test synchronization.
 * 
 * Invocation is like:   fast-fork-test parentns childns address port
 *
 * Example context:
 ip netns add foo2
 ip netns add bar2
 ip link add veth1 type veth peer name veth2
 ip link set veth1 netns foo2 name eth0 up
 ip link set veth2 netns bar2 name eth0 up
 ip -net foo2 addr add dev eth0 172.16.56.1/24
 ip -net bar2 addr add dev eth0 172.16.56.2/24
 ip netns exec foo2 ping -c1 -w1 172.16.56.2
 fast-fork-test foo2 bar2 172.16.56.1 12345
 */
#define _GNU_SOURCE
#include <arpa/inet.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <linux/limits.h>

#define NS_PREFIX "/run/netns/"
#define TIMEOUT 2

char *child_ns;
char *server_addr;
int server_port;

int switch_ns(char *ns)
{
	char path[PATH_MAX];
	int fd, ret;

	snprintf(path, sizeof(path), "%s%s", NS_PREFIX, ns);
	fd = open(path, 0);
	if (fd < 0) {
		perror("ns path open");
		return 1;
	}

	ret = setns(fd, CLONE_NEWNET);
	close(fd);

	return ret;
}

void pipewrite(int fd, int n)
{
	write(fd, &n, sizeof(n));
}

int parent(int fd, char *ns)
{
	struct sockaddr_in address;
	char buf[128];
	int sock;
	int newsock;
	int status;
	int n;
	int result;
	
	if (switch_ns(ns)){
		printf("PARENT: failed to switch netns to %s, exiting!\n", ns);
		pipewrite(fd, 0);
		return 1;
	}

	printf("PARENT: switched netns to %s\n", ns);

	/* socket stuff goes here */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	address.sin_family = AF_INET;
	inet_pton(AF_INET, server_addr, &address.sin_addr);
	address.sin_port = htons(server_port); 
	result = bind(sock, &address, sizeof(address));
	if (result < 0) {
		perror("bind");
		pipewrite(fd, 0);
		return 1;
	}
	alarm(TIMEOUT);
	result = listen(sock, 1);
	if (result < 0) {
		perror("listen");
		pipewrite(fd, 0);
		return 1;
	}

	/* Tell child to continue */
	pipewrite(fd, 1);

	newsock = accept(sock, NULL, NULL);
	if (newsock < 0) {
		perror("accept");
		return 1;
	}

	n = read(newsock, buf, 100);
	if (n < 0) {
		perror("parent sock");
		return 1;
	}
	buf[n] = 0;
	printf("Received %d bytes: %s\n", n, buf);

	wait(&status);

	/* exit with status of child */
	return WEXITSTATUS(status);
}

int child(int fd)
{
	struct sockaddr_in address;
	int sock;
	int result;
	char *str = "hello, world";
	char buf[64];

	if (switch_ns(child_ns)) {
		printf("CHILD: failed to switch netns to %s, exiting!\n", child_ns);
		return 1;
	}
	printf("CHILD:  switched netns to %s\n", child_ns);

	alarm(TIMEOUT);
	if (read(fd, buf, sizeof(buf)) <= 0) {
		perror("client: read:");
		return 1;
	}
	if (!buf[0]){
		printf("client: parent could not continue\n");
		return 1;
	}

	/* socket */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	address.sin_family = AF_INET;
	inet_pton(AF_INET, server_addr, &address.sin_addr);
	address.sin_port = htons(server_port);
	alarm(TIMEOUT);
	result = connect(sock, &address, sizeof(address));
	if (result < 0) {
		perror("connect");
		return 1;
	}
	write(sock, str, strlen(str));
	if (result < 0) {
		perror("write");
	}
	close(sock);

	return 0;
}

int main(int argc, char* argv[])
{
	pid_t cpid;
	int fd[2];

	if (argc < 5) {
		printf("usage: %s parentns childns address port\n", argv[0]);
		return 1;
	}
	if (geteuid()) {
		printf("%s: need to be root\n", argv[0]);
		return 1;
	}

	if (pipe(fd) < 0) {
		perror("pipe");
		return 1;
	}

	child_ns = argv[2];
	server_addr = argv[3];
	server_port = atoi(argv[4]);

	cpid = fork();
	if (cpid) {
		return parent(fd[1], argv[1]);
	}

	return child(fd[0]);
}
