%include "exit.S"
%include "clear.S"

section .data
	welcome db "Welcome to Notepad, write your notes, and then save them, pretty quick.", 0xA
	welcome_len equ $ - welcome

	help db "If you need to save your notes, just press CTRL + S, and then hit enter.", 0xA, 0xA
	help_len equ $ - help

help:
	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, welcome				; the welcome text
	mov rdx, welcome_len			; the length of the text
	mov rax, 1						; system call x86 for write
	syscall							; calls interrupt

	cmp rax, 0
	je exit

	call increment_lines

	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, help					; the help text
	mov rdx, help_len				; the length of the text
	mov rax, 1						; system call x86 for write
	syscall							; calls interrupt

	cmp rax, 0
	je exit

	call increment_lines
	call increment_lines

