#ifndef _MW_CUSTOM_RTOS_HEADER_H_
#define _MW_CUSTOM_RTOS_HEADER_H_
#define MW_BASERATE_PRIORITY           40
#define MW_BASERATE_PERIOD             0.001
#define MW_NUMBER_SUBRATES             2
#define MW_IS_CONCURRENT               1
#define MW_NUMBER_TIMER_DRIVEN_TASKS   0
#define COREAFFINITYREQUIRED

extern int_T coreAffinityBaseRate;
extern int_T coreAffinity[];

#define MW_HAS_MULTIPLE_RATES
#define MW_SOC_ENABLED
#define MW_NUM_CORES                   4
#define MW_NUM_APERIODIC_PROXY_TASKS   0

extern void exitFcn(int_T sig);
extern void *terminateTask(void *arg);
extern void *baseRateTask(void *arg);
extern void *subrateTask(void *arg);
extern void *SOCB_RateCounterFcn(void);
extern void *schedulerTask(void *arg);

#define MW_NEEDS_BACKGROUND_TASK
#define MW_BACKGROUNDTASK_PRIORITY     37

extern void *backgroundTask(void *arg);
extern pthread_t backgroundThread;
extern pthread_t SOCB_RateSchedulerThread;
extern pthread_t schedulerThread;
extern pthread_t baseRateThread;
extern pthread_t subRateThread[];
extern sem_t stopSem;
extern sem_t SOCB_RateSchedulerSem;
extern sem_t baserateTaskSem;
extern sem_t subrateTaskSem[];
extern int_T taskId[];
extern int_T subratePriority[];

#endif

#define MW_MAX_TASKNAME                16
#define MW_TSKMGR_EVENT_DRIVEN_TASKS   2
#define MW_TSKMGR_TIMER_DRIVEN_TASKS   3

const char_T * _mwTskMgrTimerDrivenTaskNames[MW_MAX_TASKNAME] = {
  "Discrete_1",
  "_socbTT2",
  "_socbTT3"
};
