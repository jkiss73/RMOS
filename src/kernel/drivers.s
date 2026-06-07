; ******************************************************************************************************************
; File : core.s
;
; Description: Kernel drivers, wrapper around target required and build specified drivers   
;
; Author(s) : John Kiss
;
; Copyright (c) 2026-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
.segment "DRIVERS"

.include "io_memory.s"
.include "console.s"

; ****************************************************************
; public void areg io_devices_init (void)
; Uses registers : a,x
;
; Description : Initialize the IO devices for a specific target  
;            
; params    None
;  
; Returns : none   
; ****************************************************************
.proc io_devices_init : near
; load all vic-II registers with default settings from const. table.
; 
;   x = 47
;   do {
;      vicBaseRegisters[x] = _const_default_vic_registers[x]
;      x--
;   }while (x > 0)    
init_vic2:
    ldx #47         
:
    lda _const_default_vic_registers-1,x
    sta vicBaseRegisters-1,x
    dex
    bne :-

; Initialize CIA #1 and CIA #2 IO 
init_cia:
    lda #%01111111         ;ICR Write/Mask clear all interrupts
    sta cia1icr
    sta cia2icr
    
    lda #%00001000      ;disable timers
    sta cia1cra
    sta cia2cra
    sta cia1crb
    sta cia2crb
    
    lda #$00          ;Disable keyboard and userport (User port RS232)
	sta cia1ddrb      
	sta cia2ddrb      
    
; Initialize SID (Sound) registers     
init_sid: 
; Info is sparse but reading the register info in the Programmers Reference Guide 
; indicates setting register 24 (aka $D418 - Select Filter Mode & Volume) 
; to 0 turns off the entire SID.
    lda #$0                 ;  Disable SID (Sound Chip)
	sta sidBaseRegister+24   

    rts
.endproc

