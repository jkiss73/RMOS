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
.if 1
scheduler
    ; TODO - Assumption, the only register that will be used in all interrupt handlers is the Accumulator
    ;        except for the context switch handler which uses all registers.    

    ; Save the current state of the Accumlator
    sta z:sched_temp_a 

    lda #$00 
    sta z:isr_pending_cs

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
    ; If preemption is disabled then do not enable the 
    ; context switch flag. 
    lda zpPreemptionEnabled
    cmp #0
    beq :+

    lda #$01
    sta z:isr_pending_cs
:

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
    lda z:isr_pending_cs
    cmp #$0
    bne @isr_context_switch
 
    lda z:sched_temp_a 
    rti

@isr_context_switch:
    ; Save current task registers 
    txa         ; Store the x register onto the stack
 	sta z:sched_temp_x

    lda current_tcb_array_idx
    tax
    
    lda z:sched_temp_a
    sta zpTaskControlList + TASK_CTRL_BLOCK::areg,x
    
    lda z:sched_temp_x
    sta zpTaskControlList + TASK_CTRL_BLOCK::xreg,x
    
    tya
    sta zpTaskControlList + TASK_CTRL_BLOCK::yreg,x
    
    pla
    sta zpTaskControlList + TASK_CTRL_BLOCK::streg,x

    pla 
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr,x
    
    pla
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x

; ****************************************************************
; public context_switch_user_entry ()
;
; Description : user syscall yield jumps here for a context switch. 
;
; params    none
;
; Returns : none   
; ****************************************************************
 context_switch_user_entry:
    ; ***************************************************
    ; Save the current stack pointer to the tcb instance
    ; ***************************************************
    tsx                     ; Get the current stack pointer
    txa 
    pha                     ; push the value to the stack

    ; Get the tcb index and store it to it's TCB instance
    lda current_tcb_array_idx
    tax
    pla                     ; pop stack pointer off stack 
    sta zpTaskControlList + TASK_CTRL_BLOCK::sp,x
    
; Simple Round Robin Scheduler
; TODO - This loop will be endless (ISR will be stuck) if all tasks (including task 0) are not set to the run state
;
; do{
;
; if (current_task_idx > MAX_TASKS) 
;     current_task_idx = 0
; else
;      current_task_idx++
; 
; x = task_get_tcb_array_index
; 
; while(zpTaskControlList[x].id_flag & TCB_FLAG_RUN != TCB_FLAG_RUN)
;
; sched_temp = zpTaskControlList[x].sp
; current_tcb_array_idx = x
; ***** 

sched_top:
    lda z:current_task_idx
    cmp #MAX_TASKS-1
    beq set_top_context

    inc z:current_task_idx
    lda z:current_task_idx
    jmp chk_context

set_top_context:  
    lda #$0
    sta z:current_task_idx

chk_context:
    jsr task_get_tcb_array_index

    lda zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x
    and #TCB_FLAG_RUN
    beq sched_top

next_context:
    
    lda zpTaskControlList + TASK_CTRL_BLOCK::sp,x
    sta z:sched_temp_x
    
    txa
    sta z:current_tcb_array_idx
    
    
    ;restore switched task context registers     
  
    lda z:sched_temp_x
    tax
    txs

    lda current_tcb_array_idx
    tax
    
    ; Retreive the high byte of the return address and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x
    pha
    
    ; Retreive the low byte of the return address and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::addr,x
    pha

    ; Get the stored status register and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::streg,x
    pha
    

    ; Get the stored a register and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::areg,x
    pha
    
    ; Get the stored x register and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::xreg,x
    pha

    lda zpTaskControlList + TASK_CTRL_BLOCK::yreg,x
    tay
    
    pla         ; Restore the x register
    tax

    pla         ; Restore the a register
cs_done:
     ENABLE_INTERRUPTS
; No this is not an error. No matter what return from an interrupt, even
; when called from a JSR command. This accounts for a task that was 
; preempted from the ISR and goes back to the extact state. The RTI sets 
; the status register back which is on the CPU stack  
     rti



; -----------------------------------------------------------------------------------
; DEBUG ISR PREEMPTIVE SCHEDULER 
; -----------------------------------------------------------------------------------
.else
scheduler

    ; Save the current state of the Accumlator
    sta z:sched_temp_a 

  	lda cia1icr             ; Clear CIA #1 interrupt by reading the status register
    sta z:isr_cia1_ics      ; Store the CIA 1 status register   


@update_kb_rate:
    lda kb_delay
    cmp #$00
    beq @update_kb_rate_done
    dec kb_delay
@update_kb_rate_done:
 

@isr_context_switch:
    ; Save current task registers 

    txa         ; Store the x register onto the stack
	sta z:sched_temp_x

    lda current_tcb_array_idx
    tax
    
    lda z:sched_temp_a
    sta zpTaskControlList + TASK_CTRL_BLOCK::areg,x
    
    lda z:sched_temp_x
    sta zpTaskControlList + TASK_CTRL_BLOCK::xreg,x
    
    tya
    sta zpTaskControlList + TASK_CTRL_BLOCK::yreg,x
    
    pla
    sta zpTaskControlList + TASK_CTRL_BLOCK::streg,x

    pla 
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr,x
    
    pla
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x
    
 
    ; ***************************************************
    ; Save the current stack pointer to the tcb instance
    ; ***************************************************
    tsx                     ; Get the current stack pointer
    txa 
    pha                     ; push the value to the stack

    ; Get the tcb index and store it to it's TCB instance
    lda current_tcb_array_idx
    tax
    pla                     ; pop stack pointer off stack 
    sta zpTaskControlList + TASK_CTRL_BLOCK::sp,x
    
; Simple Round Robin Scheduler
; TODO - This loop will be endless (ISR will be stuck) if all tasks (including task 0) are not set to the run state
;
; do{
;
; if (current_task_idx > MAX_TASKS) 
;     current_task_idx = 0
; else
;      current_task_idx++
; 
; x = task_get_tcb_array_index
; 
; while(zpTaskControlList[x].id_flag & TCB_FLAG_RUN != TCB_FLAG_RUN)
;
; sched_temp = zpTaskControlList[x].sp
; current_tcb_array_idx = x
; ***** 

@sched_top:
    lda z:current_task_idx
    cmp #MAX_TASKS-1
    beq @set_top_context

    inc z:current_task_idx
    lda z:current_task_idx
    jmp @chk_context

@set_top_context:  
    lda #$0
    sta z:current_task_idx

@chk_context:
    jsr task_get_tcb_array_index

    lda zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x
    and #TCB_FLAG_RUN
    beq @sched_top

@set_next_context:
    
    lda zpTaskControlList + TASK_CTRL_BLOCK::sp,x
    sta z:sched_temp_x
    
    txa
    sta z:current_tcb_array_idx
    
    
    ;restore switched task context registers     
  
    lda z:sched_temp_x
    tax
    txs

    lda current_tcb_array_idx
    tax
    
    ; Retreive the high byte of the return address and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x
    pha
    
    ; Retreive the low byte of the return address and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::addr,x
    pha

    ; Get the stored status register and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::streg,x
    pha
    

    ; Get the stored a register and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::areg,x
    pha
    
    ; Get the stored x register and push it onto the stack
    lda zpTaskControlList + TASK_CTRL_BLOCK::xreg,x
    pha

    lda zpTaskControlList + TASK_CTRL_BLOCK::yreg,x
    tay
    
    pla         ; Restore the x register
    tax

    pla         ; Restore the a register

isr_context_switch_done:    

     
isr_done:
     rti
.endif

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


