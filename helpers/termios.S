section .data
section .bss
	termios:
		c_iflag resd 1	; input mode flags		; REServe Doubleword
		c_oflag	resd 1	; output mode flags
		c_cflag	resd 1	; control mode flags
		c_lflag resd 1	; local mode flags
		c_line	resb 1	; line discipline
		c_cc	resb 19	; control characters

section .text
	global set_raw
	global set_normal

get_settings:
	mov  rax, 16             		; system call x86 for ioctl
	mov  rdi, 0              		; STDIN_FILENO
	mov  rsi, 0x5401         		; TCGETS
	mov  rdx, termios        		; request data
	syscall
	ret

set_settings:
	mov  rax, 16             ; system call x86 for ioctl
	mov  rdi, 0              ; STDIN_FILENO
	mov  rsi, 0x5402         ; TCSETS
	mov  rdx, termios        ; request data
	syscall
	ret

set_raw:
	call get_settings
	and byte [c_lflag], 0FDh  ; Clear ICANON to disable canonical mode
	call set_settings

	ret


set_normal:
	call get_settings
	or byte [c_lflag], 0FFh  ; Re- Set the previous settings
	call set_settings
	
	ret
