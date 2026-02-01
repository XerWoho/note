extern sys_exit
extern help

extern clear
extern increment_lines
extern open_file
extern write_file
extern close_file

section .data
	file_name db 'undefined.txt', 0

section .bss
	data resb 1 					; REServe Byte of length 1, for "variable" data

section .text
	global _start

_start:
	call help

	mov rdi, file_name
	call open_file


	; read the given value with 1 buffer
	; function definition
	read:
		mov rdi, 0    				; unsigned int fd => 1 meaning stdin
		lea rsi, [rel data]				; rsi keeps track of stdin within buffer

		mov rdx, 1					; 1 length buffer
		mov rax, 0					; system call x86 for read
		syscall						; calls interrupt

		cmp byte [rel data], 13h ; compare the buffer against 'CTRL + S'
		je finish ; if its equal, finish

		cmp byte [rel data], 0Ah ; compare the buffer against '\n'
		jne read_skip
		call increment_lines

		read_skip:
		jmp write_file				; write file recursively

	finish:	
		; increment twice because of CTRL + S, and newline before
		; closing the file
		call increment_lines
		call increment_lines
		call clear ; clear lines

		call close_file ; close file
		jmp sys_exit ; exit programm



