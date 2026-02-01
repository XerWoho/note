extern write
extern sys_exit

section .data
	fd dq 1


global open_file
global write_file
global close_file

open_file:
	cmp byte [rel fd], 1
	jne open_file_skip
	ret

	open_file_skip:

	; the filename should be set
	; to rdi before calling the function
	; mov rdi, file_name
	mov rsi, 0102o				; O_CREAT, man open
	mov rdx, 0664o				; umode_t
	mov rax, 2 					; system call x86 for open file
	syscall

	cmp rax, 0
	je sys_exit

	mov [rel fd], rax				; store the rax return value to fd byte
	ret


write_file:
	; rsi and rdx should be defined before calling write_file

	; mov rsi, data				; the buffer
	; mov rdx, 1					; number of bytes
	lea rdi, [rel fd]			 	; set the file handle to rdi
	call write

	cmp rax, 0
	je sys_exit


close_file:	
	mov rax, 3							; system call x86 for close
	syscall

	cmp rax, 0
	je sys_exit