; ******************************************************************************************************************
; File : const.s
;
; Description: Kernel and memory constant values - Readonly. 
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

.segment "K_CONST"

_const_default_vic_registers
	.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 		    ; MIB[0-7] XY Position Registers (0 - 15)
	.byte 0                                         ; MSB of MIB X Position (16)
    .byte $1B                                       ; RC8, ECM, BMM, BLNK, RSEL, Y2,Y1,Y0 (17)
    .byte 0                                         ; Raster register (18)
    .byte 0                                         ; Light Pen X (19)
    .byte 0                                         ; Light Pen Y (20)
    .byte 0                                         ; MIB enable (21)
    .byte $08                                       ; MCM, CSEL, X2,X1,X0 (22)
    .byte 0                                         ; MIB Y-expand (23)
    .byte $17                                       ; Memory Pointers (24)
    .byte 0                                         ; Interrupt Register (25)
    .byte 0                                         ; Enable Interrupt (26)
    .byte 0                                         ; MIB Data Priority (27)
    .byte 0                                         ; MIB Multi-Color Select (28)
    .byte 0                                         ; MIB X-expand (29)
    .byte 0                                         ; MIB-MIB Collision (30)
    .byte 0                                         ; MIB-Data Collision (31)
    .byte 0                                         ; Exterior Color (32)
    .byte 0                                         ; Background #0 color (33)
    .byte 0                                         ; Background #1 color (34)
    .byte 0                                         ; Background #2 color (35)
    .byte 0                                         ; Background #3 color (36)
    .byte 0                                         ; MIB multi-color #0 (37)
    .byte 0                                         ; MIB multi-color #1 (38)
    .byte 0                                         ; MIB Color #0 (39)
    .byte 0                                         ; MIB Color #1 (40)
    .byte 0                                         ; MIB Color #2 (41)
    .byte 0                                         ; MIB Color #3 (42)
    .byte 0                                         ; MIB Color #4 (43)
    .byte 0                                         ; MIB Color #5 (44)
    .byte 0 	        		                    ; MIB Color #6 (45)
    .byte 0 	        		                    ; MIB Color #7 (46)

_const_scr_lo_matrix
	.byte <scr_line0
	.byte <scr_line1
	.byte <scr_line2
	.byte <scr_line3
	.byte <scr_line4
	.byte <scr_line5
	.byte <scr_line6
	.byte <scr_line7
	.byte <scr_line8
	.byte <scr_line9
	.byte <scr_line10
	.byte <scr_line11
	.byte <scr_line12
	.byte <scr_line13
	.byte <scr_line14
	.byte <scr_line15
	.byte <scr_line16
	.byte <scr_line17
	.byte <scr_line18
	.byte <scr_line19
	.byte <scr_line20
	.byte <scr_line21
	.byte <scr_line22
	.byte <scr_line23
	.byte <scr_line24
    
_const_scr_hi_matrix
	.byte >scr_line0
	.byte >scr_line1
	.byte >scr_line2
	.byte >scr_line3
	.byte >scr_line4
	.byte >scr_line5
	.byte >scr_line6
	.byte >scr_line7
	.byte >scr_line8
	.byte >scr_line9
	.byte >scr_line10
	.byte >scr_line11
	.byte >scr_line12
	.byte >scr_line13
	.byte >scr_line14
	.byte >scr_line15
	.byte >scr_line16
	.byte >scr_line17
	.byte >scr_line18
	.byte >scr_line19
	.byte >scr_line20
	.byte >scr_line21
	.byte >scr_line22
	.byte >scr_line23
	.byte >scr_line24

; Keyboard map mask
; AND this with the input recieved on a column, if non-zero then there is a special character
; example:  left or right shift Key, control key
_const_kb_special_char_mask
kb_sc_column_0  	.byte   $00     ;$FE
kb_sc_column_1  	.byte   $80     ;$FD    - BIT7 LEFT SHIFT 
kb_sc_column_2  	.byte   $00     ;$FB
kb_sc_column_3  	.byte   $00     ;$F7
kb_sc_column_4 		.byte   $00     ;$EF
kb_sc_column_5		.byte   $00     ;$DF
kb_sc_column_6		.byte   $10     ;$BF    - BIT4 RIGHT SHIFT
kb_sc_column_7		.byte   $04     ;$7F    - BIT2 CONTROL KEY

; Keyboard input to PET ASCII mapping
_const_kb_no_shift_map
kb_ns_column_0     .byte $14,$0d,$1d,$88,$85,$86,$87,$11    ; del, return, r. cursor, F7, F1, F3, F5, dn cursor
kb_ns_column_1     .byte $33,$17,$01,$34,$1a,$13,$05,$01    ; 3, w, a, 4, z, s, e, l. shift
kb_ns_column_2     .byte $35,$12,$04,$36,$03,$06,$14,$18    ; 5, r, d, 6, c, f, t, x 
kb_ns_column_3     .byte $37,$19,$07,$38,$02,$08,$15,$16    ; 7, y, g, 8, b, h, u, v
kb_ns_column_5     .byte $39,$09,$0a,$30,$0d,$0b,$0f,$0e    ; 9, i, j, 0, m, k, o, n
kb_ns_column_4     .byte $2b,$10,$0c,$2d,$2e,$3a,$40,$2c    ; +, p, l, -, ., :, @, comma
kb_ns_column_6     .byte $5c,$2a,$3b,$13,$01,$3d,$5e,$2f    ; pound, *, semicolon, clear/home, r. shift, =, up arrow, / 
kb_ns_column_7     .byte $31,$5f,$04,$32,$20,$02,$11,$03    ; 1, l. arrow, cntrl, 2, space, commadore, q, run/stop
kb_ns_column_last  .byte $00                                ; End of table 

_const_kb_shift_map
kb_s_column_0     .byte $14,$0d,$1d,$88,$85,$86,$87,$11     ; del, return, r. cursor, F7, F1, F3, F5, dn cursor
kb_s_column_1     .byte $33,$57,$41,$34,$5a,$53,$45,$01     ; 3, w, a, 4, z, s, e, l. shift
kb_s_column_2     .byte $35,$52,$44,$36,$43,$46,$54,$58     ; 5, r, d, 6, c, f, t, x 
kb_s_column_3     .byte $37,$59,$47,$38,$42,$48,$55,$56     ; 7, y, g, 8, b, h, u, v
kb_s_column_5     .byte $39,$49,$4a,$30,$4d,$4b,$4f,$4e     ; 9, i, j, 0, m, k, o, n
kb_s_column_4     .byte $2b,$50,$4c,$2d,$2e,$3a,$40,$2c     ; +, p, l, -, ., :, @, comma
kb_s_column_6     .byte $5c,$2a,$3b,$13,$01,$3d,$5e,$2f     ; pound, *, semicolon, clear/home, r. shift, =, up arrow, / 
kb_s_column_7     .byte $31,$5f,$04,$32,$20,$02,$51,$03     ; 1, l. arrow, cntrl, 2, space, commadore, q, run/stop
kb_s_column_last  .byte $00                                 ; End of table 


.if .defined(VER_MAJOR) && .defined(VER_MIN) && .defined(VER_BUILD)
kernel_msg 			.asciiz  .sprintf("retro-mod c64 bootstrap kernel v%d.%d.%d\n\n",VER_MAJOR, VER_MIN, VER_BUILD)
.else
kernel_msg 			.asciiz  .sprintf("retro-mod c64 bootstrap kernel\n\n")
.endif

starting_msg 		.asciiz "kernel init "
ready_msg 			.asciiz "\ngo time!\n"

input_prompt		.asciiz "\nRMOS :>"



