#include <leos/leos.h>
#include <leos/types.h>
#include <leos/io.h>
#include <leos/string.h>
#include <leos/console.h>
#include <leos/printk.h>
#include <leos/assert.h>
#include <leos/debug.h>

void kernel_init()
{
    console_init();
    
    BMB;

    DEBUGK("debug leos!!!\n");

    return 0;
};