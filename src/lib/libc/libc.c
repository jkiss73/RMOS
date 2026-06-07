/* ******************************************************************************************************************
* File : libc.c
*
* Description: Application level standard C libraty routines     
*
* Author(s) : John Kiss
*
* Copyright (c) 2026-Present, John Kiss All rights reserved.
* This source code is licensed under the BSD-style license found in the LICENSE file 
* in the root directory of this source tree.
****************************************************************************************************************** */
#include <stdarg.h>
#include "libc.h"
#include "core.h"
#include "syscall.h"
#include "conio.h"

/* **********************************************************************************
* TODO FIXME
* Function : void sleep(delay)
* Description : Probably the worst function , task sleep, aka delay,  doesn't yield the task 
*             just wastes cpu cycles. 
*            
* Params : uint16_t delay - delay time in cpu cycles 
* Returns : None
************************************************************************************* */
void __fastcall__ sleep(uint16_t delay)
{
    uint16_t cnt = 0;

    for (cnt = 0; cnt < delay;cnt++)
        asm("nop");
}

/* **********************************************************************************
* TODO : FIXME , eventually turn into printf. 
* Function : void print(const char *f, ...)
* Description : Simple task run in parallel with other tasks & locking a mutex. 
*           Changing the screen boarder color. 
* Params : *f - const char to fomratted string 
*                   %s      - substitue string
*                   %d      - 8 bit decimal - not working 
*           ... - variable list
* Returns : None
************************************************************************************* */
void __cdecl__ print(const char *f,...)
{
    va_list args;
    char *c = (char*)f;
    char *st = NULL;
    uint16_t dec = 0;
    uint8_t nargs = 0;
    uint8_t x = 0;
  
    /* Go through the string and find how many args */
    while (*c != NULL)
    {
        if (*c == '%')
            nargs++;
        c++;   
    }

    c = (char*)f;
    
    cursor_pos(0,x);

    if (nargs > 0)
    {
        // Initialize the argument list
        va_start(args, f);

        do{
            if (*c == '%')
            {
                c++;

                if (*c == 's')
                {
                    c++;
                    st = va_arg(args,char*);

                    while (*st != NULL)
                    {
                        cursor_pos(0,x);
                        x++;
                        putchar(*st);
                        st++;
                    }
                }
                else if (*c == 'd')
                {
                    c++;
                    dec = va_arg(args,uint16_t);
                    if (dec == 2)
                    {
                        cursor_pos(0,x);
                        x++;
                        putchar('2');
                    }

                }
            }
            else
            {
                cursor_pos(0,x);
                putchar(*c);
                x++;
                c++;
            }

            
        }while (*c != NULL);

        va_end(args);
    }

} 