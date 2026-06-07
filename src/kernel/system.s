; ******************************************************************************************************************
; File : system.s
;
; Description: Setup 6510 jump table   
;
; Segments:
;      SYSTEM         - Kernel system level functions
;
; Author(s) : John Kiss
;
; Copyright (c) 2025-Present, John Kiss All rights reserved.
; This source code is licensed under the BSD-style license found in the LICENSE file 
; in the root directory of this source tree.
; ******************************************************************************************************************
;  TODO
;       * Mutex
;       * Device Manager
;       * Hard Timers
;       * Date and Time
;       * Soft Timers
;       * Event Manager 

.segment "SYSTEM"

get_next_device_number:
    rts

OpenDevice:
    rts
    
CloseDevice
    rts
    


