#ifndef LEOS_TYPES_H
#define LEOS_TYPES_H

#define EOF -1  // End of file

#define NULL ((void *)0)  // 空指针

#define EOS '\0'  // End of string

#define bool _Bool
#define true 1
#define false 0

#define _packed __attribute__((packed)) // 告诉编译器不要对结构体或类进行内存对齐

typedef unsigned int size_t;
typedef char int8;
typedef short int16;
typedef int int32;
typedef long long int64;

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;

#endif