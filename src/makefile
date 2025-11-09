boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

master.img: boot.bin
	@if [ ! -f master.img ]; then \
		bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat master.img; \
	fi
	dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc

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
