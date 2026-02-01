%include "write.S"
%include "exit.S"

section .data
	fd dq 1


open_file:
	cmp byte [fd], 1
	jne skip
	ret

	skip:

	; the filename should be set
	; to rdi before calling the function
	; mov rdi, file_name
	mov rsi, 0102o				; O_CREAT, man open
	mov rdx, 0664o				; umode_t
	mov rax, 2 					; system call x86 for open file
	syscall

	cmp rax, 0
	je exit

	mov [fd], rax				; store the rax return value to fd byte
	ret


write_file:
	; rsi and rdx should be defined before calling write_file
	
	; mov rsi, data				; the buffer
	; mov rdx, 1					; number of bytes
	mov rdi, [fd]			 	; set the file handle to rdi
	call write

	cmp rax, 0
	je exit


close_file:	
	mov rax, 3							; system call x86 for close
	syscall

	cmp rax, 0
	je exit