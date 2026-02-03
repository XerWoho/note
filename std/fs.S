extern   write
extern   sys_exit

section  .text
         global      open_file
         global      write_file
         global      close_file
         global      delete_file

open_file:
	; the filename should be set
	; to rdi before calling the function
	; mov rdi, file_name
         mov         rsi, 0102o     ; O_CREAT, man open
         mov         rdx, 0664o     ; umode_t
         mov         rax, 2         ; system call x86 for open file
         syscall

         cmp         rax, 0
         jl          sys_exit
         ret


write_file:
	; rsi, rdi and rdx should be defined before calling write_file

	; mov rsi, data					; the buffer
	; mov rdx, 1					; number of bytes
	; mov rdi, 1					; the file handle
         call        write

         cmp         rax, 0
         jl          sys_exit
         ret


close_file:
	; rdi should be defined before calling close_file
	; mov rdi, 1						; the file handle
         mov         rax, 3         ; system call x86 for close
         syscall

         cmp         rax, 0
         jl          sys_exit
         ret

delete_file:
	; mov rdi, 1						; the file path
         mov         rax, 87        ; system call x86 for close
         syscall

         cmp         rax, 0
         jl          sys_exit

         ret
