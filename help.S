%include "exit.S"
%include "clear.S"

section .data
	welcome_text db "Welcome to Notepad, write your notes, and then save them, pretty quick.", 0xA
	welcome_text_len equ $ - welcome_text

	help_text db "If you need to save your notes, just press CTRL + S, and then hit enter.", 0xA, 0xA
	help_text_len equ $ - help_text

help:
	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, welcome_text				; the welcome text
	mov rdx, welcome_text_len			; the length of the text
	mov rax, 1						; system call x86 for write
	syscall							; calls interrupt

	cmp rax, 0
	je exit

	call increment_lines

	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, help_text					; the help text
	mov rdx, help_text_len				; the length of the text
	mov rax, 1						; system call x86 for write
	syscall							; calls interrupt

	cmp rax, 0
	je exit

	call increment_lines
	call increment_lines

