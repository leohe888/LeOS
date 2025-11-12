%.bin: %.asm
	nasm -f bin $< -o $@

master.img: boot.bin loader.bin
	@if [ ! -f master.img ]; then \
		bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat master.img; \
	fi
	dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc
	dd if=loader.bin of=master.img bs=512 count=4 seek=2 conv=notrunc

.PHONY: clean bochs usb
clean:
	rm -rf *.bin
	rm -rf *.img

bochs: master.img
	bochs -q

usb: boot.bin /dev/sdb
	sudo dd if=/dev/sdb of=tmp.bin bs=512 count=1 conv=notrunc
	cp tmp.bin boot.bin
	sudo rm tmp.bin
	dd if=boot.bin of=usb.img bs=446 count=1 conv=notrunc
	sudo dd if=usb.bin of=/dev/sdb bs=512 count=1 conv=notrunc
