add-symbol-file tetris.elf 0x1000
target remote | qemu-system-x86_64 -gdb stdio -S -fda image.bin