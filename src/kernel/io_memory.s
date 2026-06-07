; ******************************************************************************************************************
; File : io_memory.s
;
; Description: Memory Mapped I/O devices.  CIA, SID, VICII, screen memory and 65xx stack
;
; Segments:
;       CIA1                - CIA #1 registers 
;       CIA2                - CIA #2 registers
;       VICII               - VICII registers
;       SID                 - SID Registers
;       SCREEN_MEMORY       - VICII Screen memory definition
;       STACK               - 65xx stack memory
;
;
; Author(s) : John Kiss
;
; Copyright (c) 2025-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

; ******************************************************************************************************************
; SEGMENT : CIA1
; Description: I/O Registers for the 6526 CIA first chipset
;
; System:  C64
; Size :    $10 bytes
; ******************************************************************************************************************
.segment "CIA1"
cia1pra             .res 1      ; 0
cia1prb	            .res 1      ; 1
cia1ddra	        .res 1      ; 2
cia1ddrb	        .res 1      ; 3
cia1t1l	            .res 1      ; 4
cia1t1h	            .res 1      ; 5
cia1t2l	            .res 1      ; 6
cia1t2h	            .res 1      ; 7
cia1tod1            .res 1      ; 8
cia1tods            .res 1      ; 9
cia1todm            .res 1      ; 10
cia1todh            .res 1      ; 11
cia1sdr             .res 1      ; 12
cia1icr             .res 1      ; 13
cia1cra             .res 1      ; 14
cia1crb             .res 1      ; 15

; ******************************************************************************************************************
; SEGMENT : CIA2
; Description: I/O Registers for the 6526 CIA second chipset
;
; System:  C64
; Size :    $10 bytes
; ******************************************************************************************************************
.segment "CIA2"
cia2pra             .res 1      ; 0
cia2prb	            .res 1      ; 1
cia2ddra	        .res 1      ; 2
cia2ddrb	        .res 1      ; 3
cia2t1l	            .res 1      ; 4
cia2t1h	            .res 1      ; 5
cia2t2l	            .res 1      ; 6
cia2t2h	            .res 1      ; 7
cia2tod1            .res 1      ; 8
cia2tods            .res 1      ; 9
cia2todm            .res 1      ; 10
cia2todh            .res 1      ; 11
cia2sdr             .res 1      ; 12
cia2icr             .res 1      ; 13
cia2cra             .res 1      ; 14
cia2crb             .res 1      ; 15

; ******************************************************************************************************************
; SEGMENT : VICII
; Description: I/O Registers for the 6567 VIC-II chipset
;
; System:  C64
; ******************************************************************************************************************
.segment "VICII"

; ******************************************************************************************************************
; SEGMENT : SID
; Description: I/O Registers for the 6581 SID chipset
;
; System:  C64
; ******************************************************************************************************************
.segment "SID"

; ******************************************************************************************************************
; SEGMENT : SCREEN_MEMORY
; Description: Screen memory for text set at 25 rows & 40 columns
;
; target:  C64
; Size  :   $0400 bytes
; ******************************************************************************************************************
.segment "SCREEN_MEMORY"
scr_line0      .res 40
scr_line1      .res 40
scr_line2      .res 40
scr_line3      .res 40
scr_line4      .res 40
scr_line5      .res 40
scr_line6      .res 40
scr_line7      .res 40
scr_line8      .res 40
scr_line9      .res 40
scr_line10     .res 40
scr_line11     .res 40
scr_line12     .res 40
scr_line13     .res 40
scr_line14     .res 40
scr_line15     .res 40
scr_line16     .res 40
scr_line17     .res 40
scr_line18     .res 40
scr_line19     .res 40
scr_line20     .res 40
scr_line21     .res 40
scr_line22     .res 40
scr_line23     .res 40
scr_line24     .res 40

; ******************************************************************************************************************
; SEGMENT : STACK
; Description: Processor stack memory 
;
; System:  C64
; Size  :   $0100 bytes
; ******************************************************************************************************************
.segment "STACK"
stack_space    .res $100

