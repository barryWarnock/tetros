	bits 16
	
	mov ax, 0x7C0
	mov ds, ax

	mov ax, 0x7E0
	mov ss, ax

	;; 8k of stack
	mov sp, 0x2000

	call clearscreen

	push 0x0000
	call movecursor
	add sp, 2

	push msg
	call print
	add sp, 2

	cli
	hlt

clearscreen:
	push bp
	mov bp, sp
	pusha

	mov ah, 0x07        ;; tells BIOS to scroll down window
	mov al, 0x00        ;; clear entire window
	mov bh, 0x07        ;; white on black
	mov cx, 0x00        ;; specifies top left of screen as (0,0)
	mov dh, 0x18        ;; 18h = 24 rows of chars
	mov dl, 0x4f        ;; 4fh = 79 cols of chars
	int 0x10            ;; calls video interrupt

	popa
	mov sp, bp
	pop bp
	ret

movecursor:
	push bp
	mov bp, sp
	pusha

	mov dx, [bp+4]      ;; get the argument from the stack. |bp| = 2, |arg| = 2
	mov ah, 0x02        ;; set cursor position
	mov bh, 0x00        ;; page 0 - doesn't matter, we're not using double-buffering
	int 0x10

	popa
	mov sp, bp
	pop bp
	ret

print:
	push bp
	mov bp, sp
	pusha

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
	popa
	mov sp, bp
	pop bp
	ret

msg:	db "Hello World!", 0

times 510-($-$$) db 0
dw 0xAA55
