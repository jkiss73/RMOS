; ******************************************************************************************************************
; File : init.s
;
; Description: Initialize I/O devices, memory, system configuration, chipsets and startup the system interrupt.
;              The main kernel task is also located in the INIT segment. 
;
; Segments:
;      INIT            - Memory segment for initializing the C64       
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

; ******************************************************************************************************************
; SEGMENT : INIT
;
; Description: Kernel initialization, jump location from the CPU start vector. Also contains the kernel task
;
; ******************************************************************************************************************
.segment "INIT"

kernel_start:
    DISABLE_INTERRUPTS

; Initialize the CPU stack 
; By default (at startup) the 65xx has the stack pointer at the bottom ($100)
; stack memory $01FF - $0100
    lda #dflt_stack_addr
    tax
    txs
   
; By default, clear decimal mode
    cld
    
; Initialize the 65xx registers
; *****************************
; Data I/O Register 
; Different settings than the C64 kernel configuration since no cassette support. 
; Note, setting the I/O register must come before the Direction Register at least for VICE
;
; TODO - when loading kernel from disk this will change. 
;
; Bit      Name                      XTC System Settings 
; ------------------------------------------------------------------
; 0  - LOW RAM						 1  - BASIC ROM Enabled                  
; 1  - HIGH RAM                      1  - KERNEL ROM Enabled
; 2  - CHAREN                        1  - Character ROM Enabled
; 3  - Cassette Write                0  - Disabled
; 4  - Cassette Sense                0  - Disabled
; 5  - Cassette Motor Ctrl           0  - Disabled
@init_6510
    lda #%00000111   		; No Cassette support, BASIC, KERNEL and CHAR ROMS enabled  
    sta io6510_reg
    
; Direction registers 
; Bit      Name                      CPU Default 
; ------------------------------------------------------------------
; 0  - LOW RAM						 1  - OUTPUT                  
; 1  - HIGH RAM                      1  - OUTPUT
; 2  - CHAREN                        1  - OUTPUT
; 3  - Cassette Write                1  - OUTPUT
; 4  - Cassette Sense                0  - INPUT
; 5  - Cassette Motor Ctrl           1  - OUTPUT
    lda #%00101111   ; This is the default CPU setting
    sta d65xx_reg 

; Initialize the entire zero page memory
; *******************************************
; starting at location $0002 to $00FF
;
;  y = 2
;  acc = 0
;  do {
;   *(0000+y) = acc
;   y++   
;  } while (y != 0)
init_zp
    lda #$2         ;start at offset 2
	tay             
	lda #$00		;zero the memory
:	
    sta $0000,y     ;Write $00 to the memory location
	iny
	bne :-      ; if the index not wrapped to zero

 
    jsr io_devices_init
    
    jsr console_init
 
    ldx #<kernel_msg
    ldy #>kernel_msg
    jsr PrintAsciiZ

    ldx #<starting_msg
    ldy #>starting_msg
    jsr PrintAsciiZ


; Main system interrupt is CIA #1, timer 1 set to 1/60hz 
; TODO - For PAL system, will need additional logic
init_sys_interrupt:

	lda #<ntsc_sys_clk     
	sta cia1t1l
	lda #>ntsc_sys_clk
    sta cia1t1h

	lda #$81        ;enable t1 irq's
	sta cia1icr
	lda cia1cra
	and #$80        ;mask TOD 
	ora #$11        ;enable timer1 %00010001
	sta cia1cra
   
  
; Main Kernel task
kernel_main:

    lda #$1
    jsr CursorOn
    
    lda #blink_rate
    sta blink_cnt

    ldx #<ready_msg
    ldy #>ready_msg
    jsr PrintAsciiZ

    ; Kernel Ready
    ENABLE_INTERRUPTS

kernel_top:
    jsr kernel_task

    ; Should never get here but if it does, just loop back to the kernel task. 
    jmp kernel_top


