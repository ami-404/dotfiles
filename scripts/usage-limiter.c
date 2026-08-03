#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>

int find_pid(const char *process_name) {
    char command[128];
    snprintf(command, sizeof(command),
             "pgrep -o '%s' 2>/dev/null", process_name);

    FILE *fp = popen(command, "r");
    if (!fp) return -1;

    char buffer[16];
    if (fgets(buffer, sizeof(buffer), fp) == NULL) {
        pclose(fp);
        return -1;
    }
    pclose(fp);
    return atoi(buffer);
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <process_name> <time_limit_seconds>\n", argv[0]);
        return 1;
    }

    const char *process_name = argv[1];
    int time_limit = atoi(argv[2]);
    int elapsed = 0;

    printf("Monitoring %s - Max time: %d seconds\n", process_name, time_limit);

    while (elapsed < time_limit) {
        int pid = find_pid(process_name);
        if (pid == -1) {
            printf("%s is not running...\n", process_name);
            elapsed = 0; // reset counter when app exits
        } else {
            printf("%s running (PID %d) - Time left: %d sec\n",
                   process_name, pid, time_limit - elapsed);
            elapsed++;
        }
        sleep(1);
    }

    int pid = find_pid(process_name);
    if (pid != -1) {
        printf("Time's up! Killing %s (PID %d)\n", process_name, pid);
        kill(pid, SIGTERM);
        sleep(2);
        if (find_pid(process_name) != -1) {
            kill(pid, SIGKILL);
        }
    }

    return 0;
}
