CFLAGS := -m32	# 生成 32 位代码（x86）
CFLAGS += -Qn	# 去掉 GCC 版本信息
# CFLAGS += -fno-builtin 	# 禁止 GCC 使用内建函数
# CFLAGS += -nostdinc		# 不使用默认标准头文件路径
CFLAGS += -fno-pic		# 不生成位置无关代码
# CFLAGS += -fno-pie		# 不生成位置无关可执行文件
# CFLAGS += -nostdlib		# 不链接标准库
# CFLAGS += -fno-stack-protector	# 禁用栈保护
# CFLAGS += -fomit-frame-pointer	# 不需要帧指针
CFLAGS += -mpreferred-stack-boundary=2	# 不需要栈对齐
CFLAGS += -fno-asynchronous-unwind-tables	# 不需要 CFI 信息
CFLAGS := $(strip $(CFLAGS))

.PHONY: hello.s
hello.s: hello.c
	gcc $(CFLAGS) -S -o $@ $<

.PHONY: params.s
params.s: params.c
	gcc $(CFLAGS) -S -o $@ $<