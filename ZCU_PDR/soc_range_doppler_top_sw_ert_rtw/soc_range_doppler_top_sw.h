/*
 * File: soc_range_doppler_top_sw.h
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

#ifndef soc_range_doppler_top_sw_h_
#define soc_range_doppler_top_sw_h_
#ifndef soc_range_doppler_top_sw_COMMON_INCLUDES_
#define soc_range_doppler_top_sw_COMMON_INCLUDES_
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <semaphore.h>
#include <errno.h>
#include <stdio.h>
#include <limits.h>
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "dt_info.h"
#include "ext_work.h"
#endif                           /* soc_range_doppler_top_sw_COMMON_INCLUDES_ */

#include "soc_range_doppler_top_sw_types.h"
#include <float.h>
#include <string.h>
#include <stddef.h>

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
#define rtmGetFinalTime(rtm)           ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWExtModeInfo
#define rtmGetRTWExtModeInfo(rtm)      ((rtm)->extModeInfo)
#endif

#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetErrorStatusPointer
#define rtmGetErrorStatusPointer(rtm)  ((const char_T **)(&((rtm)->errorStatus)))
#endif

#ifndef rtmStepTask
#define rtmStepTask(rtm, idx)          ((rtm)->Timing.TaskCounters.TID[(idx)] == 0)
#endif

#ifndef rtmGetStopRequested
#define rtmGetStopRequested(rtm)       ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
#define rtmSetStopRequested(rtm, val)  ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
#define rtmGetStopRequestedPtr(rtm)    (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
#define rtmGetT(rtm)                   ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
#define rtmGetTFinal(rtm)              ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTPtr
#define rtmGetTPtr(rtm)                (&(rtm)->Timing.taskTime0)
#endif

#ifndef rtmTaskCounter
#define rtmTaskCounter(rtm, idx)       ((rtm)->Timing.TaskCounters.TID[(idx)])
#endif

/* Block signals (default storage) */
typedef struct {
  real_T Reshape;                      /* '<Root>/Reshape' */
  real_T ProcessorModel_o1;            /* '<Root>/Processor Model' */
  real_T ProcessorModel_o2;            /* '<Root>/Processor Model' */
} B_soc_range_doppler_top_sw_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  struct {
    void *LoggedData;
  } Scope_PWORK;                       /* '<Root>/Scope' */
} DW_soc_range_doppler_top_sw_T;

/* Parameters (default storage) */
struct P_soc_range_doppler_top_sw_T_ {
  real_T Constant_Value;               /* Expression: 1
                                        * Referenced by: '<S5>/Constant'
                                        */
  real_T Constant_Value_b;             /* Expression: 0
                                        * Referenced by: '<S25>/Constant'
                                        */
  real_T Constant_Value_d;             /* Expression: 1
                                        * Referenced by: '<S27>/Constant'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_soc_range_doppler_top_T {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    uint32_T checksums[4];
  } Sizes;

  /*
   * SpecialInfo:
   * The following substructure contains special information
   * related to other components that are dependent on RTW.
   */
  struct {
    const void *mappingInfo;
  } SpecialInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    time_T stepSize0;
    uint32_T clockTick1;
    uint32_T clockTick2;
    uint32_T clockTick3;
    uint32_T clockTick4;
    struct {
      uint32_T TID[3];
    } TaskCounters;

    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (default storage) */
extern P_soc_range_doppler_top_sw_T soc_range_doppler_top_sw_P;

/* Block signals (default storage) */
extern B_soc_range_doppler_top_sw_T soc_range_doppler_top_sw_B;

/* Block states (default storage) */
extern DW_soc_range_doppler_top_sw_T soc_range_doppler_top_sw_DW;

/* Model block global parameters (default storage) */
extern int32_T rtP_VelDimLen;          /* Variable: VelDimLen
                                        * Referenced by: '<Root>/Processor Model'
                                        */
extern real32_T rtP_FPGAClkRate;       /* Variable: FPGAClkRate
                                        * Referenced by: '<Root>/Processor Model'
                                        */

/* External function called from main */
extern void soc_range_doppler_top_sw_SetEventsForThisBaseStep(boolean_T
  *eventFlags);
extern void rate_scheduler(void);

/* Model entry point functions */
extern void soc_range_doppler_top_sw_initialize(void);
extern void soc_range_doppler_top_sw_step0(void);/* Sample time: [0.001s, 0.0s] */
extern void soc_range_doppler_top_sw_step1(void);/* Sample time: [0.01s, 0.0s] */
extern void soc_range_doppler_top_sw_step2(void);/* Sample time: [0.2s, 0.0s] */
extern void soc_range_doppler_top_sw_step(int_T tid);
extern void soc_range_doppler_top_sw_terminate(void);

/* Real-time Model object */
extern RT_MODEL_soc_range_doppler_to_T *const soc_range_doppler_top_sw_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'soc_range_doppler_top_sw'
 * '<S1>'   : 'soc_range_doppler_top_sw/IODataSource_Stream'
 * '<S2>'   : 'soc_range_doppler_top_sw/Task Manager'
 * '<S3>'   : 'soc_range_doppler_top_sw/udpRxEvent'
 * '<S4>'   : 'soc_range_doppler_top_sw/IODataSource_Stream/Variant'
 * '<S5>'   : 'soc_range_doppler_top_sw/IODataSource_Stream/Variant/CODEGEN'
 * '<S6>'   : 'soc_range_doppler_top_sw/IODataSource_Stream/Variant/CODEGEN/Create rteEvent'
 * '<S7>'   : 'soc_range_doppler_top_sw/Task Manager/Core Task Manager'
 * '<S8>'   : 'soc_range_doppler_top_sw/Task Manager/Task Blocks'
 * '<S9>'   : 'soc_range_doppler_top_sw/Task Manager/Core Task Manager/Variant Subsystem'
 * '<S10>'  : 'soc_range_doppler_top_sw/Task Manager/Core Task Manager/Variant Subsystem/HSBON'
 * '<S11>'  : 'soc_range_doppler_top_sw/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager'
 * '<S12>'  : 'soc_range_doppler_top_sw/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/NOP'
 * '<S13>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem'
 * '<S14>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON'
 * '<S15>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/baseRateTaskSubsystem'
 * '<S16>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/dataReadTaskSubsystem'
 * '<S17>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/radarTargetUpdateTaskSubsystem'
 * '<S18>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/udpRxTaskSubsystem'
 * '<S19>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/baseRateTaskSubsystem/FcnCallGenPart'
 * '<S20>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/dataReadTaskSubsystem/TaskBlkPart'
 * '<S21>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/dataReadTaskSubsystem/TaskBlkPart/dataReadTaskBlk'
 * '<S22>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/radarTargetUpdateTaskSubsystem/FcnCallGenPart'
 * '<S23>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/udpRxTaskSubsystem/TaskBlkPart'
 * '<S24>'  : 'soc_range_doppler_top_sw/Task Manager/Task Blocks/Variant Subsystem/HSBON/udpRxTaskSubsystem/TaskBlkPart/udpRxTaskBlk'
 * '<S25>'  : 'soc_range_doppler_top_sw/udpRxEvent/Compare To Zero'
 * '<S26>'  : 'soc_range_doppler_top_sw/udpRxEvent/Variant'
 * '<S27>'  : 'soc_range_doppler_top_sw/udpRxEvent/Variant/CODEGEN'
 * '<S28>'  : 'soc_range_doppler_top_sw/udpRxEvent/Variant/CODEGEN/Create rteEvent'
 */
#endif                                 /* soc_range_doppler_top_sw_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
