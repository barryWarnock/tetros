image.bin: tetris.asm
	nasm -f bin -o image.bin tetris.asm

tetris.elf: tetris.asm
	nasm -f elf -o tetris.elf tetris.asm

run: image.bin
	qemu-system-x86_64 -fda image.bin

debug: tetris.elf image.bin
	gdb -x debug.gdb
