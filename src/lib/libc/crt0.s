; ******************************************************************************************************************
; File : crt0.s
;
; Description: Application C runtime startup and close.        
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
       .include "zeropage.inc"                          ; This is found in cc65 include directory 

       .export         __STARTUP__ : absolute = 1       
       .import         zerobss                          ; Located in CC65 runtime library
       .import         __CSTACK_START__                 ; Provided by linker script               
       .import         _main

       .segment "STARTUP"

      ; TODO call create task and allocate h/w stack memory

       ; Initialize the C stack pointers located in zeropage
       lda #<__CSTACK_START__
       sta c_sp
       lda #>__CSTACK_START__
       sta c_sp+1
       
       ; Initialize the Block Started By Symbol (BSS) for unitialized and static data.
       jsr zerobss
       
       lda #$00
       ldx #$00
       ldy #$00
       jsr _main

; TODO after main returns free task control block and h/w stack memory. 
 @idle:
       jmp @idle
       rts
