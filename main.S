extern help
extern save_help

extern clear
extern increment_lines

extern open_file
extern write_file
extern close_file
extern delete_file

extern sys_exit

extern set_raw
; extern set_normal

extern read
extern write

extern delete

section .data
	is_saving db 0	; is the user saving the file? [ESC is pressed]
	file_fd db 1 	; the actual file handle
	backseq db 8, ' ', 8

section .bss
	buffer resb 1 							; REServe Byte of length 1, for buffer

	; REServe Byte of length 128 for text data
	temp_data resb 128
	temp_data_len resb 1

	; REServe Byte of length 64, for file_name
	file_name resb 64				
	file_name_len resb 1


section .text
	global _start

_start:
	start:
		mov byte [is_saving], 0
		call clear
		call help

		call set_raw					; set termios to raw mode, to read keystrokes
		call increment_lines


	; read the given value with 1 buffer
	; function definition
	read_data:
		; rsi keeps track of stdin within buffer with lea ("Load Effective Address")
		; Difference between MOV and LEA is, that MOV moves the actual value of a
		; given operand [mov x, y] y, into x, and LEA only moves the address of y
		; into x, merely pointing the address from x to y. [lea x, y] -> x => y (address) 
		; Probably compareable with the usage of "&", within zig, as it is
		; also a pointer.
		lea rsi, [rel buffer]

		mov rdx, 1					; 1 length buffer
		mov rdi, 0    				; unsigned int fd => 0 meaning stdin
		call read

		cmp rax, 0
		jl sys_exit

		cmp byte [buffer], 1Bh 	; compare the buffer against 'ESC'
		je init_saving			; initialize the save function

		cmp byte [buffer], 0Ah 	; compare the buffer against '\n'
		jne no_newline
		call increment_lines	; increment if \n is found
		no_newline:

		cmp byte [buffer], 7Fh 	; compare the buffer against 'DEL'
		jne raed_no_delete

		lea rdi, [rel temp_data]
		lea rsi, [rel temp_data_len]
		call delete
		jmp read_data

		raed_no_delete:
		movzx rcx, byte [temp_data_len]
		mov al, [buffer]
		lea rbx, [rel temp_data]
		mov byte [rbx + rcx], al

		inc byte [temp_data_len]
		jmp read_data				; recursively read all data




	read_file_name:
		lea rsi, [rel buffer]
		mov rdx, 1						; 1 length buffer
		mov rdi, 0    					; unsigned int fd => 0 meaning stdin
		call read

		cmp rax, 1          			; EOF or error?
		jne save

		cmp byte [buffer], 1Bh 	; 'ESC'
		je restart				; restart the programm from initial sequence

		cmp byte [buffer], 7Fh 	; 'DEL'
		jne no_delete

		lea rdi, [rel file_name]
		lea rsi, [rel file_name_len]
		call delete
		jmp read_file_name

		no_delete:
		cmp byte [buffer], 0Ah 	; compare the buffer against '\n'
		je save

		movzx rcx, byte [file_name_len]
		mov al, [buffer]				; AL is one byte (least sig. 8 bits of AX (last 16 bits of EAX))
		lea rbx, [rel file_name]
		mov byte [rbx + rcx], al

		inc byte [file_name_len]
		jmp read_file_name

	init_saving:
		call clear
		
		call save_help
		call increment_lines

		mov byte [is_saving], 1
		jmp read_file_name

	; cancel saving process
	restart:
		mov byte [is_saving], 0
		call clear
		call help
		call increment_lines

		lea rsi, [rel temp_data]
		mov rdx, [temp_data_len]
		mov rdi, 1
		call write_file				; call write_file

		jmp read_data

	save:
		; open the target file name
		mov rdi, file_name
		call open_file
		mov [file_fd], rax


		; transfer the data over
		lea rsi, [rel temp_data]
		movzx rdx, byte [temp_data_len]
		mov rdi, [file_fd]
		call write_file				; call write_file

		mov rdi, [file_fd]
		call close_file ; close file

		jmp sys_exit ; sys_exit programm
