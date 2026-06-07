/* ******************************************************************************************************************
* File : shell.c
*
* Description: C64 ROM, replacement for BASIC v2.0 ROM. provides the Disk Operating System and 
*           command line interface (CLI) shell.   
*
* Author(s) : John Kiss
*
* Copyright (c) 2026-Present, John Kiss All rights reserved.
* This source code is licensed under the BSD-style license found in the LICENSE file 
* in the root directory of this source tree.
****************************************************************************************************************** */

#include <stdarg.h>
#include "syscall.h"
#include "types.h"
#include "conio.h"
#include "core.h"


/* ********************************************************************************** */

void main(void)
{
   
    console_control(CONIO_CMD_CHARSET2);

    system_control(SYSCTRL_CMD_PREEMPT_ENABLE);

    while (1)
    {
        // do nothing
    }

    return;
}




