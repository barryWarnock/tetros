add-symbol-file rects.elf 0x7C00
target remote | qemu-system-x86_64 -gdb stdio -S -fda image.bin
