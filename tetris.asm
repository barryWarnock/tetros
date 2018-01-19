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

	push 0x0A
	push 0x0A
	push 0x04
	call put_pixel

	cli
	jmp $

	
clearscreen:
	prologue

	mov ah, 0x00 		;set graphics mode
	mov al, 0x13		;vga 320x200
	int 0x10

	epilogue

;;; three ops, x, y, colour
put_pixel:
	prologue

	mov cx, [bp+4]		;x
	mov dx, [bp+8]		;y
	mov ax, [bp+12]		;colour

	mov ah, 0x0C		;put pixel
	mov bh, 0x00		;page
	int 0x10		;bios graphics int

	epilogue

movecursor:
	prologue

	mov dx, [bp+4]      ;; get the argument from the stack. |bp| = 2, |arg| = 2
	mov ah, 0x02        ;; set cursor position
	mov bh, 0x00        ;; page 0 - doesn't matter, we're not using double-buffering
	int 0x10

	epilogue

print:
	prologue

	;; grab pointer to message
	mov si, [bp+4]
	;; page number 0
	mov bh, 0x00
	;; foreground colour, irrelevant in text mode
	mov bl, 0x00
	;; print char to tty
	mov ah, 0x0E

	.char:
	;; get the current char
	mov al, [si]
	;; inc pointer
	add si, 1
	or al, 0
	;; if we hit a null char we're done
	je .return
	int 0x10
	;; loop
	jmp .char

	.return:
	epilogue

msg:	db "Hello World!", 0

times 510-($-$$) db 0
dw 0xAA55

