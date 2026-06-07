; ******************************************************************************************************************
; File : vars.s
;
; Description: Variable defintions for Zeropage & kernel    
;
; Segments:
;       ZEROPAGE            - Variables stored in zero page 
;       KVAR                - Kernel variables  
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

; ******************************************************************************************************************
; SEGMENT : ZEROPAGE
; Description: Kernel and built in driver variables that require fast read and write access. 65xx instructions 
;         addressing memory from zeropage require less CPU cycles than from other memory locations. 
;
; System:  C64
; ******************************************************************************************************************
.segment  "ZEROPAGE": zeropage

zpResv                  .res 9  ; TODO Remove - memory used for testing only
system_timer            .res 2  ; 16bit System Timer Count
isr_cia1_ics            .res 1  ; CIA #1 current ISR state. 
isr_cia1_ics_cnt        .res 1  ;
isr_temp_a              .res 1  ; ISR a register storage

; CONSOLE DRIVER ZERO PAGE
scr_color_ptr	        .res 2  ; Screen color map row pointer
scr_ptr	                .res 2  ; Screen row pointer
msg_ptr                 .res 2  ; Pointer to current string printed to screen
kb_char_map_ptr         .res 2  ; Current input character map pointer
console_rsv             .res 1  ; 

; ******************************************************************************************************************
; SEGMENT : KVAR
; Description: Kernel Variables
;
; System:  C64
; ******************************************************************************************************************
.segment "KVAR" 

; screen_flags 1 byte
;  bit 0 ($1)   - Blink Enabled
;  bit 1 ($2)   - Blink State (0 = off, 1 = on)
;  bit 2 ($4)   - Screen Character Set (0 = Set 1, 1 - Set 2)
;  bit 3 ($8)   -
;  bit 4 ($10)  -
;  bit 5 ($20)  -
;  bit 6 ($40)  -
;  bit 7 ($80)  - 
screen_flags            .res 1
cursor_row              .res 1
cursor_col              .res 1
blink_cnt               .res 1
color	                .res 1   ;Current text color 
kb_char_input           .res 1   ;Keyboard input byte
kb_buffer               .res 1  ; Keyboard input buffer

; CONSOLE DRIVER ZERO PAGE
kb_delay                .res 1  ; Keyboard type rate delay



