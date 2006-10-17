/*
 * Copyright (c) 1999, 2006 Tanuki Software Inc.
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of the Java Service Wrapper and associated
 * documentation files (the "Software"), to deal in the Software
 * without  restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sub-license,
 * and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the
 * following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
 * NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 * 
 * Portions of the Software have been derived from source code
 * developed by Silver Egg Technology under the following license:
 * 
 * Copyright (c) 2001 Silver Egg Technology
 * 
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without 
 * restriction, including without limitation the rights to use, 
 * copy, modify, merge, publish, distribute, sub-license, and/or 
 * sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following 
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 */

/**
 * Author:
 *   Leif Mortenson <leif@tanukisoftware.com>
 *   Ryan Shaw
 */

#ifndef WIN32

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <signal.h>
#include <limits.h>
#include <pthread.h>
#include <pwd.h>
#include <sys/timeb.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include "wrapper.h"
#include "wrapperinfo.h"
#include "property.h"
#include "logger.h"

#include <sys/resource.h>
#include <sys/time.h>

#ifndef USE_USLEEP
#include <time.h>
#endif

#ifndef getsid
/* getpid links ok on Linux, but is not defined correctly. */
pid_t getsid(pid_t pid);
#endif

#define max(x,y) (((x) > (y)) ? (x) : (y)) 
#define min(x,y) (((x) < (y)) ? (x) : (y)) 

static pid_t jvmPid = -1;
int          jvmOut = -1;

/* Define a global pipe descriptor so that we don't have to keep allocating
 *  a new pipe each time a JVM is launched. */
int pipedes[2];
int pipeInitialized = 0;  

char wrapperClasspathSeparator = ':';

pthread_t timerThreadId;
/* Initialize the timerTicks to a very high value.  This means that we will
 *  always encounter the first rollover (256 * WRAPPER_MS / 1000) seconds
 *  after the Wrapper the starts, which means the rollover will be well
 *  tested. */
DWORD timerTicks = 0xffffff00;

/******************************************************************************
 * Platform specific methods
 *****************************************************************************/

/**
 * exits the application after running shutdown code.
 */
void appExit(int exitCode) {
    /* Remove pid file.  It may no longer exist. */
    if (wrapperData->pidFilename) {
        unlink(wrapperData->pidFilename);
    }
    
    /* Remove lock file.  It may no longer exist. */
    if (wrapperData->lockFilename) {
        unlink(wrapperData->lockFilename);
    }
    
    /* Remove status file.  It may no longer exist. */
    if (wrapperData->statusFilename) {
        unlink(wrapperData->statusFilename);
    }
    
    /* Remove java status file if it was registered and created by this process. */
    if (wrapperData->javaStatusFilename) {
        unlink(wrapperData->javaStatusFilename);
    }

    /* Remove java id file if it was registered and created by this process. */
    if (wrapperData->javaIdFilename) {
        unlink(wrapperData->javaIdFilename);
    }

    /* Remove anchor file.  It may no longer exist. */
    if (wrapperData->anchorFilename) {
        unlink(wrapperData->anchorFilename);
    }
    
    /* Common wrapper cleanup code. */
    wrapperDispose();

    exit(exitCode);
}

/**
 * Gets the error code for the last operation that failed.
 */
int wrapperGetLastError() {
    return errno;
}

/**
 * Writes a PID to disk.
 *
 * filename: File to write to.
 * pid: pid to write in the file.
 */
int writePidFile(const char *filename, DWORD pid, int newUmask) {
    FILE *pid_fp = NULL;
    int old_umask;

    old_umask = umask(newUmask);
    pid_fp = fopen(filename, "w");
    umask(old_umask);
    
    if (pid_fp != NULL) {
        fprintf(pid_fp, "%d\n", (int)pid);
        fclose(pid_fp);
    } else {
        return 1;
    }
    return 0;
}

/**
 * Send a signal to the JVM process asking it to dump its JVM state.
 */
void wrapperRequestDumpJVMState(int useLoggerQueue) {
    log_printf_queue(useLoggerQueue, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
        "Dumping JVM state.");
    if (kill(jvmPid, SIGQUIT) < 0) {
        log_printf_queue(useLoggerQueue, WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                   "Could not dump JVM state: %s", getLastErrorText());
    }
}

const char* getSignalName(int signo) {
    switch (signo) {
        case SIGALRM:
            return "SIGALRM";
        case SIGINT:
            return "SIGINT";
        case SIGKILL:
            return "SIGKILL";
        case SIGQUIT:
            return "SIGQUIT";
        case SIGCHLD:
            return "SIGCHLD";
        case SIGTERM:
            return "SIGTERM";
        case SIGHUP:
            return "SIGHUP";
        default:
            return "UNKNOWN";
    }
}

const char* getSignalCodeDesc(int code) {
    switch (code) {
    case SI_USER:
        return "kill, sigsend or raise";

#ifdef SI_KERNEL
    case SI_KERNEL:
        return "the kernel";
#endif

    case SI_QUEUE:
        return "sigqueue";

    case SI_TIMER:
        return "timer expired";

    case SI_MESGQ:
        return "mesq state changed";

    case SI_ASYNCIO:
        return "AIO completed";

#ifdef SI_SIGIO
    case SI_SIGIO:
        return "queued SIGIO";
#endif

    default:
        return "unknown";
    }
}

void descSignal(siginfo_t *sigInfo) {
    struct passwd *pw;
    char *uName;

    /* Not supported on all platforms */
    if (sigInfo == NULL) {
        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
            "Signal trapped.  No details available.");
        return;
    }

    if (wrapperData->isDebugging) {
        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
            "Signal trapped.  Details:");

        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
            "  signal number=%d (%s), source=\"%s\"",
            sigInfo->si_signo,
            getSignalName(sigInfo->si_signo),
            getSignalCodeDesc(sigInfo->si_code));

        if (sigInfo->si_errno != 0) {
            log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                "  signal err=%d, \"%s\"",
                sigInfo->si_errno,
                strerror(sigInfo->si_errno));
        }

        if (sigInfo->si_code == SI_USER) {
            pw = getpwuid(sigInfo->si_uid);
            if (pw == NULL) {
                uName = "<unknown>";
            } else {
                uName = pw->pw_name;
            }

            /* It appears that the getsid function was added in version 1.3.44 of the linux kernel. */
            log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                "  signal generated by PID: %d (Session PID: %d), UID: %d (%s)",
                sigInfo->si_pid, getsid(sigInfo->si_pid), sigInfo->si_uid, uName);
        }
    }
}

void sigActionCommon(int sigNum, const char *sigName, siginfo_t *sigInfo, int mode) {
    pthread_t threadId;
    threadId = pthread_self();

    /* All threads will receive a signal.  We want to ignore any signal sent to the timer thread. */
    if (pthread_equal(threadId, timerThreadId)) {
        if (wrapperData->isDebugging) {
            log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                "%s trapped, but signals for timer thread are ignored.", sigName);
        }
    } else {
        if (wrapperData->ignoreSignals) {
            log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                "%s trapped, but ignored.", sigName);
        } else {
            switch (mode) {
            case WRAPPER_SIGNAL_MODE_RESTART:
                log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                    "%s trapped.  Restarting JVM.", sigName);
                wrapperRestartProcess(TRUE);
                break;

            case WRAPPER_SIGNAL_MODE_SHUTDOWN:
                if (wrapperData->exitRequested || wrapperData->restartRequested ||
                    (wrapperData->jState == WRAPPER_JSTATE_STOPPING) ||
                    (wrapperData->jState == WRAPPER_JSTATE_STOPPED) ||
                    (wrapperData->jState == WRAPPER_JSTATE_KILLING) ||
                    (wrapperData->jState == WRAPPER_JSTATE_DOWN)) {
    
                    /* Signalled while we were already shutting down. */
                    log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                        "%s trapped.  Forcing immediate shutdown.", sigName);
    
                    /* Disable the thread dump on exit feature if it is set because it
                     *  should not be displayed when the user requested the immediate exit. */
                    wrapperData->requestThreadDumpOnFailedJVMExit = FALSE;
                    wrapperKillProcess(TRUE);
                } else {
                    log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                        "%s trapped.  Shutting down.", sigName);
                    wrapperStopProcess(TRUE, 0);
                }
                /* Don't actually kill the process here.  Let the application shut itself down */
    
                /* To make sure that the JVM will not be restarted for any reason,
                 *  start the Wrapper shutdown process as well. */
                if ((wrapperData->wState == WRAPPER_WSTATE_STOPPING) ||
                    (wrapperData->wState == WRAPPER_WSTATE_STOPPED)) {
                    /* Already stopping. */
                } else {
                    wrapperSetWrapperState(TRUE, WRAPPER_WSTATE_STOPPING);
                }
                break;

            case WRAPPER_SIGNAL_MODE_FORWARD:
                if (jvmPid > 0) {
                    if (wrapperData->isDebugging) {
                        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                            "%s trapped.  Forwarding to JVM process.", sigName);
                    }
                    if (kill(jvmPid, sigNum)) {
                        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_WARN,
                            "Unable to forward %s signal to JVM process.  %s", sigName, getLastErrorText());
                    }
                } else {
                    log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                        "%s trapped.  Unable to forward signal to JVM because it is not running.", sigName);
                }
                break;

            default: /* WRAPPER_SIGNAL_MODE_IGNORE */
                log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                    "%s trapped, but ignored.", sigName);
                break;
            }
        }
    }
}

/**
 * Handle alarm signals.  We are getting them on solaris when running with
 *  the tick timer.  Not yet sure where they are coming from.
 */
void sigActionAlarm(int sigNum, siginfo_t *sigInfo, void *na) {
    pthread_t threadId;

    /* On UNIX the calling thread is the actual thread being interrupted
     *  so it has already been registered with logRegisterThread. */

    descSignal(sigInfo);

    threadId = pthread_self();

    if (wrapperData->isDebugging) {
        if (pthread_equal(threadId, timerThreadId)) {
            log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                "Timer thread received an Alarm signal.  Ignoring.");
        } else {
            log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                "Received an Alarm signal.  Ignoring.");
        }
    }
}

/**
 * Handle interrupt signals (i.e. Crtl-C).
 */
void sigActionInterrupt(int sigNum, siginfo_t *sigInfo, void *na) {
    /* On UNIX the calling thread is the actual thread being interrupted
     *  so it has already been registered with logRegisterThread. */

    descSignal(sigInfo);

    sigActionCommon(sigNum, "INT", sigInfo, WRAPPER_SIGNAL_MODE_SHUTDOWN);
}

/**
 * Handle quit signals (i.e. Crtl-\).
 */
void sigActionQuit(int sigNum, siginfo_t *sigInfo, void *na) {
    pthread_t threadId;

    /* On UNIX the calling thread is the actual thread being interrupted
     *  so it has already been registered with logRegisterThread. */

    descSignal(sigInfo);

    threadId = pthread_self();

    if (pthread_equal(threadId, timerThreadId)) {
        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
            "Timer thread received an Quit signal.  Ignoring.");
    } else {
        wrapperRequestDumpJVMState(TRUE);
    }
}

/**
 * Handle termination signals (i.e. machine is shutting down).
 */
void sigActionChildDeath(int sigNum, siginfo_t *sigInfo, void *na) {
    /* On UNIX, when a Child process changes state, a SIGCHLD signal is sent to the parent.
     *  The parent should do a wait to make sure the child is cleaned up and doesn't become
     *  a zombie process. */

    descSignal(sigInfo);

    log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
        "Received SIGCHLD, checking JVM process status.");
    if (wrapperGetProcessStatus(TRUE, wrapperGetTicks()) == WRAPPER_PROCESS_UP) {
        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_WARN,
            "JVM process was still running after receiving a SIGCHLD signal.");
    } else {
        /* Handled and logged. */
    }
}

/**
 * Handle termination signals (i.e. machine is shutting down).
 */
void sigActionTermination(int sigNum, siginfo_t *sigInfo, void *na) {
    /* On UNIX the calling thread is the actual thread being interrupted
     *  so it has already been registered with logRegisterThread. */

    descSignal(sigInfo);

    sigActionCommon(sigNum, "TERM", sigInfo, WRAPPER_SIGNAL_MODE_SHUTDOWN);
}

/**
 * Handle hangup signals.
 */
void sigActionHangup(int sigNum, siginfo_t *sigInfo, void *na) {
    /* On UNIX the calling thread is the actual thread being interrupted
     *  so it has already been registered with logRegisterThread. */

    descSignal(sigInfo);

    sigActionCommon(sigNum, "HUP", sigInfo, wrapperData->signalHUPMode);
}

/**
 * Registers a single signal handler.
 */
int registerSigAction(int sigNum, void (*sigAction)(int, siginfo_t *, void *)) {
    struct sigaction newAct;

    newAct.sa_sigaction = sigAction;
    sigemptyset(&newAct.sa_mask);
    newAct.sa_flags = SA_SIGINFO;

    if (sigaction(sigNum, &newAct, NULL)) {
        log_printf_queue(TRUE, WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL,
            "Unable to register signal handler for signal %d.  %s", sigNum, getLastErrorText());
        return 1;
    }
    return 0;
}

/**
 * The main entry point for the timer thread which is started by
 *  initializeTimer().  Once started, this thread will run for the
 *  life of the process.
 *
 * This thread will only be started if we are configured NOT to
 *  use the system time as a base for the tick counter.
 */
void *timerRunner(void *arg) {
    DWORD sysTicks;
    DWORD lastTickOffset = 0;
    DWORD tickOffset;
    long int offsetDiff;
    int first = 1;
    sigset_t signal_mask;
    int rc;

    /* Immediately register this thread with the logger. */
    logRegisterThread(WRAPPER_THREAD_TIMER);

    /* mask signals so the timer doesn't get any of these. */
    sigemptyset(&signal_mask);
    sigaddset(&signal_mask, SIGTERM);
    sigaddset(&signal_mask, SIGINT);
    sigaddset(&signal_mask, SIGQUIT);
    sigaddset(&signal_mask, SIGALRM);
    sigaddset(&signal_mask, SIGHUP);
    rc = pthread_sigmask(SIG_BLOCK, &signal_mask, NULL);
    if (rc != 0) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR, "Could not mask signals for timer thread.");
    }

    if (wrapperData->isTimerOutputEnabled) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "Timer thread started.");
    }

    while (TRUE) {
        wrapperSleep(WRAPPER_TICK_MS);

        /* Get the tick count based on the system time. */
        sysTicks = wrapperGetSystemTicks();

        /* Advance the timer tick count. */
        timerTicks++;

        /* Calculate the offset between the two tick counts. This will always work due to overflow. */
        tickOffset = sysTicks - timerTicks;

        /* The number we really want is the difference between this tickOffset and the previous one. */
        offsetDiff = tickOffset - lastTickOffset;

        if (first) {
            first = 0;
        } else {
            if (offsetDiff > wrapperData->timerSlowThreshold) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_INFO, "The timer fell behind the system clock by %ldms.", offsetDiff * WRAPPER_TICK_MS);
            } else if (offsetDiff < -1 * wrapperData->timerFastThreshold) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_INFO, "The system clock fell behind the timer by %ldms.", -1 * offsetDiff * WRAPPER_TICK_MS);
            }

            if (wrapperData->isTimerOutputEnabled) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                    "    Timer: ticks=%lu, system ticks=%lu, offset=%lu, offsetDiff=%ld",
                    timerTicks, sysTicks, tickOffset, offsetDiff);
            }
        }

        /* Store this tick offset for the next time through the loop. */
        lastTickOffset = tickOffset;
    }

    return NULL;
}

/**
 * Creates a process whose job is to loop and simply increment a ticks
 *  counter.  The tick counter can then be used as a clock as an alternative
 *  to using the system clock.
 */
int initializeTimer() {
    int res;

    if (wrapperData->isTimerOutputEnabled) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "Launching Timer thread.");
    }

    res = pthread_create(
        &timerThreadId,
        NULL, /* No attributes. */
        timerRunner,
        NULL); /* No parameters need to be passed to the thread. */
    if (res) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL,
            "Unable to create a timer thread: %d, %s", res, getLastErrorText());
        return 1;
    } else {
        return 0;
    }
}

/**
 * Execute initialization code to get the wrapper set up.
 */
int wrapperInitializeRun() {
    int retval = 0;
    int res;

    /* Register any signal actions we are concerned with. */
    if (registerSigAction(SIGALRM, sigActionAlarm) ||
        registerSigAction(SIGINT,  sigActionInterrupt) ||
        registerSigAction(SIGQUIT, sigActionQuit) ||
        registerSigAction(SIGCHLD, sigActionChildDeath) ||
        registerSigAction(SIGTERM, sigActionTermination) ||
        registerSigAction(SIGHUP,  sigActionHangup)) {
        retval = -1;
    }

    if (wrapperData->useSystemTime) {
        /* We are going to be using system time so there is no reason to start up a timer thread. */
        timerThreadId = 0;
    } else {
        /* Create and initialize a timer thread. */
        if ((res = initializeTimer()) != 0 ) {
            return res;
        } 
    }

    return retval;
}

/**
 * Cause the current thread to sleep for the specified number of milliseconds.
 *  Sleeps over one second are not allowed.
 */
void wrapperSleep(int ms) {
    /* We want to use nanosleep if it is available, but make it possible for the
       user to build a version that uses usleep if they want.
       usleep does not behave nicely with signals thrown while sleeping.  This
       was the believed cause of a hang experienced on one Solaris system. */
#ifdef USE_USLEEP
    if (wrapperData->isSleepOutputEnabled) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "    Sleep: usleep %dms", ms);
    }
    usleep(ms * 1000); /* microseconds */
#else
    struct timespec ts;
    
    ts.tv_sec = 0;
    ts.tv_nsec = ms * 1000000; /* nanoseconds */
    
    if (wrapperData->isSleepOutputEnabled) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "    Sleep: nanosleep %dms", ms);
    }
    nanosleep(&ts, NULL);
#endif
    
    if (wrapperData->isSleepOutputEnabled) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "    Sleep: awake");
    }
}

void wrapperBuildJavaCommand() {
    char **strings;
    int length, i;

    /* If this is not the first time through, then dispose the old command array */
    if (wrapperData->jvmCommand) {
        i = 0;
        while(wrapperData->jvmCommand[i] != NULL) {
            free(wrapperData->jvmCommand[i]);
            wrapperData->jvmCommand[i] = NULL;
            i++;
        }

        free(wrapperData->jvmCommand);
        wrapperData->jvmCommand = NULL;
    }

    /* Build the Java Command Strings */
    strings = NULL;
    length = 0;
    wrapperBuildJavaCommandArray(&strings, &length, FALSE);
    
    if (wrapperData->commandLogLevel != LEVEL_NONE) {
        for (i = 0; i < length; i++) {
            log_printf(WRAPPER_SOURCE_WRAPPER, wrapperData->commandLogLevel,
                "Command[%d] : %s", i, strings[i]);
        }
    }

    /* Allocate memory to hold array of command strings */
    wrapperData->jvmCommand = malloc(sizeof(char *) * (length + 1)); 
    /*                        number of arguments + 1 for a NULL pointer at the end */
    for (i = 0; i <= length; i++) {
        if (i < length) {
            wrapperData->jvmCommand[i] = malloc(sizeof(char) * (strlen(strings[i]) + 1));
            strcpy(wrapperData->jvmCommand[i], strings[i]);
        } else {
            wrapperData->jvmCommand[i] = NULL;
        }
    }
    
    /* Free up the temporary command array */
    wrapperFreeJavaCommandArray(strings, length);
}

/**
 * Launches a JVM process and stores it internally.
 */
void wrapperExecute() {
    pid_t proc;

    /* Only allocate a pipe if we have not already done so. */
    if (!pipeInitialized) {
        /* Create the pipe. */
        if (pipe (pipedes) < 0) {
            log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                       "Could not init pipe: %s", getLastErrorText());
            return;
        }
        pipeInitialized = 1;
    }
    
    /* Make sure the log file is closed before the Java process is created.  Failure to do
     *  so will give the Java process a copy of the open file.  This means that this process
     *  will not be able to rename the file even after closing it because it will still be
     *  open in the Java process.  Also set the auto close flag to make sure that other
     *  threads do not reopen the log file as the new process is being created. */
    setLogfileAutoClose(TRUE);
    closeLogfile();
    
    /* Fork off the child. */
    proc = fork();
    
    if (proc == -1) {
        /* Fork failed. */
        
        /* Restore the auto close flag. */
        setLogfileAutoClose(wrapperData->logfileInactivityTimeout <= 0);

        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL,
                   "Could not spawn JVM process: %s", getLastErrorText());
        
        /* The pipedes array is global so do not close the pipes. */

    } else {
        /* Reset the exit code when we launch a new JVM. */
        wrapperData->exitCode = 0;
        
        /* Fork succeeded: increment the process ID for logging. */
        wrapperData->jvmRestarts++;

        if (proc == 0) {
            /* We are the child side. */
            
            /* Set the umask of the JVM */
            umask(wrapperData->javaUmask);
            
            /* The logging code causes some log corruption if logging is called from the
             *  child of a fork.  Not sure exactly why but most likely because the forked
             *  child receives a copy of the mutex and thus synchronization is not working.
             * It is ok to log errors in here, but avoid output otherwise. */
            
            /* Send output to the pipe by dupicating the pipe fd and setting the copy as the stdout fd. */
            if (dup2(pipedes[STDOUT_FILENO], STDOUT_FILENO) < 0) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                           "Unable to set JVM's stdout: %s", getLastErrorText());
                return;
            }
        
            /* Send errors to the pipe by dupicating the pipe fd and setting the copy as the stderr fd. */
            if (dup2(pipedes[STDOUT_FILENO], STDERR_FILENO) < 0) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                           "Unable to set JVM's stderr: %s", getLastErrorText());
                return;
            }

            /* The pipedes array is global so do not close the pipes. */
            
            /* Child process: execute the JVM. */
            execvp(wrapperData->jvmCommand[0], wrapperData->jvmCommand);
            
            /* We reached this point...meaning we were unable to start. */
            log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                "Unable to start JVM: %s (%d)", getLastErrorText(), errno);
            
            /* This process needs to end. */
            exit(1);
        } else {
            /* We are the parent side. */
            jvmPid = proc;
            jvmOut = pipedes[STDIN_FILENO];
            
            /* Restore the auto close flag. */
            setLogfileAutoClose(wrapperData->logfileInactivityTimeout <= 0);

            /* The pipedes array is global so do not close the pipes. */
            
            /* Mark our side of the pipe so that it won't block
             * and will close on exec, so new children won't see it. */
            if (fcntl(jvmOut, F_SETFL, O_NONBLOCK) < 0) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                    "Failed to set jvm output handle to non blocking mode: %s (%d)",
                    getLastErrorText(), errno);
            }
            if (fcntl(jvmOut, F_SETFD, FD_CLOEXEC) < 0) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                    "Failed to set jvm output handle to close on JVM exit: %s (%d)",
                    getLastErrorText(), errno);
            }

            /* If a java pid filename is specified then write the pid of the java process. */
            if (wrapperData->javaPidFilename) {
                if (writePidFile(wrapperData->javaPidFilename, jvmPid, wrapperData->javaPidFileUmask)) {
                    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_WARN,
                        "Unable to write the Java PID file: %s", wrapperData->javaPidFilename);
                }
            }

            /* If a java id filename is specified then write the pid of the java process. */
            if (wrapperData->javaIdFilename) {
                if (writePidFile(wrapperData->javaIdFilename, wrapperData->jvmRestarts, wrapperData->javaIdFileUmask)) {
                    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_WARN,
                        "Unable to write the Java ID file: %s", wrapperData->javaIdFilename);
                }
            }
        }
    }
}

/**
 * Returns a tick count that can be used in combination with the
 *  wrapperGetTickAge() function to perform time keeping.
 */
DWORD wrapperGetTicks() {
    if (wrapperData->useSystemTime) {
        /* We want to return a tick count that is based on the current system time. */
        return wrapperGetSystemTicks();

    } else {
        /* Return a snapshot of the current tick count. */
        return timerTicks;
    }
}

/**
 * Returns the PID of the Wrapper process.
 */
int wrapperGetPID() {
    return (int)getpid();
}

/**
 * Outputs a log entry at regular intervals to track the memory usage of the
 *  Wrapper and its JVM.
 */
void wrapperDumpMemory() {
    /* Not yet implemented on UNIX platforms. */
}

/**
 * Outputs a log entry at regular intervals to track the CPU usage over each
 *  interval for the Wrapper and its JVM.
 */
void wrapperDumpCPUUsage() {
    struct rusage wUsage;
    struct rusage jUsage;

    if (getrusage(RUSAGE_SELF, &wUsage)) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
            "Call to getrusage failed for Wrapper process: %s", getLastErrorText());
        return;
    }
    if (getrusage(RUSAGE_CHILDREN, &jUsage)) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
            "Call to getrusage failed for Java process: %s", getLastErrorText());
        return;
    }

    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
        "Wrapper CPU: system %ld.%03ld, user %ld.%03ld  Java CPU: system %ld.%03ld, user %ld.%03ld",
        wUsage.ru_stime.tv_sec, wUsage.ru_stime.tv_usec / 1000,
        wUsage.ru_utime.tv_sec, wUsage.ru_utime.tv_usec / 1000,
        jUsage.ru_stime.tv_sec, jUsage.ru_stime.tv_usec / 1000,
        jUsage.ru_utime.tv_sec, jUsage.ru_utime.tv_usec / 1000);
}

/**
 * Checks on the status of the JVM Process.
 * Returns WRAPPER_PROCESS_UP or WRAPPER_PROCESS_DOWN
 */
int wrapperGetProcessStatus(int useLoggerQueue, DWORD nowTicks) {
    int retval;
    int status;
    int exitCode;
    int res;

    retval = waitpid(jvmPid, &status, WNOHANG);
    if (retval == 0) {
        /* Still up and running. */
        res = WRAPPER_PROCESS_UP;
    } else {
        if (retval < 0) {
            if (errno == ECHILD) {
                /* Process is gone.  Happens after a SIGCHLD is handled. Normal. */
            } else {
                /* Error requesting the status. */
                log_printf_queue(useLoggerQueue, WRAPPER_SOURCE_WRAPPER, LEVEL_WARN,
                    "Unable to request JVM process status: %s", getLastErrorText());
            }
        }

        /* JVM has exited. */
        res = WRAPPER_PROCESS_DOWN;

        /* Get the exit code of the process. */
        if (WIFEXITED(status)) {
            exitCode = WEXITSTATUS(status);
        } else if (WIFSIGNALED(status)) {
            log_printf_queue(useLoggerQueue, WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                "JVM exited in response to signal %s (%d).", getSignalName(WTERMSIG(status)), WTERMSIG(status));
            exitCode = 1;
        } else {
            log_printf_queue(useLoggerQueue, WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG,
                "WIFEXITED indicates that the JVM exited abnormally.");
            exitCode = 1;
        }

        wrapperJVMProcessExited(useLoggerQueue, nowTicks, exitCode);
    }
    
    return res;
}

/**
 * This function does nothing on Unix machines.
 */
void wrapperReportStatus(int useLoggerQueue, int status, int errorCode, int waitHint) {
    return;
}

char *childOutputBuffer = NULL;
int childOutputBufferSize = 0;
/**
 * Make sure there is enough space in the outputBuffer.
 */
void ensureSpaceInChildOutputBuffer(int childOutputBufferPos, int requiredSpace) {
    char *tempBuf;
    
    if ( childOutputBufferPos >= childOutputBufferSize - requiredSpace ) {
        tempBuf = malloc(sizeof(char) * (childOutputBufferSize + 1024));
        if (childOutputBuffer != NULL) {
            /* Copy over the old data */
            memcpy(tempBuf, childOutputBuffer, childOutputBufferSize);
            tempBuf[childOutputBufferSize - 1] = '\0';
            free(childOutputBuffer);
            childOutputBuffer = NULL;
        } 
        childOutputBuffer = tempBuf;
        childOutputBufferSize += 1024;
    }
}

/**
 * Read and process any output from the child JVM Process.
 * Most output should be logged to the wrapper log file.
 *
 * This function will only be allowed to run for 250ms before returning.  This is to
 *  make sure that the main loop gets CPU.  If there is more data in the pipe, then
 *  the function returns -1, otherwise 0.  This is a hint to the mail loop not to
 *  sleep.
 */
int wrapperReadChildOutput() {
    int readSize;
    ssize_t bytesRead;
    char readBuf [1025];
    int readBufPos, childOutputBufferPos;
    struct timeb timeBuffer;
    long startTime;
    int startTimeMillis;
    long now;
    int nowMillis;
    long durr;
    
    if (jvmOut != -1) {
        wrapperGetCurrentTime(&timeBuffer);
        startTime = now = timeBuffer.time;
        startTimeMillis = nowMillis = timeBuffer.millitm;

        /*
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG, "now=%ld, nowMillis=%d", now, nowMillis);
        */

        /* Loop and read as much input as is available.  When a large amount of output is
         *  being piped from the JVM this can lead to the main event loop not getting any
         *  CPU for an extended period of time.  To avoid that problem, this loop is only
         *  allowed to cycle for 250ms before returning.  After 250ms, switch to a less
         *  efficient method of reading data because we need to make sure that we have
         *  not read past a line break before returning. */
        childOutputBufferPos = 0;
        while(1) {
            /*
            log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG, "durr=%ld", durr);
            */

            if ((durr = (now - startTime) * 1000 + (nowMillis - startTimeMillis)) < 250) {
                readSize = 1024;
            } else {
                readSize = 1;
            }

#if defined OPENBSD || defined FREEBSD
            /* Work around FreeBSD Bug #kern/64313
             *  http://www.freebsd.org/cgi/query-pr.cgi?pr=kern/64313
             *
             * When linked with the pthreads library the O_NONBLOCK flag is being reset
             *  on the jvmOut handle.  Not sure yet of the exact event that is causing
             *  this, but once it happens reads will start to block even though calls
             *  to fcntl(jvmOut, F_GETFL) say that the O_NONBLOCK flag is set.
             * Calling fcntl(jvmOut, F_SETFL, O_NONBLOCK) again will set the flag back
             *  again and cause it to start working correctly.  This may only need to
             *  be done once, however, because F_GETFL does not return the accurate
             *  state there is no reliable way to check.  Be safe and always set the
             *  flag. */
            if (fcntl(jvmOut, F_SETFL, O_NONBLOCK) < 0) {
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                    "Failed to set jvm output handle to non blocking mode: %s (%d)",
                    getLastErrorText(), errno);
            }
#endif

            /* Fill read buffer. */
            bytesRead = read(jvmOut, readBuf, readSize);

            if (bytesRead <= 0) {
                /* No more bytes available, return for now.  But make sure that this was not an error. */
                if ( errno == EAGAIN ) {
                    /* Normal, the call would have blocked as there is no data available. */
                } else {
                    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                        "Failed to read console output from the JVM: %s (%d)",
                        getLastErrorText(), errno);
                }

                if (childOutputBufferPos > 0) {
                    /* We have a partial line, write it out so it is not lost. */
                    ensureSpaceInChildOutputBuffer( childOutputBufferPos, 1 );
                    childOutputBuffer[childOutputBufferPos] = '\0';
                    wrapperLogChildOutput(childOutputBuffer);
                    childOutputBufferPos = 0;
                } 

                break;
            }

            /* Terminate the read buffer. */
            readBuf[bytesRead] = '\0';
        
            /* Step through chars in read buffer. */
            for (readBufPos = 0; readBufPos < bytesRead; readBufPos++) {
                if (readBuf[readBufPos] == (char)0x0a) {
                    /* Line feed; write out buffer and reset it. */
                    ensureSpaceInChildOutputBuffer( childOutputBufferPos, 1 );
                    childOutputBuffer[childOutputBufferPos] = '\0';
                    wrapperLogChildOutput(childOutputBuffer);
                    childOutputBufferPos = 0;

                    if ( readSize == 1 ) {
                        /* This last line was read byte by byte, now exit. */
                        return -1;
                    }
                } else {
                    ensureSpaceInChildOutputBuffer( childOutputBufferPos, 2 );

                    /* Add character to write buffer. */
                    childOutputBuffer[childOutputBufferPos++] = readBuf[readBufPos];
                }
            }

            /* Get the time again */
            wrapperGetCurrentTime(&timeBuffer);
            now = timeBuffer.time;
            nowMillis = timeBuffer.millitm;
        }
    }
    
    return 0;
}

/**
 * Kill the JVM Process immediately and set the JVM State to WRAPPER_JSTATE_DOWN
 */
void wrapperKillProcessNow() {
    /* Check to make sure that the JVM process is still running */
    if (waitpid(jvmPid, NULL, WNOHANG) == 0) {
        /* JVM is still up when it should have already stopped itself. */

        /* The JVM process is not responding so the only choice we have is to
         *  kill it. */
        if (kill(jvmPid, SIGKILL)) {
            log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR, "JVM did not exit on request.");
            log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR,
                "  Attempt to terminate process failed: %s", getLastErrorText());
        } else {
            log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR, "JVM did not exit on request, terminated");
        }

        /* Give the JVM a chance to be killed so that the state will be correct. */
        wrapperSleep(500); /* 0.5 seconds */

        /* Set the exit code since we were forced to kill the JVM. */
        wrapperData->exitCode = 1;
    }

    wrapperSetJavaState(FALSE, WRAPPER_JSTATE_DOWN, -1, -1);
    jvmPid = -1;

    /* Remove java pid file if it was registered and created by this process. */
    if (wrapperData->javaPidFilename) {
        unlink(wrapperData->javaPidFilename);
    }

    /* Close any open socket to the JVM */
    wrapperProtocolClose();
}

/**
 * Puts the Wrapper into a state where the JVM will be killed at the soonest
 *  possible oportunity.  It is necessary to wait a moment if a final thread
 *  dump is to be requested.  This call wll always set the JVM state to
 *  WRAPPER_JSTATE_KILLING.
 */
void wrapperKillProcess(int useLoggerQueue) {
    int delay = 0;

    /* Check to make sure that the JVM process is still running */
    if (waitpid(jvmPid, NULL, WNOHANG) == 0) {
        /* JVM is still up when it should have already stopped itself. */
        if (wrapperData->requestThreadDumpOnFailedJVMExit) {
            wrapperRequestDumpJVMState(useLoggerQueue);
            
            delay = 5;
        }
    }

    wrapperSetJavaState(useLoggerQueue, WRAPPER_JSTATE_KILLING, wrapperGetTicks(), delay);
}

/**
 * Transform a program into a daemon.
 * Inspired by code from GNU monit, which in turn, was
 * inspired by code from Stephen A. Rago's book,
 * Unix System V Network Programming.
 *
 * The idea is to first fork, then make the child a session leader,
 * and then fork again, so that it, (the session group leader), can
 * exit. This means that we, the grandchild, as a non-session group
 * leader, can never regain a controlling terminal.
 */
void daemonize() {
    pid_t pid;
    int fd;
    
    /* Set the auto close flag and close the logfile before doing any forking to avoid
     *  duplicate open files. */
    setLogfileAutoClose(TRUE);
    closeLogfile();
    
    /* first fork */
    if (wrapperData->isDebugging) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG, "Spawning intermediate process...");
    }	
    if ((pid = fork()) < 0) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR, "Could not spawn daemon process: %s",
            getLastErrorText());
        appExit(1);
    } else if (pid != 0) {
        /* Intermediate process is now running.  This is the original process, so exit. */
        
        /* If the main process was not launched in the background, then we want to make
         * the console output look nice by making sure that all output from the
         * intermediate and daemon threads are complete before this thread exits.
         * Sleep for 0.5 seconds. */
        wrapperSleep(500);
        
        /* Call exit rather than appExit as we are only exiting this process. */
        exit(0);
    }
    
    /* become session leader */
    if (setsid() == -1) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR, "setsid() failed: %s",
           getLastErrorText());
        appExit(1);
    }
    
    signal(SIGHUP, SIG_IGN); /* don't let future opens allocate controlling terminals */
    
    /* Redirect stdin, stdout and stderr before closing to prevent the shell which launched
     *  the Wrapper from hanging when it exits. */
    fd = open("/dev/null", O_RDWR, 0);
    if (fd != -1) {
        close(STDIN_FILENO);
        dup2(fd, STDIN_FILENO);
        close(STDOUT_FILENO);
        dup2(fd, STDOUT_FILENO);
        close(STDERR_FILENO);
        dup2(fd, STDERR_FILENO);
        if (fd != STDIN_FILENO &&
            fd != STDOUT_FILENO &&
            fd != STDERR_FILENO) {
            close(fd);
        }
    }
    /* Console output was disabled above, so make sure the console log output is disabled
     *  so we don't waste any CPU formatting and sending output to '/dev/null'/ */
    setConsoleLogLevelInt(LEVEL_NONE);
    
    /* second fork */
    if (wrapperData->isDebugging) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG, "Spawning daemon process...");
    }	
    if ((pid = fork()) < 0) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_ERROR, "Could not spawn daemon process: %s",
            getLastErrorText());
        appExit(1);
    } else if (pid != 0) {
        /* Daemon process is now running.  This is the intermediate process, so exit. */
        /* Call exit rather than appExit as we are only exiting this process. */
        exit(0);
    }
    
    /* Restore the auto close flag in the daemonized process. */
    setLogfileAutoClose(wrapperData->logfileInactivityTimeout <= 0);
} 


/**
 * Sets the working directory to that of the current executable
 */
int setWorkingDir(char *app) {
    char szPath[PATH_MAX];
    char* pos;
    
    /* Get the full path and filename of this program */
    if (realpath(app, szPath) == NULL) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL, "Unable to get the path for '%s'-%s",
            app, getLastErrorText());
        return 1;
    }

    /* The wrapperData->isDebugging flag will never be set here, so we can't really use it. */
#ifdef _DEBUG
    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_DEBUG, "Executable Name: %s", szPath);
#endif

    /* To get the path, strip everything off after the last '\' */
    pos = strrchr(szPath, '/');
    if (pos == NULL) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL, "Unable to extract path from: %s", szPath);
        return 1;
    } else {
        /* Clip the path at the position of the last backslash */
        pos[0] = (char)0;
    }

    if (chdir(szPath)) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL,
            "Unable to set working dir to %s : %s", szPath, getLastErrorText());
        return 1;
    }

    return 0;
}

/*******************************************************************************
 * Main function                                                               *
 *******************************************************************************/

int main(int argc, char **argv) {
#ifdef _DEBUG
    int i;
#endif

    if (wrapperInitialize()) {
        appExit(1);
        return 1; /* For compiler. */
    }

    /* Immediately register this thread with the logger. */
    logRegisterThread(WRAPPER_THREAD_MAIN);

#ifdef _DEBUG
    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "Wrapper DEBUG build!");
    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "Logging initialized.");
#endif

    if (setWorkingDir(argv[0])) {
        appExit(1);
        return 1; /* For compiler. */
    }
#ifdef _DEBUG
    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "Working directory set.");
    log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "Arguments:");
    for ( i = 0; i < argc; i++ ) {
        log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS, "  argv[%d]=%s", i, argv[i]);
    }
#endif

    /* Parse the command and configuration file from the command line. */
    if (!wrapperParseArguments(argc, argv)) {
        appExit(1);
        return 1; /* For compiler. */
    }

    /* At this point, we have a command, confFile, and possibly additional arguments. */
    if (!strcmpIgnoreCase(wrapperData->argCommand,"?") || !strcmpIgnoreCase(wrapperData->argCommand,"-help")) {
        /* User asked for the usage. */
        wrapperUsage(argv[0]);
        appExit(0);
        return 0; /* For compiler. */
    } else if (!strcmpIgnoreCase(wrapperData->argCommand,"v") || !strcmpIgnoreCase(wrapperData->argCommand,"-version")) {
        /* User asked for version. */
        wrapperVersionBanner();
        appExit(0);
        return 0; /* For compiler. */
    }

    /* Load the properties. */
    if (wrapperLoadConfigurationProperties()) {
        /* Unable to load the configuration.  Any errors will have already
         *  been reported. */
        if (wrapperData->argConfFileDefault && !wrapperData->argConfFileFound) {
            /* The config file that was being looked for was default and
             *  it did not exist.  Show the usage. */
            wrapperUsage(argv[0]);
        }
        appExit(1);
        return 1; /* For compiler. */
    }

    /* Change the working directory if configured to do so. */
    if (wrapperSetWorkingDirProp()) {
        appExit(1);
        return 1; /* For compiler. */
    }

    /* Set the default umask of the Wrapper process. */
    umask(wrapperData->umask);

    if(!strcmpIgnoreCase(wrapperData->argCommand,"c") || !strcmpIgnoreCase(wrapperData->argCommand,"-console")) {
        /* Run as a console application */

        /* fork to a Daemonized process if configured to do so. */
        if (wrapperData->daemonize) {
            daemonize();
        }

        /* See if the logs should be rolled on Wrapper startup. */
        if ((getLogfileRollMode() & ROLL_MODE_WRAPPER) ||
            (getLogfileRollMode() & ROLL_MODE_JVM)) {
            rollLogs();
        }

        /* Write pid and anchor files as requested.  If they are the same file the file is
         *  simply overwritten. */
        if (wrapperData->anchorFilename) {
            if (writePidFile(wrapperData->anchorFilename, (int)getpid(), wrapperData->anchorFileUmask)) {
                log_printf
                    (WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL,
                     "ERROR: Could not write anchor file %s: %s",
                     wrapperData->anchorFilename, getLastErrorText());
                appExit(1);
                return 1; /* For compiler. */
            }
        }
        if (wrapperData->pidFilename) {
            if (writePidFile(wrapperData->pidFilename, (int)getpid(), wrapperData->pidFileUmask)) {
                log_printf
                    (WRAPPER_SOURCE_WRAPPER, LEVEL_FATAL,
                     "ERROR: Could not write pid file %s: %s",
                     wrapperData->pidFilename, getLastErrorText());
                appExit(1);
                return 1; /* For compiler. */
            }
        }
        if (wrapperData->lockFilename) {
            if (writePidFile(wrapperData->lockFilename, (int)getpid(), wrapperData->lockFileUmask)) {
                /* This will fail if the user is running as a user without full privileges.
                 *  To make things easier for user configuration, this is ignored if sufficient
                 *  privileges do not exist. */
                log_printf(WRAPPER_SOURCE_WRAPPER, LEVEL_STATUS,
                     "WARNING: Could not write lock file %s: %s",
                     wrapperData->lockFilename, getLastErrorText());
                wrapperData->lockFilename = NULL;
            }
        }

        appExit(wrapperRunConsole());
        return 0; /* For compiler. */
    } else {
        printf("\nUnrecognized option: -%s\n", wrapperData->argCommand);
        wrapperUsage(argv[0]);
        appExit(1);
        return 1; /* For compiler. */
    }
}

#endif /* ifndef WIN32 */
