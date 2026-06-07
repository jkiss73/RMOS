/* ******************************************************************************************************************
* File : test.c
*
* Description: C64 ROM, replacement for BASIC v2.0 ROM. Provides a simple example of creating multiple tasks and mutexes 
*             Main tasks writes to the screen as fast as possible, changing the forground and background color of the
*             characters. Using a mutex between the other tasks.   
*
* Author(s) : John Kiss
*
* Copyright (c) 2026-Present, John Kiss All rights reserved.
* This source code is licensed under the BSD-style license found in the LICENSE file 
* in the root directory of this source tree.
****************************************************************************************************************** */
#include "syscall.h"
#include "types.h"
#include "conio.h"
#include "core.h"
#include "libc.h"

//#define NO_PREEMPTION

Mutex_t gMutexID;

/* **********************************************************************************
* Function : void spawn_1(void)
* Description : Simple task run in parallel with other tasks & locking a mutex. 
*           Changing the screen boarder color. 
* Params : None
* Returns : None
************************************************************************************* */
void __fastcall__ spawn_1(void)
{
    bool lock = FALSE; 
    uint8_t border = 0x00;
    
    while(1)
    {
        lock = mutex_lock(gMutexID);

        if (lock)
        {
           *(char*)0x09 += 1;

           if (!mutex_unlock(gMutexID))
                *(char*)0x09 = 0xBB;

            border++;

            if (border > 15)
                border = 0;

            border_color(border);

        }
        else
            --*(char*)0x09;

        sched_yield(); 
    }
}

/* **********************************************************************************
* Function : void spawn_2(void)
* Description : Simple task run in parallel with other tasks & locking a mutex. 
* Params : none
* Returns : none
************************************************************************************* */
void __fastcall__ spawn_2(void)
{
    bool lock = FALSE; 

    while(1)
    {
        lock = mutex_lock(gMutexID);

        if (lock)
        {
            ++*(char*)0x08;

           if (!mutex_unlock(gMutexID))
                *(char*)0x08 = 0xBB;
        }
        else
            *(char*)0x08 -= 3;

        sched_yield();
      
    }
 
}

/* **********************************************************************************
* Function : void spawn_3(void)
* Description : Simple task run in parallel with other tasks & locking a mutex. 
* Params : none
* Returns : none
************************************************************************************* */
void __fastcall__ spawn_3(void)
{
    bool lock = FALSE; 

    while(1)
    {
        lock = mutex_lock(gMutexID);
    
        if (lock)
        {
            ++*(char*)0x0A;

          if (!mutex_unlock(gMutexID))
              *(char*)0x0A = 0xBB;
        }
        else
            *(char*)0x0A -= 2;

        sched_yield();
    }

}

/* **********************************************************************************
* Function : void main(void)
* Description : Starts 3 other simple tasks (threads), setting a mutex, writing to 
*       screen as fast as possible. Getting characters from the keyboard to write to the scren   
* Params : none
* Returns : none
************************************************************************************* */
void main(void)
{
    TaskHandle_t task = 0;
    uint8_t x = 0;
    uint8_t y = 0;
    char ch = 'A';
    char kb_ch = 0x00;
    uint8_t color = 0x07;
    uint8_t bkg = 0x06;
    bool lock = FALSE; 

    gMutexID = MUTEX_INVALID_HANDLE;

#if !defined(NO_PREEMPTION)
    system_control(SYSCTRL_CMD_PREEMPT_ENABLE);
#endif

    print("\n");

    if (gMutexID = mutex_allocate() == KERR_NO_RESOURCES)
    {
        print("Error, cannot allocate mutex\n");
        return;
    }

    task = task_create((sysAddress)&spawn_1, 0xDF);

    if (task != NULL)
    {
       task_set_state(task,TCB_FLAG_RUN);
    }

    task = task_create((sysAddress)&spawn_2,0xCF);

    if (task != NULL)
    {
       task_set_state(task,TCB_FLAG_RUN);
    }

    task = task_create((sysAddress)&spawn_3,0xBF);

    if (task != NULL)
    {
        task_set_state(task,TCB_FLAG_RUN);
    }

    clrscr();

    while(1)
    {
        putchar(ch);
        
        y++;

        if (y > 39)
        {
            lock = mutex_lock_wait(gMutexID);

            y = 0;
            x++;

            color++;
   
            if (x > 24)
            {
                x = 0;
                ch++;
                clrscr();
 
                bkg++;

                if (bkg > 15)
                   bkg = 0;

                background_color(bkg);
            }

            if (color == bkg)
                color++;

            if (color > 15)
                color = 0;

            text_color(color);
            cursor_pos(x,y);
            
            mutex_unlock(gMutexID);
        }

        kb_ch = getchar();

        if (kb_ch != 0x00)
            ch = kb_ch;

#if defined(NO_PREEMPTION)
        sched_yield();
#endif

    }
    
    return;
}




