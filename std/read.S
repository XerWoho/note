extern sys_exit

section .text
	global read

read:
	; rsi, rdi, and rdx should set before
	; calling the function
	; mov rsi			; the buffer
	; mov rdx			; buffer length
	; mov rdi, 0    	; fd, (0 is stdin, else file handler)

	mov rax, 0			; system call x86 for read
	syscall				; calls interrupt

	cmp rax, 0
	jl sys_exit
	
	ret
