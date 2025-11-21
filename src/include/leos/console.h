#ifndef LEOS_CONSOLE_H
#define LEO_S_CONSOLE_H

#include <leos/types.h>

void console_init();
void console_clear();
void console_write(char *buf, u32 count);

#endif