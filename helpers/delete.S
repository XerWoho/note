extern   write

section  .data
         backseq        db 8, ' ', 8

section  .text
         global         delete

back:
	; write "\b \b"
         mov            rdi, 1                ; stdout
         mov            rsi, backseq
         mov            rdx, 3
         call           write
         ret


delete:
         cmp            byte [r10], 0
         jne            delete_skip

         call           back
         call           back
         ret

         delete_skip    :
         dec            byte [r10]            ; remove one from the current length of the temp_data, to get to the last position

         movzx          rcx, byte [r10]
         mov            byte [r9 + rcx], 0

         call           back
         call           back
         call           back
         ret
