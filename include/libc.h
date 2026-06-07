/* ******************************************************************************************************************
File : libc.h

Description: Functions and defines for general C library functions  

Author(s) : John Kiss

Copyright (c) 2026-Present, John Kiss All rights reserved.
This source code is licensed under the BSD-style license found in the LICENSE file 
in the root directory of this source tree.
****************************************************************************************************************** */
#if !defined(RMOS_LIBC_H)
#define RMOS_LIBC_H
#include <stdarg.h>
#include "types.h"

void __cdecl__ print(const char *f,...);
void __fastcall__ sleep(uint16_t delay);

#endif //RMOS_LIBC_H
