/*
 * signal_demo.c
 * Demonstrates signal handling using SIGTERM and SIGINT
 *
 * Parent runs indefinitely.
 * One child sends SIGTERM after 5 seconds.
 * Another child sends SIGINT after 10 seconds.
 * Parent handles both signals differently and exits gracefully.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

/* Signal handler */
void handle_signal(int sig) {
    if (sig == SIGTERM) {
        printf("\nParent received SIGTERM (graceful shutdown requested).\n");
        printf("Cleaning up resources...\n");
        exit(0);
    } 
    else if (sig == SIGINT) {
        printf("\nParent received SIGINT (interrupt signal).\n");
        printf("Performing interrupt-specific cleanup...\n");
        exit(0);
    }
}

int main() {
    pid_t pid1, pid2;

    printf("Parent PID: %d\n", getpid());

    /* Register signal handlers */
    signal(SIGTERM, handle_signal);
    signal(SIGINT, handle_signal);

    /* First child sends SIGTERM after 5 seconds */
    pid1 = fork();
    if (pid1 == 0) {
        sleep(5);
        printf("Child 1 sending SIGTERM to parent\n");
        kill(getppid(), SIGTERM);
        exit(0);
    }

    /* Second child sends SIGINT after 10 seconds */
    pid2 = fork();
    if (pid2 == 0) {
        sleep(10);
        printf("Child 2 sending SIGINT to parent\n");
        kill(getppid(), SIGINT);
        exit(0);
    }

    /* Parent runs indefinitely */
    while (1) {
        printf("Parent running...\n");
        sleep(1);
    }

    return 0;
}
