; ******************************************************************************************************************
; File : console.s
;
; Description: C64 text console driver, screen output and keyboard input. 
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
.segment "DRIVERS"

; ****************************************************************
; public PrintAsciiZ (x,y)
; Description : Print an ascii string, convert to PET ascii and print.          
; params    x - string low  address
;           y - string high adddress
; Returns : number of bytes in string, not including the null terminator. 
; ****************************************************************
PrintAsciiZ:
    stx msg_ptr
    sty msg_ptr+1

    ldy #0
@top:   
    tya
    tax    
    lda (msg_ptr),y
    cmp #$0
    beq @done
    cmp #$20
    beq @printch
    
    cmp #10         ; Line Feed 
    bne @n1
    tya
    pha 
    txa
    pha
    inc cursor_row
    ldx cursor_row
    ldy cursor_col
    jsr syscall_setxy
    pla
    tax
    pla
    tay
    lda #10
    jmp @next_char
@n1:
    cmp #13             ; Carriage Return
    bne @n2
    tya
    pha
    txa
    pha
    inc cursor_row
    ldx cursor_row
    ldy #0
    jsr syscall_setxy
    pla
    tax
    pla
    tay
    lda #13
    jmp @next_char
@n2:
    cmp #64   ; @    
    bne @n3
    lda #0
    jmp @printch
    
@n3:        ; Check if ascii lower case and convert
            ; if (ch >= 97 && ch <= 122)
            ;    ch -= 97
    pha
    cld
    sbc #121
    bmi @n3_1
    beq @n3_1
    pla
    jmp @printch
    
@n3_1:
    pla
    pha
    clc
    sbc #96
    bmi @n3_2
    pla
    clc 
    sbc #95
    jmp @printch
@n3_2:
    pla
   
@printch:    
    jsr syscall_put_char
;    iny
;    sty cursor_col
@next_char:
    txa
    tay
    iny
    jmp @top
@done:
    tya         ; return bytes printed 
    rts

; ****************************************************************
; public void syscall_put_char(areg ch)
; Uses registers : a, y
; Description: Put the character at the current cursor location
; Params : ch - Character to put on screen
; Returns : None
; ****************************************************************
.proc syscall_put_char : near
    DISABLE_INTERRUPTS

    ldy cursor_col
	sta (scr_ptr),y             ;place character into screen memory
    
    lda color
	sta (scr_color_ptr),y     ;place character color into color map memory

    iny
    tya
    sta cursor_col
    ENABLE_INTERRUPTS 
    rts
.endproc

; ****************************************************************
; public areg syscall_get_kb_char(void)
; Uses registers : a,x
; Description: Get the next character from the keyboard buffer. 
; Params : none
; Returns : 0 if buffer empty 
; ****************************************************************
.proc syscall_get_kb_char : near
    lda kb_buffer
    tax 
    lda #$00
    sta kb_buffer
    txa
    rts
.endproc

; ****************************************************************
; public syscall_console_ctrl(areg cmd )
; Description : Console driver interface 
; params    cmd (CHARSET1, CHARSET2)
;           
; Returns : TRUE if successful
; ****************************************************************
.proc syscall_console_ctrl : near

    cmp #CONSOLE_CMD_CHARSET1
    bne :+
    ; TODO Fix by using a define
    lda #$15
    sta $D018
    jmp console_ctrl_done
:
    cmp #CONSOLE_CMD_CHARSET2
    bne :+
    ; TODO Fix by using a defines
    lda #$17
    sta $D018
    jmp console_ctrl_done

:   ; unknown command 
    lda #$00
    rts
console_ctrl_done:
    lda #$01
    rts
.endproc


; ****************************************************************
; public console_init()
; Description : Initialize the console driver 
; Returns : None
; ****************************************************************
.proc console_init : near 
    
    ldx #$00 
    jsr set_row_ptr

    lda #<_const_kb_no_shift_map
    sta kb_char_map_ptr 
    lda #>_const_kb_no_shift_map
    sta kb_char_map_ptr+1

initialize_keyboard:
    ; Write to CIA#1 data port A - setup up for keyboard scanning. 
    lda #%01111111
    sta cia1pra   
      
    ; Set CIA#1 Keyboard inuts - data direction register port B
	ldx #$00        ;set up keyboard inputs
	stx cia1ddrb    ;keyboard inputs
	
    ; Set CIA#1 keyboard outputs - data direction register port A
	ldx #$FF
    stx cia1ddra  

; Initialize the keyboard buffer
    lda #$0
    sta kb_buffer

  ; Initialize screen flags
    ; Set screen mode to 2 as initialized in vic II register $18 to $17
    ; Cursor off
    ; Blink Mode - off
    lda #SCR_MODE
    sta screen_flags
    
    ; Set default text color
    lda #1          ; White
    sta color

    jsr syscall_clear_screen

    rts
.endproc  
   
; ****************************************************************
; public void syscall_clear_screen(void)
; Uses registers: all
; Description : Clear the entire screen   
; Returns : None
; ****************************************************************
.proc syscall_clear_screen : near
        ldx  #scr_nlines-1
        
:       jsr syscall_clear_line
        dex
        bpl :-

        lda #$00
        sta cursor_row
        rts
 .endproc

; ****************************************************************
; public void syscall_clear_line (areg row)
; Uses register : a, y
; Description : Clear the entire line specified in param  
; param row  - Row to clear all text
; returns none
; ****************************************************************
.proc syscall_clear_line : near	
        ldy #scr_linelen-1
        jsr set_row_ptr

:       lda color
        sta (scr_color_ptr),y
        lda #$20        ;store a space
        sta (scr_ptr),y     ;to display
        dey
        bpl :-
        lda #$00
        sta cursor_col
        rts
.endproc

; ****************************************************************
; public void syscall_setxy(xreg x, yreg y)
; Uses registers : a, x,y
; Description : Set cursor position
; Params :  x =  row
;           y = column
; Returns: None	
; ****************************************************************
.proc syscall_setxy : near
    tya
    sta cursor_col
    txa
    jsr set_row_ptr    
    rts
 .endproc

; ****************************************************************
; local function set_row_ptr(a)
; Description: Setup the Row Pointer for both screen and color maps
; Param : A - Row to set both the screen and color pointers to
; Returns : None
; ****************************************************************
set_row_ptr:
    lda _const_scr_lo_matrix,x
	sta scr_ptr
	lda _const_scr_hi_matrix,x
	sta scr_ptr+1
    
    lda scr_ptr         
	sta scr_color_ptr
	lda scr_ptr+1
	and #$03
	ora #>VidColorRAMBase    
	sta scr_color_ptr+1
    
    stx cursor_row
	rts
; ****************************************************************
; public Function : KeyboardScan()
; Description: Check for a keypress and put character into the keyboard buffer.
; Params : None
; Returns : None
; TODO : Increase keyboard buffer, currently only one byte in size. 
; ****************************************************************
KeyboardScan:
      
; if (any_key != down) then 
;    Set character map pointer to no-shift table
;    return
    lda #$0
    sta kb_colmn
    
    ldx kb_rows
    cpx #$FF
    bne @kb_keydown

    lda #<_const_kb_no_shift_map
    sta kb_char_map_ptr 
    lda #>_const_kb_no_shift_map
    sta kb_char_map_ptr+1
    
    rts
;else

@kb_keydown:

    ; Start Scanning Keyboard Column 0
	lda #$FE     
    
    ; y index is the counter through the # of keyboard columns
    ldy #$0
    
    ; X is the index within the 64 character table
    ldx #$0

@kb_read_column_row:
	sta kb_colmn

; Save current column 
    pha

;   Wait until the keyboard stabilizes the input 
;   Some call this debounce. 
@kb_wait_stabilize:
    lda kb_rows
    cmp kb_rows
    bne @kb_wait_stabilize

    ; If no character pressed on this column then skip
    cmp #$FF 
    beq @kb_next_column
   
    pha     ; Save read from current keyboard row 
    
;   Check if reading the row for this column has any special characters
    and _const_kb_special_char_mask,y
    bne @kb_convert_char

; Pop out the value read from the keyboard
; XOR (SET) the special bits from the mask,
; Save new value read from the keyboard 
    pla     
    eor _const_kb_special_char_mask,y
    pha

;  Switch to the proper keyboard mapping table
;
; if index == column 1 or index == column 6 then 
;  use the shift kb mapping table
   cpy #$1
   beq @kb_use_shift_table
   cpy #$6
   bne @kb_map_ctrl_key
@kb_use_shift_table:
;  Set Shift table
   lda #<_const_kb_shift_map
   sta kb_char_map_ptr
   lda #>_const_kb_shift_map
   sta kb_char_map_ptr+1
   jmp @kb_convert_char

; else if index == column 7
;  use the control kb mapping table
@kb_map_ctrl_key:
   cpy #$7
   bne @kb_convert_char
; TODO set kb_char_map_ptr to the control table

@kb_convert_char:
    pla 
    
    ; If after the control character is masked off and it's all ff's  
    ; then no valid character, keep scanning.     
    cmp #$FF
    beq @kb_next_column
    
    sta kb_char_input
       
    ldy #0
    lda #$FE
@kb_convert_index_top:
    cmp kb_char_input
    beq @kb_convert_index_done
    
    sec
    rol a
    
    iny 
    cpy #8    
    bne @kb_convert_index_top
       
    pla
    jmp @kb_done
    
@kb_convert_index_done:
    tya
    sta kb_char_input
        
    txa
    clc
    adc kb_char_input
    tay
    
; Get the current keypress from the current selected char map pointer        
    lda (kb_char_map_ptr), y  
    
; Store keyboad characater into the buffer
    sta kb_buffer
    
    pla
    jmp @kb_done
   
@kb_next_column:
    ; Add 8 rows to x index
    txa
    clc
    adc #$8
    tax

    pla
    sec
    rol a

    iny
    cpy #$8
    bne @kb_read_column_row

@kb_done:
    
	rts

; ****************************************************************
; public Function : CursorOn(a)
; Description: Set if the cursor should be visible or not
; Params : a - 1 visible, 0 invisible
; Returns : None
; ****************************************************************
CursorOn:    
    cmp #$1
    bne @disable
    lda screen_flags
    ora #$1
    jmp @store
@disable: 
    lda screen_flags
    and #$FE
@store:   
    sta screen_flags
    rts
    
; ****************************************************************
; public Function : SetBlinkState(a)
; Description: Set if the the cursor should be blinked 
; Params : a - 1 on, 0 off
; Returns : None
; ****************************************************************
SetBlinkState:    
    cmp #$1
    bne @disable
    lda screen_flags
    ora #$2
    jmp @store
@disable:
    lda screen_flags
    and #$FD
@store:  
    sta screen_flags
    rts

; ****************************************************************
; public Function : A GetBlinkState(a)
; Description: Get the cursor blink configuration, enabled or disabled 
; Params : None
; Returns : a (1 = blink is enabled, 0 blink is disabled
; ****************************************************************
GetBlinkState:
    lda screen_flags
    and #$2
    bne @on
    lda #$0
    jmp @done
@on:
    lda #$1
@done:
    rts
