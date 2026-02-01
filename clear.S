%include "exit.S"

section .data
	lines dq 3

	cline db `\33[0J`, 0
	cline_len equ $ - cline

	mup db `\33[1A`, 0
	mup_len equ $ - mup

increment_lines:
	inc byte [lines]
	ret


move_up:
	mov rsi, mup				; the buffer
	mov rdx, mup_len			; number of bytes

	mov rdi, 1				 				; 1 being stdout
	mov rax, 1								; system call x86 for write
	syscall									; calls interrupt

	cmp rax, 0
	jl exit

	ret


clear_line:
	mov rsi, cline				; the buffer
	mov rdx, cline_len			; number of bytes

	mov rdi, 1				 	; 1 being stdout
	mov rax, 1					; system call x86 for write
	syscall						; calls interrupt

	cmp rax, 0
	jl exit

	ret

clear:
	dec byte [lines]
	call clear_line

	cmp byte [lines], 0
	jne clear_skip
	ret

	clear_skip:
	call move_up
	jmp clear