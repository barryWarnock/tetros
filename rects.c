#define true 1
#define false 0

asm(".code16");
asm("call main");

void print_char(char c) {
    asm(
      "int 0x10"
      :
      : "a" (0x0E00|c)
      );
}

void print_str(const char* str) {
  while(*str) {
    print_char(*str);
    str++;
    }
}

extern void main() {
  print_str("ABC");
  while(true);
} 
