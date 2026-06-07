; ******************************************************************************************************************
; File : common.s
;
; Description: Aseembly macros used for all target builds.   
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

; ****************************************************************
; macro DISABLE_INTERRUPTS ()
; Description : Disable cpu interrupts          
; params    None
;           
; Returns : none 
; ****************************************************************
.macro DISABLE_INTERRUPTS
   sei
.endmacro

; ****************************************************************
; macro ENABLE_INTERRUPTS ()
; Description : Enable cpu interrupts          
; params    None
;           
; Returns : none 
; ****************************************************************
.macro ENABLE_INTERRUPTS
   cli
.endmacro

; ****************************************************************
; macro ENTER_CRITICAL_SECTION ()
; Description : Enter a critical section of code that cannot be interrupted. 
;        Disables ISR and NMI interrupts
; params    None
;           
; Returns : none 
; ****************************************************************
.macro ENTER_CRITICAL_SECTION
   DISABLE_INTERRUPTS   
.endmacro

; ****************************************************************
; macro LEAVE_CRITICAL_SECTION ()
; Description : Leaving a section of critical code where ISR and NMI
;           interrupts are re-enabled.          
; params    None
;           
; Returns : none 
; ****************************************************************
.macro LEAVE_CRITICAL_SECTION
   ENABLE_INTERRUPTS
.endmacro


; ****************************************************************
; macro DISABLE_PREEMPTION_SCHEDULAR ()
; Description : Disables the ISR preemption schedular. Basically 
;        swithcing the kernel to cooperative multi-tasking.  
;                     
; params    None
;           
; Returns : none 
; ****************************************************************
.macro DISABLE_PREEMPTION_SCHEDULAR
   DISABLE_INTERRUPTS
.endmacro

; ****************************************************************
; macro ENABLE_PREEMPTION_SCHEDULAR ()
; Description : Enables the ISR preemption schedular.  
;                     
; params    None
;           
; Returns : none 
; ****************************************************************
.macro ENABLE_PREEMPTION_SCHEDULAR
   ENABLE_INTERRUPTS
.endmacro

