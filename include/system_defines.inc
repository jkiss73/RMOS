; ******************************************************************************************************************
; File : sysetm_defines.inc
;
; Description: system level assembly defines, enums and structure defintions. 
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

;define ntsc_sys_clk        10220           ; NTSC System Interrupt CIA $1, Timer 10ms. 
.define ntsc_sys_clk        17033           ; NTSC System Interrupt CIA $1, Timer 16.6667ms or 1/60hz. 
;.define ntsc_sys_clk       17045           ; NTSC System Interrupt CIA $1, Timer 1/60hz original C64 kernal setting.
;.define pal_sys_clk        16421           ; PAL System Interrupt CIA $1, Timer 1/60hz original C64 kernal setting.

.define d65xx_reg	        $00             ;65xx data direction register memory location
.define io6510_reg	        $01             ;6510 data i/o register memory location

.define vicBaseRegisters    $d000           ; VIC-II base register
.define sidBaseRegister 	$d400           ; Sound Chip base register
.define VidColorRAMBase     $d800           ; Start of the 1k VIC Color RAM
.define VidMemoryBase       $0400           ; Start of the 1k VIC SCREEN Memory 
.define SystemShellAddr     $A000           ; Starting address of the System Shell applications

.define dflt_stack_addr     $FF             ; Default top of stack

; CIA #1 and #2 registers
; ***************************************

.define cia1BaseReg	                    $dc00       ;cia#1 6526 register base memory location
.define cia2BaseReg                     $dd00       ;cia#2 6526 register base memory location.end

.define kb_colmn                        cia1pra     ;Write register for Keyboard
.define kb_rows                         cia1prb     ;Read register for keyboard

; Console driver defines
; **************************************
.define blink_rate                      $05
.define type_rate                       $07

.define scr_nlines                      25          ; Screen Rows
.define scr_linelen                     40          ; Screen Line Length

.define SCR_CURSOR_ENA                  $01
.define SCR_BLINK_STATE                 $02
.define SCR_MODE                        $04

.define KERR_NONE            $00
.define KERR_NO_RESOURCES    $F0      

; Formula for setting the Timer
; Cycles = delay * system clock
; Cycles = .001 * 1,022,727 hz = 1022 (aka 1ms)
;

;.define TIMER_B_VALUE        1022       ; 1 ms value 
;.define TIMER_B_VALUE        10220       ; 10 ms value 
;.define TIMER_B_VALUE         500       ; ~500 us value 
;.define CIA2_TIMER_A_VALUE    10220       ; 10 ms value 
