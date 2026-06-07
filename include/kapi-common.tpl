SYSCALL_PUTCHAR             .syscall_put_char
SYSCALL_GETCHAR             .syscall_get_kb_char
SYSCALL_CLRSCR              .syscall_clear_screen
SYSCALL_SETPOSXY            .syscall_setxy
SYSCALL_CLRLINE             .syscall_clear_line
SYSCALL_CONSOLE_CTRL        .syscall_console_ctrl

SYSCALL_MUTEX_ALLOCATE      .syscall_mutex_allocate
SYSCALL_MUTEX_FREE          .syscall_mutex_free
SYSCALL_MUTEX_LOCK          .syscall_mutex_lock
SYSCALL_MUTEX_IS_LOCKED     .syscall_mutex_is_locked
SYSCALL_MUTEX_UNLOCK        .syscall_mutex_unlock

SYSCALL_SCHED_TCB_OFFSET    .syscall_sched_calc_tcb_offset 
SYSCALL_SCHED_ALLOCATE      .syscall_sched_tcb_allocate
SYSCALL_SCHED_FREE          .syscall_sched_tcb_free
SYSCALL_SCHED_USER_CS       .syscall_sched_task_context_switch

SYSCALL_SYSTEM_CONTROL      .syscall_system_control

TASK_CTRL_LIST_ADDR        .zpTaskControlList
CURRENT_TASK_ID             .current_task_idx
