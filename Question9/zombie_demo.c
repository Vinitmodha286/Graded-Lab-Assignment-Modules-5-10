/* zombie_demo.c
 *
 * Demonstrates creating multiple children and preventing zombies.
 * Usage: ./zombie_demo [num_children]
 * If num_children is omitted it defaults to 3.
 *
 * Behavior:
 * - Parent forks N children.
 * - Each child prints its PID then exits immediately.
 * - Parent prints the child PIDs created, sleeps for a few seconds
 *   (so you can run `ps` in another terminal and observe defunct/zombie processes),
 *   then reaps all children using waitpid() and prints each PID it cleaned up.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    int n = 3;
    if (argc > 2) {
        fprintf(stderr, "Usage: %s [num_children]\n", argv[0]);
        return 1;
    }
    if (argc == 2) {
        n = atoi(argv[1]);
        if (n <= 0) {
            fprintf(stderr, "Error: num_children must be a positive integer\n");
            return 1;
        }
    }

    pid_t parent_pid = getpid();
    printf("Parent PID: %d\n", parent_pid);

    int created = 0;
    for (int i = 0; i < n; ++i) {
        pid_t pid = fork();
        if (pid < 0) {
            perror("fork");
            return 1;
        } else if (pid == 0) {
            /* Child */
            printf("Child %d: PID %d (exiting now)\n", i+1, getpid());
            /* Child exits immediately so it may briefly become a zombie */
            _exit(0);
        } else {
            /* Parent */
            printf("Created child %d with PID %d\n", i+1, pid);
            created++;
        }
    }

    if (created == 0) {
        printf("No children created. Exiting.\n");
        return 0;
    }

    /* Pause briefly so children can exit and become zombies if parent doesn't reap yet.
       This gives you time to run `ps` in another terminal to observe 'Z' (defunct) processes.
       Then the parent reaps them properly using waitpid(). */
    printf("Parent will sleep for 5 seconds. While sleeping, run:\n");
    printf("    ps -eo pid,ppid,state,cmd | grep defunct\n");
    printf("to try to observe defunct (Z) entries. After sleep the parent will reap children.\n\n");
    sleep(5);

    int reaped = 0;
    while (reaped < created) {
        int status;
        pid_t w = waitpid(-1, &status, 0);  /* block until a child exits (reap it) */
        if (w == -1) {
            perror("waitpid");
            break;
        } else {
            if (WIFEXITED(status)) {
                printf("Reaped child PID %d, exit status %d\n", w, WEXITSTATUS(status));
            } else {
                printf("Reaped child PID %d, terminated abnormally\n", w);
            }
            reaped++;
        }
    }

    printf("All children reaped. No zombies remain.\n");
    return 0;
}
