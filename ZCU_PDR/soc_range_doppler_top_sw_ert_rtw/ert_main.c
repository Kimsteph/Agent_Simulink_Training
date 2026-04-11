/*
 * File: ert_main.c
 *
 * Code generated for Simulink model 'soc_range_doppler_top_sw'.
 *
 * Model version                  : 1.1
 * Simulink Coder version         : 25.2 (R2025b) 28-Jul-2025
 * C/C++ source code generated on : Fri Mar 20 11:44:57 2026
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex-A (64-bit)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include <stdio.h>
#include <stdlib.h>
#include "soc_range_doppler_top_sw.h"
#include "soc_range_doppler_top_sw_private.h"
#include "rtwtypes.h"
#include "limits.h"
#include "linuxinitialize.h"
#define UNUSED(x)                      x = x
#define NAMELEN                        16

void exitFcn(int_T sig);
void *terminateTask(void *arg);
void *baseRateTask(void *arg);
void *subrateTask(void *arg);
void *schedulerTask(void *arg);
void *SOCB_RateCounterTask(void);
volatile boolean_T stopRequested = false;
volatile boolean_T runModel = true;
sem_t stopSem;
sem_t baserateTaskSem;
sem_t SOCB_RateSchedulerSem;
sem_t subrateTaskSem[2];
int_T taskId[2];
int_T SOCB_RateTriggerCounter[3] = { 0 };

pthread_t baseRateThread;
pthread_t schedulerThread;
pthread_t SOCB_RateSchedulerThread;
pthread_t backgroundThread;
void *threadJoinStatus;
int_T terminatingmodel = 0;
pthread_t subRateThread[2];
int_T subratePriority[2];
int_T coreAffinityBaseRate;
int_T coreAffinity[2];
uint16_T SOCB_RateDependencies[0] = {
};

uint16_T SOCB_RateStart[3] = {
  0,
  0,
  0,
};

uint16_T SOCB_RateLength[3] = {
  0,
  0,
  0,
};

#define SOCB_RATE_TASK_WAITING         0
#define SOCB_RATE_TASK_READY           1
#define SOCB_RATE_TASK_RUNNING         2

uint16_T SOCB_RateTaskState[3] = { SOCB_RATE_TASK_WAITING };

uint16_T SOCB_DropOverranRate[3] = {
  0,
  0,
  0,
};

uint16_T SOCB_RateTimerEventCounter[3] = {
  1,
  1,
  1,
};

uint16_T SOCB_RateTimerEventCounterTrigVal[3] = {
  1,
  10,
  200,
};

boolean_T mw_RateClearToRun(uint16_T i)
{
  uint16_T j;
  uint16_T running = 0;
  for (j=SOCB_RateStart[i]; j<SOCB_RateStart[i]+SOCB_RateLength[i]; j++) {
    running = running || SOCB_RateTaskState[SOCB_RateDependencies[j]];
  }

  return (boolean_T) (!running);
}

void *SOCB_RateCounterFcn(void)
{
  uint16_T i;
  SOCB_RateTriggerCounter[0]++;
  if ((SOCB_DropOverranRate[0]) && (SOCB_RateTaskState[0])) {
    SOCB_RateTriggerCounter[0]--;
  } else if (SOCB_RateTriggerCounter[0] > 2) {
    SOCB_RateTriggerCounter[0]--;
  }

  for (i=0; i < 2; i++) {
    if (--SOCB_RateTimerEventCounter[i+1] == 0) {
      SOCB_RateTimerEventCounter[i+1] = SOCB_RateTimerEventCounterTrigVal[i+1];
      SOCB_RateTriggerCounter[i+1]++;
      if ((SOCB_DropOverranRate[i+1]) && (SOCB_RateTaskState[i+1])) {
        SOCB_RateTriggerCounter[i+1]--;
      } else if (SOCB_RateTriggerCounter[i+1] > 2) {
        SOCB_RateTriggerCounter[i+1]--;
      }
    }
  }

  sem_post(&SOCB_RateSchedulerSem);
}

void *schedulerTask(void *arg)
{
  uint16_T i;
  while (runModel) {
    sem_wait(&SOCB_RateSchedulerSem);
    if ((SOCB_RateTriggerCounter[0] > 0) && (SOCB_RateTaskState[0] !=
         SOCB_RATE_TASK_RUNNING)) {
      SOCB_RateTaskState[0] = SOCB_RATE_TASK_RUNNING;
      SOCB_RateTriggerCounter[0]--;
      sem_post(&baserateTaskSem);
    }

    for (i=0; i < 2; i++) {
      if ((SOCB_RateTriggerCounter[i+1] > 0) && (SOCB_RateTaskState[i+1] !=
           SOCB_RATE_TASK_RUNNING)) {
        SOCB_RateTaskState[i+1] = SOCB_RATE_TASK_READY;
        if (mw_RateClearToRun(i+1)) {
          SOCB_RateTaskState[i+1] = SOCB_RATE_TASK_RUNNING;
          SOCB_RateTriggerCounter[i+1]--;
          sem_post(&subrateTaskSem[i]);
        }
      }
    }
  }
}

void *baseRateTask(void *arg)
{
  int_T i;
  runModel = (rtmGetErrorStatus(soc_range_doppler_top_sw_M) == (NULL)) &&
    !rtmGetStopRequested(soc_range_doppler_top_sw_M);
  while (runModel) {
    sem_wait(&baserateTaskSem);

    /* External mode */
    {
      boolean_T rtmStopReq = false;
      rtExtModePauseIfNeeded(soc_range_doppler_top_sw_M->extModeInfo, 3,
        &rtmStopReq);
      if (rtmStopReq) {
        rtmSetStopRequested(soc_range_doppler_top_sw_M, true);
      }

      if (rtmGetStopRequested(soc_range_doppler_top_sw_M) == true) {
        rtmSetErrorStatus(soc_range_doppler_top_sw_M, "Simulation finished");
        break;
      }
    }

    soc_range_doppler_top_sw_step(0);

    /* Get model outputs here */
    rtExtModeCheckEndTrigger();
    stopRequested = !((rtmGetErrorStatus(soc_range_doppler_top_sw_M) == (NULL)) &&
                      !rtmGetStopRequested(soc_range_doppler_top_sw_M));
    runModel = !stopRequested;
    SOCB_RateTaskState[0] = SOCB_RATE_TASK_WAITING;
    sem_post(&SOCB_RateSchedulerSem);
  }

  terminateTask(arg);
  pthread_exit((void *)0);
  return NULL;
}

void *subrateTask(void *arg)
{
  int_T tid = *((int_T *) arg);
  int_T subRateId;
  subRateId = tid + 1;
  while (runModel) {
    sem_wait(&subrateTaskSem[tid]);
    if (terminatingmodel)
      break;
    soc_range_doppler_top_sw_step(subRateId);

    /* Get model outputs here */
    SOCB_RateTaskState[subRateId] = SOCB_RATE_TASK_WAITING;
    sem_post(&SOCB_RateSchedulerSem);
  }

  pthread_exit((void *)0);
  return NULL;
}

void exitFcn(int_T sig)
{
  UNUSED(sig);
  rtmSetErrorStatus(soc_range_doppler_top_sw_M, "stopping the model");
}

void *terminateTask(void *arg)
{
  UNUSED(arg);
  terminatingmodel = 1;

  {
    int_T i;

    /* Signal all periodic tasks to complete */
    for (i=0; i<2; i++) {
      CHECK_STATUS(sem_post(&subrateTaskSem[i]), 0, "sem_post");
      CHECK_STATUS(sem_destroy(&subrateTaskSem[i]), 0, "sem_destroy");
    }

    /* Wait for all periodic tasks to complete */
    for (i=0; i<2; i++) {
      CHECK_STATUS(pthread_join(subRateThread[i], &threadJoinStatus), 0,
                   "pthread_join");
    }

    runModel = 0;

    /* Wait for background task to complete */
    CHECK_STATUS(pthread_join(backgroundThread, &threadJoinStatus), 0,
                 "pthread_join");
  }

  /* Terminate model */
  soc_range_doppler_top_sw_terminate();
  rtExtModeShutdown(3);
  sem_post(&stopSem);
  return NULL;
}

void *backgroundTask(void *arg)
{
  while (runModel) {
    /* External mode */
    {
      boolean_T rtmStopReq = false;
      rtExtModeOneStep(soc_range_doppler_top_sw_M->extModeInfo, 3, &rtmStopReq);
      if (rtmStopReq) {
        rtmSetStopRequested(soc_range_doppler_top_sw_M, true);
      }
    }
  }

  return NULL;
}

int main(int argc, char **argv)
{
  coreAffinityBaseRate = 0;
  subratePriority[0] = 39;
  coreAffinity[0] = 2;
  subratePriority[1] = 38;
  coreAffinity[1] = 0;
  rtmSetErrorStatus(soc_range_doppler_top_sw_M, 0);
  rtExtModeParseArgs(argc, (const char_T **)argv, NULL);

  /* Initialize model */
  soc_range_doppler_top_sw_initialize();

  /* External mode */
  rtSetTFinalForExtMode(&rtmGetTFinal(soc_range_doppler_top_sw_M));
  rtExtModeCheckInit(3);

  {
    boolean_T rtmStopReq = false;
    rtExtModeWaitForStartPkt(soc_range_doppler_top_sw_M->extModeInfo, 3,
      &rtmStopReq);
    if (rtmStopReq) {
      rtmSetStopRequested(soc_range_doppler_top_sw_M, true);
    }
  }

  rtERTExtModeStartMsg();

  /* Call RTOS Initialization function */
  myRTOSInit(0.001, 2);

  /* Wait for stop semaphore */
  sem_wait(&stopSem);

#if (MW_NUMBER_TIMER_DRIVEN_TASKS > 0)

  {
    int_T i;
    for (i=0; i < MW_NUMBER_TIMER_DRIVEN_TASKS; i++) {
      CHECK_STATUS(sem_destroy(&timerTaskSem[i]), 0, "sem_destroy");
    }
  }

#endif

  CHECK_STATUS(sem_destroy(&SOCB_RateSchedulerSem), 0, "sem_destroy");
  return 0;
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
