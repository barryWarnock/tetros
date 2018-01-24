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

void print_str(char* str) {
  while(*str) {
    print_char(*str);
    str++;
    }
}

//TODO
void clear_screen() {}

//TODO
void put_pixel(int x, int y, char colour) {}

//TODO
void draw_line(int x1, int y1, int x2, int y2, char colour) {}

//TODO
void draw_rect(int x1, int y1, int x2, int y2, char colour) {}

extern void main() {
  char* s = "Hello World!";
  print_str(s);
  while(true);
} 
