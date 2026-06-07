/* ******************************************************************************************************************
File : conio.h

Description: Functions and defines for  console input/output  

Author(s) : John Kiss

Copyright (c) 2026-Present, John Kiss All rights reserved.
This source code is licensed under the BSD-style license found in the LICENSE file 
in the root directory of this source tree.
****************************************************************************************************************** */
#if !defined(RMOS_CONIO_H)
#define RMOS_CONIO_H
#include "types.h"

#define CONIO_CMD_CHARSET1              0x01        /* Command for the console control function to use c64 charset 1 */
#define CONIO_CMD_CHARSET2              0x02        /* Command for the console control function to use c64 charset 2 */


void __fastcall__ console_control(uint8_t cmd);

void __fastcall__ putchar(char ch);
char __fastcall__ getchar(void);

void __fastcall__ cursor_pos(uint8_t x, uint8_t y);
void __fastcall__ clrscr(void);
void __fastcall__ clrline(uint8_t row);
void __fastcall__ text_color(uint8_t color);
void __fastcall__ background_color(uint8_t color);
void __fastcall__ border_color(uint8_t color);

#endif //RMOS_CONIO_H
