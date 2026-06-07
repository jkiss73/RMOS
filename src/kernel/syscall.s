; ******************************************************************************************************************
; File : syscall.s
;
; Description: Application interface to kernel routines. This is a jump table and any changes should consider impacts
;           to existing applications. 
;
; First byte is reserved for the API version.
;      MJ    MN
;    [0000][0000]
;     MJ - 4 bits is for major revision [0-15]
;     MN - 4 bits is for minior revisions [0-15]  
;
; Segments:
;      SYSCALL       - System Call jump table
;
; Author(s) : John Kiss
;
; Copyright (c) 2024-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************

.import console_ctrl

.segment "SYSCALL"

api_version	.byte 0
api_build   .byte 0
	;signature
	.byte "RMOS"
