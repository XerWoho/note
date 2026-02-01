section .data
section .bss

exit:
	mov rax, 60 					; exit syscall
	mov rdi, 0						; return value (0 >= no error)
	syscall
