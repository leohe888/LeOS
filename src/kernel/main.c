#include <leos/leos.h>
#include <leos/types.h>
#include <leos/io.h>
#include <leos/string.h>
#include <leos/console.h>
#include <leos/printk.h>
#include <leos/assert.h>
#include <leos/debug.h>
#include <leos/global.h>
#include <leos/task.h>
#include <leos/interrupt.h>

void kernel_init()
{
    console_init();
    gdt_init();
    // task_init();
    interrupt_init();
    return;
};