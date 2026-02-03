extern increment_lines
extern sys_exit
extern write

section .data
	welcome_text db "Welcome to Notepad, write your notes, and then save them, pretty quick.", 0xA
	welcome_text_len equ $ - welcome_text

	help_text db "If you need to save your notes, just press ESC, and follow the instructions.", 0xA, 0xA
	help_text_len equ $ - help_text

	save_help_text db "Enter the file name you want, and then hit enter to save.", 0xA, 0xA
	save_help_text_len equ $ - save_help_text


section .text
	global help
	global save_help

help:
	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, welcome_text				; the welcome text
	mov rdx, welcome_text_len			; the length of the text
	call write

	call increment_lines

	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, help_text					; the help text
	mov rdx, help_text_len				; the length of the text
	call write

	call increment_lines
	call increment_lines

	ret

save_help:
	mov rdi, 1    					; unsigned int fd => 1 meaning stdout
	mov rsi, save_help_text				; the welcome text
	mov rdx, save_help_text_len			; the length of the text
	call write

	call increment_lines
	call increment_lines
	ret
