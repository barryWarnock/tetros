image.bin: rects.elf
	objcopy -O binary rects.elf image.bin

rects.o: rects.c
	gcc -c -g -Os -m32 -march=i686 -masm=intel -ffreestanding -Wall -Werror rects.c -o rects.o

rects.elf: rects.o link.ld
	ld -static -m elf_i386 -Tlink.ld -nostdlib --nmagic -o rects.elf rects.o

run: image.bin
	qemu-system-x86_64 -fda image.bin

debug: rects.elf image.bin
	gdb -x debug.gdb

