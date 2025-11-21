#ifndef LEOS_STDIO_H
#define LEOS_STDIO_H

#include <leos/stdarg.h>

int vsprintf(char *buf, const char *fmt, va_list args);
int sprintf(char *buf, const char *fmt, ...);

#endif