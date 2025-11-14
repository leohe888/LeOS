$(BUILD)BUILD := ../build
SRC := .

ENTRYPOINT := 0x10000

CFLAGS := -m32	# 生成 32 位代码（x86）
CFLAGS += -fno-builtin 	# 禁止 GCC 使用内建函数
CFLAGS += -nostdinc		# 不使用默认标准头文件路径
CFLAGS += -fno-pic		# 不生成位置无关代码
CFLAGS += -fno-pie		# 不生成位置无关可执行文件
CFLAGS += -nostdlib		# 不链接标准库
CFLAGS += -fno-stack-protector	# 禁用栈保护
CFLAGS := $(strip $(CFLAGS))


DEBUG := -g
INCLUDE := -I$(SRC)/include

$(BUILD)/boot/%.bin: $(SRC)/boot/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f bin $< -o $@

$(BUILD)/kernel/%.o: $(SRC)/kernel/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f elf32 $(DEBUG) $< -o $@

$(BUILD)/kernel/%.o: $(SRC)/kernel/%.c
	$(shell mkdir -p $(dir $@))
	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o $@

$(BUILD)/kernel.bin: $(BUILD)/kernel/start.o \
	$(BUILD)/kernel/main.o

	$(shell mkdir -p $(dir $@))
	ld -m elf_i386 -static $^ -o $@ -Ttext ${ENTRYPOINT}

$(BUILD)/system.bin: $(BUILD)/kernel.bin
	objcopy -O binary $< $@

$(BUILD)/system.map: $(BUILD)/kernel.bin
	nm $< | sort > $@

$(BUILD)/master.img: $(BUILD)/boot/boot.bin \
	$(BUILD)/boot/loader.bin \
	$(BUILD)/system.bin \
	$(BUILD)/system.map \
	
	@if [ ! -f $(BUILD)/master.img ]; then \
		bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $@; \
	fi
	dd if=$(BUILD)/boot/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/boot/loader.bin of=$@ bs=512 count=4 seek=2 conv=notrunc
	dd if=$(BUILD)/system.bin of=$@ bs=512 count=200 seek=10 conv=notrunc

test: $(BUILD)/master.img

.PHONY: clean bochs usb
clean:
	rm -rf $(BUILD)

bochs: $(BUILD)/master.img
	bochs -q
