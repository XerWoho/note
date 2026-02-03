extern sys_exit

section .text
	global write

write:
	; rsi, rdi, and rdx should set before
	; calling the function
	; mov rsi			; the buffer
	; mov rdx			; buffer length
	; mov rdi, 1    	; fd, (1 is stdout, else file handler)

	mov rax, 1			; system call x86 for write
	syscall				; calls interrupt

	cmp rax, 0
	jl sys_exit
	
	ret

