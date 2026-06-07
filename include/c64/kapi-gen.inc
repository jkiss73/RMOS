; **************************************************************************************** 
; RMOS Listing to Define file generation v0.1
; RMOS OS v0.1.0
; RMOS kernel v0.2.0
; Generating ../../include/c64/kapi-gen.inc
; from : ../../build/c64/kernel.lst
; using template :../../include/kapi-common.tpl
; June 07, 2026, 05:10:31 PM
; ****************************************************************************************
.define SYSCALL_PUTCHAR        $E47A
.define SYSCALL_GETCHAR        $E48C
.define SYSCALL_CLRSCR        $E4E4
.define SYSCALL_SETPOSXY        $E509
.define SYSCALL_CLRLINE        $E4F2
.define SYSCALL_CONSOLE_CTRL        $E497
.define SYSCALL_MUTEX_ALLOCATE        $E04F
.define SYSCALL_MUTEX_FREE        $E06B
.define SYSCALL_MUTEX_LOCK        $E087
.define SYSCALL_MUTEX_IS_LOCKED        $E0AE
.define SYSCALL_MUTEX_UNLOCK        $E0C1
.define SYSCALL_SCHED_TCB_OFFSET        $E0E2
.define SYSCALL_SCHED_ALLOCATE        $E0F2
.define SYSCALL_SCHED_FREE        $E11A
.define SYSCALL_SCHED_USER_CS        $E13F
.define SYSCALL_SYSTEM_CONTROL        $E166
.define TASK_CTRL_LIST_ADDR        $001E
.define CURRENT_TASK_ID        $001C
