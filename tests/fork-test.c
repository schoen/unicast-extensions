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

#define NS_PREFIX "/run/netns/"
#define ALARM_TIMEOUT 4

int done = 0;
int fail = 0;
char *child_ns;
char *server_addr;
int server_port;

int switch_ns(char *ns) {
	char *path;
	int fd, result;
	path = malloc(strlen(NS_PREFIX) + strlen(ns) + 1);
	strncpy(path, NS_PREFIX, strlen(NS_PREFIX));
	strncat(path, ns, strlen(ns));
	fd = open(path, 0);
	if (fd < 0) {
		result = fd; }
	else {
		result = setns(fd, CLONE_NEWNET);
		close(fd);
	}
	free(path);
	return(result);
};

int parent(pid_t child_pid, char *ns){
	struct sockaddr_in address;
	char buf[128];
	int sock;
	int newsock;
	int status;
	int n;
	int result;
	
	if (switch_ns(ns)){
		printf("PARENT: failed to switch netns to %s, exiting!\n", ns);
		exit(1);
	} else {
		printf("PARENT: switched netns to %s\n", ns);
	}

	/* socket stuff goes here */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	address.sin_family = AF_INET;
	inet_pton(AF_INET, server_addr, &address.sin_addr);
	address.sin_port = htons(server_port); 
	result = bind(sock, &address, sizeof(address));
	if (result < 0) { perror("bind");
		exit(1);
	}
	result = listen(sock, 1);
	if (result < 0) { perror("listen");
		exit(1);
	}

	kill(child_pid, SIGUSR1);
	alarm(4);
	newsock = accept(sock, NULL, NULL);
	if (newsock < 0) { perror("accept");
		exit(1);
	}
	n = read(newsock, buf, 100);
	if (n < 0) {
		perror("parent sock");
		exit(1);
	}
	buf[n] = 0;
	printf("Received %d bytes: %s\n", n, buf);

	wait(&status);
	/* exit with status of child */
	exit (WEXITSTATUS(status));
}

void handler(int sig){
	struct sockaddr_in address;
	int sock;
	int result;
	char *buf = "hello, world";

	if (switch_ns(child_ns)){
		printf("CHILD: failed to switch netns to %s, exiting!\n", child_ns);
		fail = 1;
		done = 1;
		return;
	};

	printf("CHILD:  switched netns to %s\n", child_ns);
	
	/* socket */
	sock = socket(AF_INET, SOCK_STREAM, 0);
	address.sin_family = AF_INET;
	inet_pton(AF_INET, server_addr, &address.sin_addr);
	address.sin_port = htons(server_port);
	result = connect(sock, &address, sizeof(address));
	if (result < 0) {
		perror("connect");
		fail = 1;
	} else {
		write(sock, buf, strlen(buf));
		if (result < 0) {
			perror("write");
			fail = 1;
		};
	}
	close(sock);

	done = 1;
}

int child(pid_t parent_pid){
	/* loop thing waiting for signal handler */

	/* there is a deadlock in libc here related to printf in
	 * multiple threads or something */
	while (!done){
		if (kill(parent_pid, 0) < 0){
			printf("CHILD: parent exited?\n");
			fail = 1;
			break;
		}
	}
	exit(fail);
}

int main(int argc, char* argv[]){
	pid_t ppid, cpid;
	if (argc < 5){
		printf("usage: %s parentns childns address port\n", argv[0]);
		exit(1); 
	}
	if (geteuid()){
		printf("%s: probably need to be root\n", argv[0]);
		exit(1); 
	}

	child_ns = argv[2];
	server_addr = argv[3];
	server_port = atoi(argv[4]);

	/* to avoid race, this should be done before the fork! */
	signal(SIGUSR1, handler);
	printf("this printf avoids a deadlock\n");

	ppid = getpid();
	cpid = fork();
	if (cpid){
		parent(cpid, argv[1]); }
	else {
		child(ppid);
	}
}
