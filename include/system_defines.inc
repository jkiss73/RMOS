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

.define dflt_stack_addr     $20             ; Default top of stack

; CIA #1 and #2 registers
; ***************************************

.define cia1BaseReg	                    $dc00       ;cia#1 6526 register base memory location
.define cia2BaseReg                     $dd00       ;cia#2 6526 register base memory location.end

.define kb_colmn                        cia1pra     ;Write register for Keyboard
.define kb_rows                         cia1prb     ;Read register for keyboard

; Console driver defines
; **************************************
.define blink_rate                      $05
.define type_rate                       $05

.define scr_nlines                      25          ; Screen Rows
.define scr_linelen                     40          ; Screen Line Length

.define SCR_CURSOR_ENA                  $01
.define SCR_BLINK_STATE                 $02
.define SCR_MODE                        $04

.define CONSOLE_CMD_CHARSET1            $01
.define CONSOLE_CMD_CHARSET2            $02

.define SYSTEM_FLAG_DEFAULT             $00
.define SYSTEM_FLAG_PREEMPTION_ENABLED  $01
.define SYSTEM_FLAG_RSV1_ENABLED        $02
.define SYSTEM_FLAG_RSV2_ENABLED        $04
.define SYSTEM_FLAG_RSV3_ENABLED        $08
.define SYSTEM_FLAG_RSV4_ENABLED        $10
.define SYSTEM_FLAG_RSV5_ENABLED        $20
.define SYSTEM_FLAG_RSV7_ENABLED        $40
.define SYSTEM_FLAG_RSV8_ENABLED        $80

.struct TIMER_CTRL_LIST
    id_flag     .byte       ; Task ID (bits 0-3)  Task Flags (bit 4-7)
    set_ticks   .word       ; time set for this timer.  
    ticks       .word       
    callback    .addr
.endstruct

.define TBL_MAX_TIMERS      10
.define TBL_FLAG_MASK       $F0
.define TBL_FLAG_FREE       $00
.define TBL_FLAG_ONE_SHOT   $10
.define TBL_FLAG_CONTINUOUS $20
.define TBL_FLAG_STOPPED    $40
.define TBL_FLAG_ACTIVE     $80

.struct TASK_CTRL_BLOCK
    id_flag     .byte       ; Task ID (bits 0-3)  Task Flags (bit 4-7) 
    type_pri    .byte       ; Task Type and Priority
    areg        .byte       ; saved a register
    xreg        .byte       ; saved x RAM
    yreg        .byte       ; saved y register
    streg       .byte       ; saved status register
    sp          .byte       ; Location of stack pointer
    resv_1      .byte       ; One byte reserved to align WORD boundary
    addr        .addr       ; return address from interrupt
    info        .addr       ; pointer to more detailed task info 
.endstruct

.define MAX_TASKS           10
.define TCB_FLAG_MASK       $F0
.define TCB_ID_MASK         $0F
.define TCB_FLAG_FREE       $00
.define TCB_FLAG_RUN        $10
.define TCB_FLAG_STOPPED    $20
.define TCB_FLAG_WAIT       $40
.define TCB_FLAG_RSV_1      $80

.define TCB_TYPE_MASK       $F0
.define TCB_PRI_MASK        $0F
.define TCB_TYPE_PROCESS    $10
.define TCB_TYPE_TIMER      $20
.define TCB_TYPE_EVENT      $40
.define TCB_TYPE_RSV        $80

.define MAX_MUTEX           10      ; Max # of mutex handlers 
.define MUTEX_FREE          $AA     ; 
.define MUTEX_UNLOCKED      $FF

; Reserved kernel subsysgtem mutex cells 
.define MUTEX_CORE_ID       0       ; kernel core subsystem mutex ID
.define MUTEX_DM_ID         1       ; kernel device manager subsysgtem mutex ID
.define MUTEX_TIMER_ID      2       ; kernel timer subsystem mutex

.define MAX_EVENTS          10      ; Maximum # of events; Events queue and 

.define KERNEL_LOG_SIZE     $200    ; Size of the kernel in memory binary logger

.define KERR_NONE            $00
.define KERR_NO_RESOURCES    $F0      

.if .defined(DFLT_PREEMPT_ON)
.define DEFAULT_PREEMPT_STATE    $01
.else
.define DEFAULT_PREEMPT_STATE    $00
.endif

; Formula for setting the Timer
; Cycles = delay * system clock
; Cycles = .001 * 1,022,727 hz = 1022 (aka 1ms)
;

;.define TIMER_B_VALUE        1022       ; 1 ms value 
;.define TIMER_B_VALUE        10220       ; 10 ms value 
;.define TIMER_B_VALUE         500       ; ~500 us value 
;.define CIA2_TIMER_A_VALUE    10220       ; 10 ms value 
