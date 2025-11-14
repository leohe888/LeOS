#include <leos/leos.h>

int magic = LEOS_MAGIC;
char message[] = "hello leos!!!";

void kernel_init()
{
    char *video = (char *)0xb8000; // 文本模式显存地址
    for (int i = 0; i < sizeof(message); i++)
    {
        video[i * 2] = message[i];
    }
}