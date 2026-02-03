extern   write
extern   read

extern   delete

extern   sys_exit

section  .bss
         buffer              resb 1

section  .text
         global              stdin


stdin:
	; rsi keeps track of stdin within buffer with lea ("Load Effective Address")
	; Difference between MOV and LEA is, that MOV moves the actual value of a
	; given operand [mov x, y] y, into x, and LEA only moves the address of y
	; into x, merely pointing the address from x to y. [lea x, y] -> x => y (address)
	; Probably compareable with the usage of "&", within zig, as it is
	; also a pointer.
	;
	; r9 includes the main buffer in which data should be stored
	; r10 includes the length of the main buffer
	; rsi, includes the small buffer
         lea                 rsi, [rel buffer]

         mov                 rdx, 1               ; 1 length buffer
         mov                 rdi, 0               ; unsigned int fd => 0 meaning stdin
         call                read

         cmp                 rax, 0
         jl                  sys_exit

         mov                 al, [rsi]

         cmp                 al, 7Fh              ; compare the buffer against 'DEL'
         jne                 stdin_no_del
         call                delete
         mov                 rax, 7               ; return value of deletion
         ret
         stdin_no_del        :

         cmp                 al, 1Bh              ; compare the buffer against 'ESC'
         jne                 stdin_no_esc
         mov                 rax, 11              ; return value of deletion
         ret
         stdin_no_esc        :

         cmp                 al, 0Ah              ; compare the buffer against '\n'
         jne                 stdin_no_newline
         mov                 rax, 15              ; return value of deletion
         ret
         stdin_no_newline    :

         ret


