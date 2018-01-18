image.bin: tetris.bin load_tetris.bin
	cat load_tetris.bin tetris.bin > image.bin

load_tetris.bin: load_tetris.asm
	nasm load_tetris.asm -o load_tetris.bin

launch_tetris.o: launch_tetris.asm
	nasm -f elf32 launch_tetris.asm -o launch_tetris.o

tetris.o: tetris.c
	gcc -O0 -g -fno-plt -fno-pic -ffreestanding -m32 -c tetris.c -o tetris.o

tetris.elf: tetris.o launch_tetris.o
	ld -o tetris.elf -m elf_i386 -Ttext 0x1000 launch_tetris.o tetris.o 

tetris.bin: tetris.elf
	objcopy -O binary tetris.elf tetris.bin

run: image.bin
	qemu-system-x86_64 -fda image.bin

debug: image.bin
	qemu-system-x86_64 -s -S -fda image.bin & gdb -s tetris.elf -ex "target remote localhost:1234"
