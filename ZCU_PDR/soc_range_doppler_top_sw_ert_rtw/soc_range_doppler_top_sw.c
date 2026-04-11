/*
 * File: soc_range_doppler_top_sw.c
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

#include "soc_range_doppler_top_sw.h"
#include "rtwtypes.h"
#include "soc_range_doppler_top_sw_private.h"
#include "soc_range_doppler_proc.h"
#include "soc_range_doppler_top_sw_dt.h"

/* Block signals (default storage) */
B_soc_range_doppler_top_sw_T soc_range_doppler_top_sw_B;

/* Block states (default storage) */
DW_soc_range_doppler_top_sw_T soc_range_doppler_top_sw_DW;

/* Real-time model */
static RT_MODEL_soc_range_doppler_to_T soc_range_doppler_top_sw_M_;
RT_MODEL_soc_range_doppler_to_T *const soc_range_doppler_top_sw_M =
  &soc_range_doppler_top_sw_M_;
void *ptr_streamread_mwrange_doppler_tx_rx_ip0_s2mm0 = NULL;
void dataReadTask_fcn(void* arg)
{
  while (runModel) {
    mw_iio_poll(ptr_streamread_mwrange_doppler_tx_rx_ip0_s2mm0);

    /* Call the system: <Root>/Processor Model */
    {
      soc_range_doppler_top_sw_M->Timing.clockTick3 =
        soc_range_doppler_top_sw_M->Timing.clockTick0;

      /* S-Function (esb_task): '<S21>/S-Function1' */

      /* ModelReference: '<Root>/Processor Model' */
      soc_range_doppler_pro_dmaRdTask
        (&soc_range_doppler_top_sw_B.ProcessorModel_o1,
         &soc_range_doppler_top_sw_B.ProcessorModel_o2);

      /* End of Outputs for S-Function (esb_task): '<S21>/S-Function1' */
    }
  }
}

void *ptr_udpread_25001 = NULL;
void udpRxTask_fcn(void* arg)
{
  while (runModel) {
    MW_UDPRead_Poll(ptr_udpread_25001);

    /* Call the system: <Root>/Processor Model */
    {
      soc_range_doppler_top_sw_M->Timing.clockTick4 =
        soc_range_doppler_top_sw_M->Timing.clockTick0;

      /* S-Function (esb_task): '<S24>/S-Function1' */

      /* ModelReference: '<Root>/Processor Model' */
      soc_range_doppler_pro_udpRxTask();

      /* End of Outputs for S-Function (esb_task): '<S24>/S-Function1' */
    }
  }
}

/*
 * Set which subrates need to run this base step (base rate always runs).
 * This function must be called prior to calling the model step function
 * in order to remember which rates need to run this base step.  The
 * buffering of events allows for overlapping preemption.
 */
void soc_range_doppler_top_sw_SetEventsForThisBaseStep(boolean_T *eventFlags)
{
  /* Task runs when its counter is zero, computed via rtmStepTask macro */
  eventFlags[1] = ((boolean_T)rtmStepTask(soc_range_doppler_top_sw_M, 1));
  eventFlags[2] = ((boolean_T)rtmStepTask(soc_range_doppler_top_sw_M, 2));
}

/*
 *         This function updates active task flag for each subrate.
 *         The function is called in the model base rate function.
 *         It maintains SampleHit information to allow scheduling
 *         of the subrates from the base rate function.
 */
void rate_scheduler(void)
{
  /* Compute which subrates run during the next base time step.  Subrates
   * are an integer multiple of the base rate counter.  Therefore, the subtask
   * counter is reset when it reaches its limit (zero means run).
   */
  (soc_range_doppler_top_sw_M->Timing.TaskCounters.TID[1])++;
  if ((soc_range_doppler_top_sw_M->Timing.TaskCounters.TID[1]) > 9) {/* Sample time: [0.01s, 0.0s] */
    soc_range_doppler_top_sw_M->Timing.TaskCounters.TID[1] = 0;
  }

  (soc_range_doppler_top_sw_M->Timing.TaskCounters.TID[2])++;
  if ((soc_range_doppler_top_sw_M->Timing.TaskCounters.TID[2]) > 199) {/* Sample time: [0.2s, 0.0s] */
    soc_range_doppler_top_sw_M->Timing.TaskCounters.TID[2] = 0;
  }
}

/* Model step function for TID0 */
void soc_range_doppler_top_sw_step0(void) /* Sample time: [0.001s, 0.0s] */
{
  {                                    /* Sample time: [0.001s, 0.0s] */
    rate_scheduler();
  }

  /* RateTransition: '<Root>/Rate Transition' */
  soc_range_doppler_top_sw_B.Reshape =
    soc_range_doppler_top_sw_B.ProcessorModel_o2;

  /* External mode */
  rtExtModeUploadCheckTrigger(3);
  rtExtModeUpload(0, (real_T)soc_range_doppler_top_sw_M->Timing.taskTime0);

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.001s, 0.0s] */
    if ((rtmGetTFinal(soc_range_doppler_top_sw_M)!=-1) &&
        !((rtmGetTFinal(soc_range_doppler_top_sw_M)-
           soc_range_doppler_top_sw_M->Timing.taskTime0) >
          soc_range_doppler_top_sw_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(soc_range_doppler_top_sw_M, "Simulation finished");
    }

    if (rtmGetStopRequested(soc_range_doppler_top_sw_M)) {
      rtmSetErrorStatus(soc_range_doppler_top_sw_M, "Simulation finished");
    }
  }

  /* Update absolute time */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   */
  soc_range_doppler_top_sw_M->Timing.taskTime0 =
    ((time_T)(++soc_range_doppler_top_sw_M->Timing.clockTick0)) *
    soc_range_doppler_top_sw_M->Timing.stepSize0;
}

/* Model step function for TID1 */
void soc_range_doppler_top_sw_step1(void) /* Sample time: [0.01s, 0.0s] */
{
  /* FunctionCallGenerator: '<S22>/FcnCallGen' */

  /* ModelReference: '<Root>/Processor Model' */
  soc_range_doppler_procTID0();

  /* End of Outputs for FunctionCallGenerator: '<S22>/FcnCallGen' */
  rtExtModeUpload(1, (real_T)((soc_range_doppler_top_sw_M->Timing.clockTick1) *
    0.01));

  /* Update absolute time */
  /* The "clockTick1" counts the number of times the code of this task has
   * been executed. The resolution of this integer timer is 0.01, which is the step size
   * of the task. Size of "clockTick1" ensures timer will not overflow during the
   * application lifespan selected.
   */
  soc_range_doppler_top_sw_M->Timing.clockTick1++;
}

/* Model step function for TID2 */
void soc_range_doppler_top_sw_step2(void) /* Sample time: [0.2s, 0.0s] */
{
  /* FunctionCallGenerator: '<S19>/FcnCallGen' */

  /* ModelReference: '<Root>/Processor Model' */
  soc_range_doppler_procTID1();

  /* End of Outputs for FunctionCallGenerator: '<S19>/FcnCallGen' */
  rtExtModeUpload(2, (real_T)((soc_range_doppler_top_sw_M->Timing.clockTick2) *
    0.2));

  /* Update absolute time */
  /* The "clockTick2" counts the number of times the code of this task has
   * been executed. The resolution of this integer timer is 0.2, which is the step size
   * of the task. Size of "clockTick2" ensures timer will not overflow during the
   * application lifespan selected.
   */
  soc_range_doppler_top_sw_M->Timing.clockTick2++;
}

/* Use this function only if you need to maintain compatibility with an existing static main program. */
void soc_range_doppler_top_sw_step(int_T tid)
{
  switch (tid) {
   case 0 :
    soc_range_doppler_top_sw_step0();
    break;

   case 1 :
    soc_range_doppler_top_sw_step1();
    break;

   case 2 :
    soc_range_doppler_top_sw_step2();
    break;

   default :
    /* do nothing */
    break;
  }
}

/* Model initialize function */
void soc_range_doppler_top_sw_initialize(void)
{
  /* Registration code */
  rtmSetTFinal(soc_range_doppler_top_sw_M, -1);
  soc_range_doppler_top_sw_M->Timing.stepSize0 = 0.001;

  /* External mode info */
  soc_range_doppler_top_sw_M->Sizes.checksums[0] = (3068949055U);
  soc_range_doppler_top_sw_M->Sizes.checksums[1] = (3118919892U);
  soc_range_doppler_top_sw_M->Sizes.checksums[2] = (1271000961U);
  soc_range_doppler_top_sw_M->Sizes.checksums[3] = (2485496473U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    soc_range_doppler_top_sw_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(soc_range_doppler_top_sw_M->extModeInfo,
      &soc_range_doppler_top_sw_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(soc_range_doppler_top_sw_M->extModeInfo,
                        soc_range_doppler_top_sw_M->Sizes.checksums);
    rteiSetTPtr(soc_range_doppler_top_sw_M->extModeInfo, rtmGetTPtr
                (soc_range_doppler_top_sw_M));
  }

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo, 0,
                  sizeof(dtInfo));
    soc_range_doppler_top_sw_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 30;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.BTransTable = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.PTransTable = &rtPTransTable;
  }

  /* Model Initialize function for ModelReference Block: '<Root>/Processor Model' */
  soc_range_dopple_initialize(rtmGetErrorStatusPointer
    (soc_range_doppler_top_sw_M), rtmGetStopRequestedPtr
    (soc_range_doppler_top_sw_M));

  /* SystemInitialize for S-Function (esb_task): '<S21>/S-Function1' */
  {
    mw_setAsyncTaskCodeGenInfo((void*) dataReadTask_fcn, "_socbAT1", 50, 0, 2, 1,
      0);
  }

  /* End of SystemInitialize for S-Function (esb_task): '<S21>/S-Function1' */

  /* SystemInitialize for S-Function (esb_task): '<S24>/S-Function1' */
  {
    mw_setAsyncTaskCodeGenInfo((void*) udpRxTask_fcn, "_socbAT2", 45, 0, 2, 0, 1);
  }

  /* End of SystemInitialize for S-Function (esb_task): '<S24>/S-Function1' */

  /* SystemInitialize for ModelReference: '<Root>/Processor Model' */
  soc_range_doppler_proc_Init(&soc_range_doppler_top_sw_B.ProcessorModel_o2);
}

/* Model terminate function */
void soc_range_doppler_top_sw_terminate(void)
{
  /* Terminate for ModelReference: '<Root>/Processor Model' */
  soc_range_doppler_proc_Term();
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
