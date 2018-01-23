image.bin: lines.asm
	nasm -f bin -o image.bin lines.asm

lines.elf: lines.asm
	nasm -f elf -o lines.elf lines.asm

run: image.bin
	qemu-system-x86_64 -fda image.bin

debug: lines.elf image.bin
	gdb -x debug.gdb
