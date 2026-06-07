; ******************************************************************************************************************
; File : core.s
;
; Description: Kernel core subsystem routines.  
;
; Author(s) : John Kiss
;
; Copyright (c) 2026-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
.segment "CORE"

; ****************************************************************
; public console_init()
; Description : Initialize the core subsystem 
; Returns : None
; ****************************************************************
.proc core_init:  near

initialize_mutex_subsystem:
; Initialize Mutex Subsystem
;
; x = 0
; do{
;    kvMutexList[x] = MUTEX_FREE
;while(x != MAX_MUTEX)

    ldx #$0
    lda #MUTEX_FREE
mutex_init_loop:
    sta kvMutexList,x
    inx 
    cpx #MAX_MUTEX
    bne mutex_init_loop 

;   Reserve mutexs for the kernel API 
    lda #MUTEX_UNLOCKED
    ldx #MUTEX_CORE_ID
    sta kvMutexList,x

; Initialize Task Control Block list
initialize_tcb_list:
;
; x = 0
; task_index = 0
;
; do{
;    zpTaskControlList[x].id_flag = task_index
;    /* Initialize all other fields to zero */
;    x+= sizeof (TASK_CTRL_BLOCK)
;while(task_index != MAX_TASKS)
;
;

    ldx #$0
    lda #$0
    sta task_index
    
tcb_init_loop:
  
  
    sta zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x

    lda #$00
    sta zpTaskControlList + TASK_CTRL_BLOCK::type_pri,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::areg,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::xreg,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::yreg,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::streg,x

    sta zpTaskControlList + TASK_CTRL_BLOCK::sp,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::sp+1,x

    sta zpTaskControlList + TASK_CTRL_BLOCK::addr,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x

    sta zpTaskControlList + TASK_CTRL_BLOCK::info,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::info+1,x

    txa
    cld
    clc
    adc #.sizeof(TASK_CTRL_BLOCK)
    tax
    
    inc task_index
    lda task_index
    cmp #MAX_TASKS
    bne tcb_init_loop

    
; Initialize the System Timer counter
    lda #0
    sta <system_timer           
    sta >system_timer   

    ; Initialize System Flags
    lda #$00
    sta zpSystemFlags

    rts
.endproc


; ****************************************************************
; public areg syscall_mutex_allocate (void)
; Description : Allocate a mutex handler
;                       
; Params:   none
; Returns : mutex_handle (0-(MAX_MUTEX - 1), KERR_NO_RESOURCES      
; ****************************************************************
.proc syscall_mutex_allocate: near
    ; TODO, this should start at the first unreserved MUTEX in the list. 
    ldx #0          ; Start looking for a free mutex handler 

@mutex_loop:

    ; Go through the mutex array looking for a unallocated cell
    ; 
    ; do{
    ;   y = x
    ;   if (mutex[y] == MUTEX_FREE)
    ;       mutex[x] = MUTEX_UNLOCKED
    ;       a = x
    ;       return(a)
    ;   else if (x >= MAX_MUTEX)
    ;       a = SYS_ERR_RESOURCES
    ;       return(a);   
    ;   x++     
    ; }while(x < MAX_MUTEX)
    ;
    ;   
    lda kvMutexList,x
    tay
    cpy #MUTEX_FREE
    bne :+

    lda #MUTEX_UNLOCKED
    sta kvMutexList,x

    txa
    rts
:
    cpx #MAX_MUTEX
    bcs :+ 
    
    inx
    jmp @mutex_loop
:  
    lda #KERR_NO_RESOURCES
    rts             ; done, return with result in a

.endproc


; ****************************************************************
; public areg syscall_mutex_free (areg id)
; Description : Free a mutex handler. Must be in the unlocked state to free. 
;                
; Params:   id  - Mutex id
; Returns : TRUE on success.   
; ****************************************************************
.proc syscall_mutex_free: near
    pha
    tax

    ; if (x >= MAX_MUTEX) return false; 
    cpx #MAX_MUTEX
    bcs :+   

    lda kvMutexList,x

    ; Only free the mutex handler if it is in the unlocked state
    ; if (x != MUTEX_UNLOCED ) return false
    tax
    cpx #MUTEX_UNLOCKED
    bne :+

    pla
    tax
    lda #MUTEX_FREE
    sta kvMutexList,x

    lda #$01        ; set result to true
    rts             ; Done an return result in a
    
:  
    pla             ; Return a negative value;
    lda #$0
    rts             ; done, return with result in a

.endproc

; ****************************************************************
; public areg syscall_mutex_lock (areg id)
; Description : Lock a mutex           
; params    areg - mutex handle aka idx into the array.
; Returns : 0 not locked  
; ****************************************************************
.proc syscall_mutex_lock: near

    pha
    tax

    ; if (x >= MAX_MUTEX) return false; 
    cpx #MAX_MUTEX
    bcs :++   

    sei                     ; Stop interrupts - CRITICAL SECTION

    lda kvMutexList,x

    ; if the mutex is already locked by the current task
    ; then return with positive result.
    cmp current_task_idx
    beq :+
    
    ; if the mutex is already locked 
    ; return false;
    ; if (x != #MUTEX_UNLOCKED) return false
    cmp #MUTEX_UNLOCKED
    bne :++

    ; Lock the mutex and then enable interrupts
    pla
    tax
    lda current_task_idx
    sta kvMutexList,x

    cli
    lda #$01        ; set result to true
    rts             ; done, return result in a
:
    pla
    cli
    lda #$01        ; set result to true
    rts             ; done, return result in a
:  
    pla             ; Return a negative value;
    cli
    lda #$0
    rts             ; done, return with result in a
.endproc

; ****************************************************************
; public areg syscall_mutex_is_locked (areg id)
; Description : Check if a mutex is locked.           
; params    areg  - mutex handle aka idx into the array.
; Returns : 0 not locked  
; ****************************************************************
.proc syscall_mutex_is_locked: near
    tax

    ; if (x >= MAX_MUTEX) return false; 
    cpx #MAX_MUTEX
    bcs :+   
    lda kvMutexList,x

    ; if (x != MUTEX_UNLOCKED) return false
    tax
    cpx #MUTEX_UNLOCKED
    bne :+

    lda #$01        ; set result to true
    rts             ; Done an return result in a
    
:                   ; Return a negative value;
    lda #$0
    rts             ; done, return with result in a
.endproc

; ****************************************************************
; public areg syscall_mutex_unlock (areg id)
; Description : Unlock the mutex. Can only be unlocked by the owner
;           of the mutex lock.            
; params    areg - mutex handle aka idx into the array.
; Returns : a == 0 falue to unlock.   
; ****************************************************************
.proc syscall_mutex_unlock: near
    pha
    tax

    ; if (x >= MAX_MUTEX) return false; 
    cpx #MAX_MUTEX
    bcs :+   
    lda kvMutexList,x

    ; if the task unlocking is not the one that locked it
    ; return false;
    ; if (x != current task ID) return false
    tax
    cpx current_task_idx
    bne :+

    ; if the mutex is not locked
    ; return false;
    ; if (x == #MUTEX_UNLOCKED) return false
    tax
    cpx #MUTEX_UNLOCKED
    beq :+

    pla
    tax
    lda #MUTEX_UNLOCKED
    sta kvMutexList,x

    lda #$01        ; set result to true
    rts             ; Done an return result in a
    
:  
    pla             ; Return a negative value;
    lda #$0
    rts             ; done, return with result in a

.endproc

; ****************************************************************
; public areg syscall_sched_calc_tcb_offset (areg tcb_idx)
; Uses Registers: : a, x
; Description : Calculate the TCB CONTROL BLOCK offset from the provided index.    
;                
; Params:   tcb_idx - Task Control Block ID aka index. 
; Returns : areg    - TCB Block offset   
; ****************************************************************
.proc syscall_sched_calc_tcb_offset
;
;   xreg =  tcb_id
;   areg = 0
;   while (xreg != 0) {
;       areg += sizeof(TASK_CTRL_BLOCK)
;       dec xreg
;   }
;   return (areg);

    tax 
    lda #$00
:     
    cpx #$00
    beq :+

    cld     ; clear decimal mode
    clc     ; clear the carry flag
    adc #.sizeof(TASK_CTRL_BLOCK)
    
    dex
    jmp :-
:
   rts  
.endproc

; ****************************************************************
; public areg syscall_sched_tcb_allocate (void)
; Uses Registers: a,x,y
; Description :  Allocate a free TCB block and return the tcb index
;                
; Params:  None
;
; Returns : failure - KERR_NO_RESOURCES - no free TCB blocks
;           success - 0 to (MAX_TASKS -1) index to allocated tcb block.  
; ****************************************************************
;   yreg = 0
;   do {
;       areg = yreg
;       xreg = _syscall_sched_calc_tcb_offset()
;
;       if ((zpTaskControlList[xreg].id_flag & TCB_FLAG_MASK) == TCB_FLAG_FREE)
;       {
;           zpTaskControlList[xreg].id_flag |= TCB_FLAG_STOPPED
;           areg = yreg
;           return(areg)
;       }
;   }while (y < MAX_TASK)
;   areg = $FF
;   return(areg)
;
.proc syscall_sched_tcb_allocate: near

    ; TODO this should start at the first unreserved TCB in the TCB list. 
    ldy #$00

    ENTER_CRITICAL_SECTION
 :   
    tya
    jsr syscall_sched_calc_tcb_offset

    tax
 
    lda zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x
    
    and #TCB_FLAG_MASK
    tax
    cpx #TCB_FLAG_FREE
    beq :+

    iny
    cpy #MAX_TASKS
    bne :-

    LEAVE_CRITICAL_SECTION

    ; Return error, 
    lda #KERR_NO_RESOURCES
    rts
:
    tya
    jsr syscall_sched_calc_tcb_offset
    tax
    lda zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x
    ora #TCB_FLAG_STOPPED
    sta zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x

    LEAVE_CRITICAL_SECTION
    
    tya
    rts           
.endproc

; ****************************************************************
; public proc areg syscall_sched_tcb_free(areg tcb_idx)
; Uses Registers : a,x,y
; Description :  Free a tcb, must be stopped first.  
;                
; Params:   tcb_idx     - Index into the TCB Control block array. 
;
; Returns : 0 for success.  1 = means error ( not stopped or not allocated)   
; ****************************************************************
.proc syscall_sched_tcb_free: near
    tax

    ; if (x >= MAX_TASKS) return error; 
    cpx #MAX_TASKS
    bcs :+   

    jsr syscall_sched_calc_tcb_offset
    
    tay     ; Save the offset 
    tax

    lda zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x
    
    and #TCB_FLAG_MASK
    tax

    cpx #TCB_FLAG_STOPPED   ; Must be in the stopped state
    bne :+

    cpx #TCB_FLAG_FREE      ; Must be allocated 
    beq :+

    tya         ; Retrieve the offset
    tax

    lda zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x
    and #TCB_FLAG_FREE
    sta zpTaskControlList + TASK_CTRL_BLOCK::id_flag,x

    lda #$00    ; return success
    rts
:
    lda #$01
    rts           
.endproc

; ****************************************************************
; public syscall_sched_task_context_switch ()
;
; Description : Calling task gives up its time and forces a context switch. 
;       This routine must be called from a JSR command.   
;            
; params    none
; Returns : none   
; ****************************************************************
syscall_sched_task_context_switch:

    DISABLE_INTERRUPTS

    ; Save current task registers 

    lda current_tcb_array_idx
    tax

  ; When context switching from a user task, saving the a, x & y registers 
  ; don't matter since this is called from a user level wrapper function. 
  ; Also the status register will not be on the stack so just set all 
  ; registers to zero.   
    lda #$00
    sta zpTaskControlList + TASK_CTRL_BLOCK::areg,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::xreg,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::yreg,x
    sta zpTaskControlList + TASK_CTRL_BLOCK::streg,x

    ; Since this routine is called from a JSR, it expects a RTS
    ; But this routine always returns with RTI so the status
    ; register is restored. A JSR will put return address
    ; on the stack minus one byte expecting the RTS call to add 
    ; the byte. Since we are using RTI, we need to add one byte  
    ; to the return address. 
    pla 
    tay
    iny
    tya
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr,x

    ; If we've inremented the lower address byte by 1 and wrapped back to zero
    ; then we need to increment the upper address by 1      
    cmp #$00
    bne :+

    pla
    tay
    iny
    tya
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x
    jmp :++
:
    pla
    sta zpTaskControlList + TASK_CTRL_BLOCK::addr+1,x
 :
    ; Complete the context switch by jumping to the common code 
    ; located in the ISR handler.
    jmp context_switch_user_entry
; ****************************************************************


; ****************************************************************
; public areg syscall_system_control (areg cmd, xreg + yreg *data)
; Uses registers : a,x,y
;
; Description :  
;            
; params    cmd     :  (PREEMPT_SCHED_ON, PREEMPT_SCHED_OFF, SET_DATE, SET_TIME, GET_DATE, GET_TIME )
;           *data   :  Data pointer for some commands, otherwise set to NULL  
; Returns : TRUE on success   
; ****************************************************************
.proc syscall_system_control : near

    cmp #$00
    bne :+
    
    lda #$00
    sta zpPreemptionEnabled
:   
    cmp #$01
    bne :+

    lda #$01
    sta zpPreemptionEnabled
:
    rts
.endproc
