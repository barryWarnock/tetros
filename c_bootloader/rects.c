#define true 1
#define false 0
#define SCANLINE_WIDTH 0x140
#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200

//set up stack
asm(
    "mov ax, 0x7E0;"
    "mov ss, ax;"

    //8k of stack
    "mov sp, 0x2000;"
    );

asm("call main");

/* void print_char(char c) { */
/*     asm( */
/*       "int 0x10" */
/*       : */
/*       : "a" (0x0E00|c) */
/*       ); */
/*     return; */
/* } */

/* void print_str(char* str) { */
/*   while(*str) { */
/*     print_char(*str); */
/*     str++; */
/*     } */
/*   return; */
/* } */

void clear_screen() {
  //set graphics mode to 0x13
  asm("int 0x10" : : "a" (0x13));
}

int get_ticks() {
  int cx, dx;
  asm volatile(
	       "int 0x1A;"
	       : "=r" (cx), "=r" (dx)
	       : "a" (0)
	       );
  return (cx << 16) | dx;
}

void put_pixel(int x, int y, char colour) {
  int pixel = y * SCANLINE_WIDTH;
  pixel += x;
  asm(
      "push ds;"
      "pusha;"
      "mov dx, 0xA000;"
      "mov ds, dx;"
      "mov BYTE PTR [ebx], al;"
      "popa;"
      "pop ds;"
      :
      : "b" (pixel), "a" (colour)
      );
  return;
}

void draw_line(int x1, int y1, int x2, int y2, char colour) {
  while (true) {
  put_pixel(x1, y1, colour);

  if (x1 == x2 && y1 == y2) break;

  if (x1 < x2) x1++;
  else if (x1 > x2) x1--;

  if (y1 < y2) y1++;
  else if (y1 > y2) y1--;
  } 

  return;
}

void draw_rect(int x1, int y1, int x2, int y2, char colour) {
  while (true) {
    draw_line(x1, y1, x2, y1, colour);

    if (y1 == y2) break;

    if (y1 < y2) y1++;
    else if (y1 > y2) y1--;
  }
  return;
}

void fun_rects() {
  int width = SCREEN_WIDTH;
  int height = SCREEN_HEIGHT;
  unsigned char c = 32;
  int x, y;
  int startTicks;
  const char ticksPerRect = 0;
  
  while(true) {
    startTicks = get_ticks();
    if (width == 0 ||  height == 0) {
      width = SCREEN_WIDTH;  
      height = SCREEN_HEIGHT;
    }
    if (c > 54) c = 32;
    x = (SCREEN_WIDTH-width)/2;
    y = (SCREEN_HEIGHT-height)/2;
    draw_rect(x, y, x+width-1, y+height-1, c++);
    width--;
    height--;
    
    while(get_ticks()-startTicks < ticksPerRect) {};
  }
}

extern void main() {
  clear_screen();
  fun_rects();
  while(true);
} 
