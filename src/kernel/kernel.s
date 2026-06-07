; ******************************************************************************************************************
; File : kernel.s
;
; Description: Large kernel build source file. Includes and orders source files.   
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

.feature labels_without_colons, string_escapes

.include "system_defines.inc"
.include "macros/common.s" 

.include "vars.s"
.include "const.s"
.include "drivers.s"
.include "core.s"
.include "kernel_task.s"
.include "init.s"
.include "isr.s"
.include "syscall.s"
.include "vectors.s"
