/* **************************************************************************************** 
RMOS Listing to Define file generation v0.1
RMOS OS v0.1.0
RMOS kernel v0.2.0
Generating ../../include/c64/kapi-gen.h
from : ../../build/c64/kernel.lst
using template : ../../include/kapi-common.tpl
June 07, 2026, 05:10:31 PM
**************************************************************************************** */
#define SYSCALL_PUTCHAR        0xE47A
#define SYSCALL_GETCHAR        0xE48C
#define SYSCALL_CLRSCR        0xE4E4
#define SYSCALL_SETPOSXY        0xE509
#define SYSCALL_CLRLINE        0xE4F2
#define SYSCALL_CONSOLE_CTRL        0xE497
#define SYSCALL_MUTEX_ALLOCATE        0xE04F
#define SYSCALL_MUTEX_FREE        0xE06B
#define SYSCALL_MUTEX_LOCK        0xE087
#define SYSCALL_MUTEX_IS_LOCKED        0xE0AE
#define SYSCALL_MUTEX_UNLOCK        0xE0C1
#define SYSCALL_SCHED_TCB_OFFSET        0xE0E2
#define SYSCALL_SCHED_ALLOCATE        0xE0F2
#define SYSCALL_SCHED_FREE        0xE11A
#define SYSCALL_SCHED_USER_CS        0xE13F
#define SYSCALL_SYSTEM_CONTROL        0xE166
#define TASK_CTRL_LIST_ADDR        0x001E
#define CURRENT_TASK_ID        0x001C
