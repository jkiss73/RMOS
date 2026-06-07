; ******************************************************************************************************************
; File : isr.s
;
; Description: Interrupt handler routines. For the C64, the handles the main system timer (scheduler), Non Maskable Interrupts (nmi) 
;
; Segments:
;      ISR          - ISR memory segment
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
.segment "CORE"

; ****************************************************************
; interrupt scheduler ()
; Description : System interrupt handler for CIA #1 interrupts.
;       Manages all CIA #1 interrupts via a dispatch handler.
;       Re-reads ICRs before exiting and exits (rti) 
;           when all pending interrupts are handled. 
; Params    : none
; Returns : none
; ****************************************************************
scheduler
    ; TODO - Assumption, the only register that will be used in all interrupt handlers is the Accumulator
    ;        except for the context switch handler which uses all registers.    

    ; Save the current state of the Accumlator
    sta z:isr_temp_a 

isr_check_interrupt_status:

	lda cia1icr             ; Clear CIA #1 interrupt by reading the status register
    sta z:isr_cia1_ics      ; Store the CIA 1 status register   

    ; Check if the CIA #1 has any pending interrupts
    ; if ((isr_cia1_ics & $80 )!= $80) 
    ;    goto isr_exit
    ; else
    ;    set isr_cia1_ics_cnt 
    and #$80 
    beq isr_exit

    lda #$10
    sta z:isr_cia1_ics_cnt
    
isr_next_cia1_interrupt:
    
    ; isr_cia1_ics_cnt = 0 >> isr_cia1_ics_cnt
    lsr z:isr_cia1_ics_cnt
    
    ; if (isr_cia1_ics_cnt != 0) then
    ;  Check there is a pending interrupt for this mask
    ;   if ((isr_cia1_ics & isr_cia1_ics_cnt) != 0)
    ;      goto isr_cia1_dispatch_handler()
    ;   else 
    ;      goto isr_next_cia1_interrupt
    ; else
    ;   goto isr_check_interrupt_status()   
    
    ; If the ics bit counter is zero then we are done
    lda z:isr_cia1_ics_cnt
    cmp #$0
    beq :+

    ; Is there a pending interrupt for this bit mask
    lda z:isr_cia1_ics
    and z:isr_cia1_ics_cnt
    bne @isr_cia1_dispatch_handler

    ; If no pending interrupt for this bit mask then 
    ; go check the next interrupt. 
    jmp isr_next_cia1_interrupt   
:
    ; Done handling CIA#1,  
    ; re-read hardware interrupt status registers
    jmp isr_check_interrupt_status
     
@isr_cia1_dispatch_handler:

    ; Check if the CIA #1 Serial Data caused the interrupt
    ; if ((isr_cia1_ics_cnt & $08 )!= $00) 
    ;    goto TBD
    ;lda z:isr_cia1_ics_cnt
    ;and #$08
    ;bne TBD

    ; Check if the CIA #1 Alarm caused the interrupt
    ; else if ((isr_cia1_ics_cnt & $04 )!= $00) 
    ;    goto TBD
    ;lda z:isr_cia1_ics_cnt
    ;and #$04
    ;bne TBD

    ; Check if the CIA #1 Timer B caused the interrupt
    ; else if ((isr_cia1_ics_cnt & $02 ) != $00) 
    ;    goto isr_timer_B
    lda z:isr_cia1_ics_cnt
    and #$02
    bne isr_timer_B

    ; Check if the CIA #1 Timer A caused the interrupt
    ; else if ((isr_cia1_ics_cnt & $01 )!= $00) 
    ;    goto isr_timer_A
    lda z:isr_cia1_ics_cnt
    and #$01
    bne isr_timer_A

    ; else 
    ;   goto next CIA1 interrupt
    jmp isr_next_cia1_interrupt   

isr_timer_B:
  
    ; TODO remove when testing complete
    inc $03

isr_timer_B_done:  
     jmp isr_next_cia1_interrupt
     
isr_timer_A:

@update_kb_rate:
    lda kb_delay
    cmp #$00
    beq @update_kb_rate_done
    dec kb_delay
@update_kb_rate_done:

    ; Increment the 16bit System Timer 
    lda system_timer
    cmp #$FF
    bne @system_timer_increment_lo_byte
@system_timer_increment_hi_byte:
    inc system_timer+1
@system_timer_increment_lo_byte:
    inc system_timer
          
     jmp isr_next_cia1_interrupt
isr_timer_A_done:  

isr_exit:
 
    lda z:isr_temp_a 
    rti


.segment "ISR"

; ****************************************************************
; interrupt nmi ()
; Description : Non maskable interrupt handler for CIA #2 interrupts, 
;               BREAK and Runstop events. 
; Params    : none
; Returns : none
;
; Note: At least on VICE, testing has shwon NMI has a higher priority over IRQ handler. 
;       Meaning, the NMI handler will override  the IRQ handler even if its executing. 
;       This means any CPU registers used in the NMI handler need to be saved and then
;       restored before RTI. 
; ****************************************************************
nmi

   pha   ; Store the A register
   
   txa   ; Store the X register
   pha
   
   tya   ; Store the Y register
   pha
   
   lda cia2icr
; This is nothing more than an indicator that a NMI was triggered. 
; In zero page memory, location $0002 increment a 1 byte counter
; TODO remove when no longer needed
   inc $02
   
   ;lda #$01    ; stop timer A
   ;sta cia2icr

   pla      ; Restore Y register
   tay
   
   pla      ; Restore X register
   tax

   pla      ; Restore A register
   rti


