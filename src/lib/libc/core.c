/* ******************************************************************************************************************
* File : core.c
*
* Description: C System Call routines to the kernel core module.    
*
* Author(s) : John Kiss
*
* Copyright (c) 2026-Present, John Kiss All rights reserved.
* This source code is licensed under the BSD-style license found in the LICENSE file 
* in the root directory of this source tree.
****************************************************************************************************************** */
#include "core.h"
#include "syscall.h"

/* **********************************************************************************
* Function : bool mutex_lock_wait(Mutex_t handle)
* Description : Waits for the mutex to be locked by the current task. While waiting a    
*       call to the scheduler yield is called. 
*    
* Params : handle - Mutex handle to wait
*
* Returns : TRUE when locked. 
************************************************************************************* */
bool mutex_lock_wait(Mutex_t handle)
{
    bool retval = TRUE;

    while (!mutex_lock(handle)) 
        sched_yield();

    return(retval);
}

/* **********************************************************************************
* Function : TaskHandle_t create_task_handle(uint8_t idx)
* Description : Create a task handled based on a index into the task control list.      
*    
* Params : idx - The index to a task block inside the task control list. 
*
* Returns : NULL on failure  
************************************************************************************* */
TaskHandle_t __fastcall__ create_task_handle(uint8_t idx)
{
    uint8_t retval = NULL;
    
    if (idx)
    {
        retval = (uint8_t)TASK_CTRL_LIST_ADDR + (idx  * sizeof(struct task_control_block)) ;
    }

    return(retval);
}
 
/* **********************************************************************************
* TODO - Fix statck to use a  HW Stack Managher and would specify how many blocks are needed.
* Function : TaskHandle_t task_create(sysAddress process, uint8_t stack)
* Description : Create a new task       
*    
* Params :  process - The index to a task block inside the task control list. 
*           stack   -  FIXME: right now this function takes a direct address to the  stack
*
* Returns : NULL on failure 
************************************************************************************* */
TaskHandle_t __fastcall__ task_create(sysAddress process, uint8_t stack)
{
    TaskHandle_t retval = 0;
    uint8_t task_id = 0;
    TCB_t* tcb = NULL;

    if ((task_id = sched_tcb_allocate()) > 0)
    {
        retval = create_task_handle(task_id);

        tcb = (TCB_t*)retval;

        if (tcb != NULL)
        {
            tcb->addr = (sysAddress)process;
            tcb->sp = stack;
        }

    }

    return(retval);
}

/* **********************************************************************************
* TODO - Fix statck to use a  HW Stack Managher and would specify how many blocks are needed.
* Function : bool task_set_state(TaskHandle_t task, uint8_t state)
* Description : Set a tasks state. This would include setting it to run, stop, wait etc..          
*    
* Params :  task    - A handle to the task  
*           state   - TCB_FLAG_RUN, STOPPED, WAIT
*
* Returns : TRUE if state of the stack was changed.
************************************************************************************* */
bool __fastcall__ task_set_state(TaskHandle_t task, uint8_t state)
{
    bool retval = FALSE;
    TCB_t *tcb; 

    if (task)
    {

        if ((tcb = (TCB_t*)task)!= NULL)
        {
             tcb->id_flag &= 0x0F;

            tcb->id_flag = (tcb->id_flag | state);
            
            retval = TRUE;
        }
    }
 
    return(retval);
}
