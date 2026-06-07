/* ******************************************************************************************************************
File : core.h

Description: Functions and defines for into the kernels core subsystem  

Author(s) : John Kiss

Copyright (c) 2026-Present, John Kiss All rights reserved.
This source code is licensed under the BSD-style license found in the LICENSE file 
in the root directory of this source tree.
****************************************************************************************************************** */
#if !defined(RMOS_CORE_H)
#define RMOS_CORE_H
#include "types.h"

typedef uint8_t TaskHandle_t;

typedef struct task_control_block {
    uint8_t     id_flag;    // Task ID (bits 0-3)  Task Flags (bit 4-7) 
    uint8_t     type_pri;   // Task Type and Priority
    uint8_t     areg;       // saved a register
    uint8_t     xreg;       // saved x RAM
    uint8_t     yreg;       // saved y register
    uint8_t     streg;      // saved status register
    uint8_t     sp;         // Location of stack pointer
    uint8_t     resv_1;     // One byte reserved to align WORD boundary
    sysAddress  addr;       // return address from interrupt
    sysAddress  info;       // pointer to more detailed task info 
}TCB_t,*TCB_p;

#define TASK_TYPE_NONE          0
#define TASK_TYPE_PROCESS       1
#define TASK_TYPE_EVENT         2
#define TASK_TYPE_TIMER         3
#define TASK_TYPE_LAST          4

#define MAX_TASKS           10
#define TCB_FLAG_MASK       0xF0
#define TCB_ID_MASK         0x0F
#define TCB_FLAG_FREE       0x00
#define TCB_FLAG_RUN        0x10
#define TCB_FLAG_STOPPED    0x20
#define TCB_FLAG_WAIT       0x40
#define TCB_FLAG_RSV_1      0x80



/* ********************************************************************************** */
#define MAX_MUTEX               10
#define MUTEX_UNLOCKED          0xFF
#define MUTEX_INVALID_HANDLE    0xFF
#define MUTEX_ID_CORE           0

typedef uint8_t mutexID_t;
typedef uint8_t Mutex_t;

#define ENTER_CRITICAL()   asm("sei");
#define LEAVE_CRITICAL()   asm("cli");


#define SYSCTRL_CMD_PREEMPT_DISABLE     0
#define SYSCTRL_CMD_PREEMPT_ENABLE      1

/* ********************************************************************************** */

bool    __fastcall__    mutex_lock_wait(Mutex_t handle);

Mutex_t __fastcall__    mutex_allocate(void);
bool    __fastcall__    mutex_free(Mutex_t handle);
bool    __fastcall__    mutex_lock(Mutex_t handle);
bool    __fastcall__    mutex_is_locked(Mutex_t handle);
bool    __fastcall__    mutex_unlock(Mutex_t handle);

void    __fastcall__    system_control(uint8_t cmd);

/* ********************************************************************************** */

uint8_t __fastcall__ sched_calc_tcb_offset(uint8_t idx);
uint8_t __fastcall__ sched_tcb_allocate();
uint8_t __fastcall__ sched_calc_tcb_offset(uint8_t idx);
void    __fastcall__ sched_yield(void);

TaskHandle_t __fastcall__ create_task_handle(uint8_t id);
TaskHandle_t __fastcall__ task_create(sysAddress process, uint8_t stack);
bool __fastcall__ task_set_state(TaskHandle_t task, uint8_t state);



#endif //RMOS_CORE_H