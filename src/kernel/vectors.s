; ******************************************************************************************************************
; File : vectors.s
;
; Description: Setup 65xx jump table   
;           $FFFA - Non Maskable Interrupts 
;           $FFFC - System Startup 
;           $FFFE -  System Interrupt 
; Segments:
;      VECTORS         - 65xx CPU Jump Table
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

	.segment "VECTORS"

	.word nmi           ; $FFFA Non Maskable Interrupts                    
	.word kernel_start  ; $FFFC CPU Reset Jump Vector 
	.word scheduler  	; $FFFE System Interrupt ISR Vector

