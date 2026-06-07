; ******************************************************************************************************************
; File : kernel_task.s
;
; Description: Kernel task  
;
; Segments:
;       CORE         
;
; Author(s) : John Kiss
;
; Copyright (c) 2026-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
.segment "CORE"

.proc kernel_task: near

    ldx #<input_prompt
    ldy #>input_prompt
    jsr PrintAsciiZ

:   
    ; Keyboard delay is decremented in the system interrupt
    ; Used to control keyboard debounce 
    lda #type_rate
    sta kb_delay 

:
    ; When reaches it zero, scan the keyboard for a keypress 
    lda kb_delay
    cmp #$00
    bne :-

    jsr KeyboardScan

    jsr syscall_get_kb_char

    ; If there is a character from the keyboard print it to the screen 
    cmp #$00
    beq :+

    jsr syscall_put_char

:  
    ; go back to the top to read the next keyboard event
    jmp :---

    ; Should never get here 
    rts
.endproc
