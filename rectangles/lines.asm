;;; macros
;;; ----------------------------------------------------------------------
	;; enter function
%macro prologue 0
	push bp
	mov bp, sp
	pusha
%endmacro
	;; return from function
%macro epilogue 0
	popa
	mov sp, bp
	pop bp
	ret	
%endmacro
%macro mDrawPixel 3	;x, y, c
	push %1 
	push %2
	push %3
	call put_pixel
	add sp, 6
%endmacro
%macro mDrawLine 5	;x1, y1, x2, y2, c
	push %1 
	push %2
	push %3
	push %4
	push %5
	call draw_line
	add sp, 10
%endmacro
%macro mDrawRect 5		;x1, y1, x2, y2, c
	push %1 
	push %2
	push %3
	push %4
	push %5
	call draw_rect
	add sp, 10
%endmacro
%macro mDrawPixelVRAM 3	;x, y, c
	push %1 
	push %2
	push %3
	call put_pixel_vram
	add sp, 6
%endmacro
	
;;; set up stack and data sections
;;; ----------------------------------------------------------------------
	bits 16
	
	mov ax, 0x7C0
	mov ds, ax

	mov ax, 0x7E0
	mov ss, ax

	;; 8k of stack
	mov sp, 0x2000

;;; start program
;;; ----------------------------------------------------------------------
	call clearscreen
	mDrawRect 0x0, 0x0, 0xF0, 0xF0, 0x05

	;; don't accept interupts and loop forever (halting would hang qemu)
	cli
	jmp $

	
;;; set graphics mode which clears the screen
clearscreen:
	prologue

	mov ah, 0x00 		;set graphics mode
	mov al, 0x13		;vga 320x200
	int 0x10

	epilogue


;;; no longer used, bios interupts are much slower than accessing vram directly
put_pixel:			;x, y, colour
	prologue

	mov ax, [bp+4]		;colour
	mov dx, [bp+6]		;y
	mov cx, [bp+8]		;x
	
	mov ah, 0x0C		;put pixel
	mov bh, 0x00		;page
	int 0x10		;bios graphics int

	epilogue


draw_line:			;x1, y1, x2, y2, colour
	prologue

	;; colour [bp+4]
	;; y2 [bp+6]
	;; x2 [bp+8]
	;; y1 [bp+10]
	;; x1 [bp+12]

	.startloop:

	;; x, y, c
	mDrawPixelVRAM WORD [bp+12], WORD [bp+10], WORD [bp+4]

	mov ax, [bp+8]
	cmp [bp+12], ax 	;x1 = x2?
	jne .notdone
	mov ax, [bp+6]
	cmp [bp+10], ax	 	;y1 = y2?
	je .return

	.notdone:

	.changex:
	mov ax, [bp+8]
	cmp [bp+12], ax 	;cmp x1, x2
	je .changey
	jg .decx
	jl .incx
	
	.incx:			;increment x
	inc WORD [bp+12]
	jmp .changey

	.decx:			;decrement x
	dec WORD [bp+12]

	.changey:
	mov ax, [bp+6]
	cmp [bp+10], ax	;cmp y1, y2
	je .gotop
	jg .decy
	jl .incy
	
	.incy:			;increment y
	inc WORD [bp+10]
	jmp .gotop

	.decy:			;decrement y
	dec WORD [bp+10]

	.gotop:
	jmp .startloop
	
	.return:
	epilogue

draw_rect:			;x1, y1, x2, y2, colour
	prologue
	
	;; [bp+4] colour
	;; [bp+6] y2
	;; [bp+8] x2
	;; [bp+10] y1
	;; [bp+12] x1

	.start:
	;; x1, y1, x2, y1, c
	mDrawLine WORD [bp+12], WORD [bp+10], WORD [bp+8], WORD [bp+10], WORD [bp+4]

	mov ax, [bp+6]
	cmp [bp+10], ax
	je .return
	jl .incy
	jg .decy
	
	.incy:			;increment y
	inc WORD [bp+10]
	jmp .start

	.decy:			;decrement y
	dec WORD [bp+10]
	jmp .start

	.return:
	epilogue

put_pixel_vram:			;x, y, c
	prologue

	;; [bp+4] c
	;; [bp+6] y
	;; [bp+8] x

	;; width of a scanline = 0x140
	mov eax, 0x140
	movzx edx, WORD [bp+6]
	mul edx
	add eax, [bp+8]
		
	push ds
	mov dx, 0xA000
	mov ds, dx
	mov dl, [bp+4]
	mov BYTE [ds:eax], dl
	pop ds

	epilogue

times 510-($-$$) db 0
dw 0xAA55

