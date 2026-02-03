section .data

section .text
	global sys_exit

sys_exit:
	mov rax, 60 					; sys_exit syscall
	mov rdi, 0						; return value (0 >= no error)
	syscall
	ret
