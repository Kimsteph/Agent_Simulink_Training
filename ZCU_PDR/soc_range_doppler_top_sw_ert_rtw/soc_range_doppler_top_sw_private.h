/*
 * File: soc_range_doppler_top_sw_private.h
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

#ifndef soc_range_doppler_top_sw_private_h_
#define soc_range_doppler_top_sw_private_h_
#include "rtwtypes.h"
#include "multiword_types.h"
#include "soc_range_doppler_top_sw_types.h"

/* Private macros used by the generated code to access rtModel */
#ifndef rtmSetTFinal
#define rtmSetTFinal(rtm, val)         ((rtm)->Timing.tFinal = (val))
#endif

#ifndef UCHAR_MAX
#include <limits.h>
#endif

#if ( UCHAR_MAX != (0xFFU) ) || ( SCHAR_MAX != (0x7F) )
#error Code was generated for compiler with different sized uchar/char. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( USHRT_MAX != (0xFFFFU) ) || ( SHRT_MAX != (0x7FFF) )
#error Code was generated for compiler with different sized ushort/short. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( UINT_MAX != (0xFFFFFFFFU) ) || ( INT_MAX != (0x7FFFFFFF) )
#error Code was generated for compiler with different sized uint/int. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

/* Skipping ulong/long check: insufficient preprocessor integer range. */

/* Skipping ulong_long/long_long check: insufficient preprocessor integer range. */

/* Define number of task blocks */
#define NUM_TSK_BLOCKS                 (2)

extern void mw_setAsyncTaskCodeGenInfo(void* (*taskHandler)(void*), const char
  * taskName, int priority, int policy, int coreSelection, int coreNum, int idx);
extern void mw_CreateTask(void* (*taskHandler)(void*), const char* taskName, int
  priority, int policy, int coreSelection, int coreNum);

/* Define number of task blocks */
#define NUM_TSK_BLOCKS                 (2)

extern void mw_setAsyncTaskCodeGenInfo(void* (*taskHandler)(void*), const char
  * taskName, int priority, int policy, int coreSelection, int coreNum, int idx);
extern void mw_CreateTask(void* (*taskHandler)(void*), const char* taskName, int
  priority, int policy, int coreSelection, int coreNum);

#endif                                 /* soc_range_doppler_top_sw_private_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
