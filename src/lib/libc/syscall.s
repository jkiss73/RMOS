; ******************************************************************************************************************
; File : syscall.s
;
; Description: Application interface to kernel and driver routines. 
;       All routines must be thread safe and only use cpu registers and hardware stack.  
;
; Segments:
;      SYSCALL          - System call memory segment.        
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

.include "kapi-gen.inc"

; TODO, integrate into kernel and change to  segment "SYSCALL". 
.segment "CODE"

.export _sched_calc_tcb_offset
.export _sched_tcb_allocate
.export _sched_tcb_free
.export _sched_yield

.export _system_control

.export _console_control
.export _putchar
.export _getchar
.export _cursor_pos
.export _clrscr
.export _clrline
.export _text_color
.export _background_color
.export _border_color

.export _mutex_allocate 
.export _mutex_free 
.export _mutex_lock 
.export _mutex_is_locked 
.export _mutex_unlock 

.importzp	c_sp, sreg, regsave, regbank
.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
.macpack	longbranch

.import incsp1
.import incsp2
.import incsp3

.define MAX_MUTEX               10
.define MUTEX_FREE              $AA
.define MUTEX_UNLOCKED          $FF

.define SYS_ERR_NONE            $00
.define SYS_ERR_RESOURCES       $F0      

.define KMEM_TEXT_COLOR             $0204
.define KMEM_BG_COLOR_COLOR         $D021
.define KMEM_BORDER_COLOR           $D020

; ****************************************************************
; public void _system_control (uint8_t command, uint8_t *data)
; Description : Set or get system configuration 
;    
; Params:   command - SET, GET, ON, OFF
;           *data  - pointer to a task memory location required for the command.
;  
; Returns : None   
; ****************************************************************
.proc _system_control: near
        jsr SYSCALL_SYSTEM_CONTROL
        rts             
.endproc

; ****************************************************************
; public areg _sched_calc_tcb_offset (areg tcb_idx)
; Uses Registers: : a, x
; Description : Calculate the TCB CONTROL BLOCK offset from the provided index.    
;                
; Params:   tcb_idx - Task Control Block ID aka index. 
; Returns : areg    - TCB Block offset   
; ****************************************************************
.proc _sched_calc_tcb_offset
        jsr SYSCALL_SCHED_TCB_OFFSET
        rts  
.endproc

; ****************************************************************
; public areg _sched_tcb_allocate (void)
; Uses Registers: a,x,y
; Description :  Allocate a free TCB block and return the tcb index
;                
; Params:   id      - sub-system id (SCHEDULER, HARD_TIMER, DATE, TIME)
;
; Returns : failure - SYS_ERR_RESOURCES on out of resources
;           success - 0 to (MAX_TASKS -1) index to allocated tcb block.  
; ****************************************************************
.proc _sched_tcb_allocate: near
        jsr SYSCALL_SCHED_ALLOCATE
        rts           
.endproc

; ****************************************************************
; public proc
; Description :  
;                
; Params:   id      - sub-system id (SCHEDULER, HARD_TIMER, DATE, TIME)
;
; Returns : TRUE on success   
; ****************************************************************
.proc _sched_tcb_set_callback: near
        rts           
.endproc

; ****************************************************************
; public proc
; Description :  
;                
; Params:   id      - sub-system id (SCHEDULER, HARD_TIMER, DATE, TIME)
;
; Returns : TRUE on success   
; ****************************************************************
.proc _sched_tcb_set_state: near
    rts           
.endproc

; ****************************************************************
; public proc
; Description :  
;                
; Params:   id      - sub-system id (SCHEDULER, HARD_TIMER, DATE, TIME)
;
; Returns : TRUE on success   
; ****************************************************************
.proc _sched_tcb_set_stack_pointer: near
    rts           
.endproc

; ****************************************************************
; public proc
; Description :  
;                
; Params:   id      - sub-system id (SCHEDULER, HARD_TIMER, DATE, TIME)
;
; Returns : TRUE on success   
; ****************************************************************
.proc _sched_tcb_set_priority: near
    rts           
.endproc

; ****************************************************************
; public proc
; Description :  
;                
; Params:   id      - sub-system id (SCHEDULER, HARD_TIMER, DATE, TIME)
;
; Returns : TRUE on success   
; ****************************************************************
.proc _sched_tcb_set_info: near
    rts           
.endproc

; ****************************************************************
; public proc areg _sched_tcb_free(areg tcb_idx)
; Uses Registers : a,x,y
; Description :  Free a tcb, must be stopped first.  
;                
; Params:   tcb_idx     - Index into the TCB Control block array. 
;
; Returns : 0 for success.  1 = means error ( not stopped or not allocated)   
; ****************************************************************
.proc _sched_tcb_free: near
        jsr SYSCALL_SCHED_FREE
        rts           
.endproc

; ****************************************************************
; public proc void _sched_yield(void)
; Description : Current task force a context switch
;                
; Params: None
;
; Returns : None   
; ****************************************************************
.proc _sched_yield: near
    jsr SYSCALL_SCHED_USER_CS
    rts           
.endproc

; ****************************************************************
; public void _console_control (uint8_t command, uint8_t *data)
; Description : Set or get console configuration 
;    
; Params:   command - SET, GET, ON, OFF
;           *data  - pointer to a task memory location required for the command.
;  
; Returns : None   
; ****************************************************************
.proc _console_control: near
        jsr SYSCALL_CONSOLE_CTRL
        rts             
.endproc

; ****************************************************************
; public void _putchar (uint8_t ch)
; Description : Write a character to the current cusor position   
;    
; Params:   ch  - PETASCII character 
;  
; Returns : None   
; ****************************************************************
.proc _putchar : near
    jsr SYSCALL_PUTCHAR
    rts
.endproc

; ****************************************************************
; public uint8_t _gutchar ()
; Description : Get a character from the keyboard buffer    
;    
; Returns : uint8_t PETASCII character   
; ****************************************************************
.proc _getchar : near
    jsr SYSCALL_GETCHAR
    rts
.endproc

; ****************************************************************
; public void _clrscr()
; Description : Clear the current screen. Needs to be in text mode.    
;    
; Returns : None 
; ****************************************************************
.proc _clrscr : near
    jsr SYSCALL_CLRSCR
    rts
.endproc

; ****************************************************************
; public void _clrsline(uint8_t row)
; Description : Clear  all text on the specified row. 
;               Needs to be in text mode.    
; Params : row - Row to clear (0-24)   
; Returns : None 
; ****************************************************************
.proc _clrline : near
    jsr SYSCALL_CLRLINE
    rts
.endproc

; ****************************************************************
; public void _text_color(uint8_t color)
; Description : Set the texts foreground color.      
; 
; Params : color    - value from 0 - 15   
;
; Returns : None 
; ****************************************************************
.proc _text_color : near
    sta KMEM_TEXT_COLOR
    rts
.endproc

; ****************************************************************
; public void _background_color(uint8_t color)
; Description : Set the texts background color.      
; 
; Params : color    - value from 0 - 7   
;
; Returns : None 
; ****************************************************************
.proc _background_color : near
    sta KMEM_BG_COLOR_COLOR
    rts
.endproc

; ****************************************************************
; public void _border_color(uint8_t color)
; Description : Set the screen boarder color.      
; 
; Params : color    - value from 0 - 15   
;
; Returns : None 
; ****************************************************************
.proc _border_color : near
    sta KMEM_BORDER_COLOR
    rts
.endproc


; ****************************************************************
; public void _cursor_pos(uint8_t x, uint8_t y)
; Description : Set the text cursor position.      
; 
; Params : x        - Set the cursors horziontal position
;        : y        - Set the cursors vertical position   
;
; Returns : None 
; ****************************************************************
.proc _cursor_pos : near
    pha                 ; Save the Y param on the HW stack

	ldy     #$00        ; Get the X Param from the C Stack. 
	lda     (c_sp),y

    tax                 ; Place the X param into the X Register
    pla                 ; Get the Y Param from the HW stack
    tay                 ; Place the Y Param into the Y Register

    jsr     SYSCALL_SETPOSXY       ; Call the Set XY Kernel Routine

	jmp     incsp1       ; Decrement the C Stack pointer by 1 param.
    rts
.endproc

; ****************************************************************
; public gMutexID _mutex_allocate()
; Description : Allocate a mutex handle     
;    
; Returns : a mutex handle  (0-(MAX_MUTEX - 1) or KERR_NO_RESOURCES 
; ****************************************************************
.proc _mutex_allocate 
    jsr SYSCALL_MUTEX_ALLOCATE 
.endproc

; ****************************************************************
; public bool _mutex_free(gMutexID handle)
; Description : free a mutex handle and return it to the pool. 
;           Mutex must be in unlocked state to be freed.       
; 
; Params : handle   - Mutex handle to free   
; Returns : TRUE on success, FALSE for fail  
; ****************************************************************
.proc _mutex_free 
    jsr SYSCALL_MUTEX_FREE 
    rts
.endproc

; ****************************************************************
; public bool _mutex_lock(gMutexID handle)
; Description : Lock a mutex preventing other tasks from locking.
;      If the task already has the mutex locked this will return success.           
; 
; Params : handle   - Mutex handle to lock   
; Returns : TURE on mutex sucessfully locked, FALSE on fail  
; ****************************************************************
.proc _mutex_lock 
    jsr SYSCALL_MUTEX_LOCK 
    rts 
.endproc

; ****************************************************************
; public bool _mutex_is_locked(gMutexID handle)
; Description : Check if a mutex is already locked. 
; 
; Params : handle   - Mutex handle to check lock staet   
; Returns : TRUE for mutex is locked, FALSE on unlocked  
; ****************************************************************
.proc _mutex_is_locked 
    jsr SYSCALL_MUTEX_IS_LOCKED 
    rts 
.endproc

; ****************************************************************
; public bool _mutex_unlock(gMutexID handle)
; Description : Unlock a mutex. Only the task that locked it 
;           can unlock it.            
; 
; Params : handle   - Mutex handle to unlock   
; Returns : TRUE for mutex is unlocked, FALSE on fail  
; ****************************************************************
.proc _mutex_unlock 
    jsr SYSCALL_MUTEX_UNLOCK 
    rts 
.endproc
