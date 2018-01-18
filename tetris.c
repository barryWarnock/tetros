void print_alphabet() {
  for (int i = 0; i < 26; i++) {
    char c = 'A'+i;
    
    asm (
		  "mov %[c], %%al;"
		  "mov $0x0E, %%ah;"
		  "int $0x10;"
		  :
		  : [c] "r" (c)
		  );
  }
}

extern void loader_main() {
  char c = 'A';
    
    asm (
		  "mov %[c], %%al;"
		  "mov $0x0E, %%ah;"
		  "int $0x10;"
		  :
		  : [c] "r" (c)
		  );
  print_alphabet();
}
