extern sys_exit

section .data
	lines dq 3

	cline db `\33[0J`, 0
	cline_len equ $ - cline

	mup db `\33[1A`, 0
	mup_len equ $ - mup


global increment_lines
global clear


increment_lines:
	inc byte [rel lines]
	ret


move_up:
	mov rsi, mup				; the buffer
	mov rdx, mup_len			; number of bytes

	mov rdi, 1				 				; 1 being stdout
	mov rax, 1								; system call x86 for write
	syscall									; calls interrupt

	cmp rax, 0
	jl sys_exit

	ret


clear_line:
	mov rsi, cline				; the buffer
	mov rdx, cline_len			; number of bytes

	mov rdi, 1				 	; 1 being stdout
	mov rax, 1					; system call x86 for write
	syscall						; calls interrupt

	cmp rax, 0
	jl sys_exit

	ret

clear:
	dec byte [rel lines]
	call clear_line

	cmp byte [rel lines], 0
	jne clear_skip
	ret

	clear_skip:
	call move_up
	jmp clear