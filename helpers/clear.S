extern   sys_exit
extern   write

section  .data
         lines           dq 1

         cline           db `\33[0J`, 0
         cline_len       equ $ - cline

         mup             db `\33[1A`, 0
         mup_len         equ $ - mup

         mle             db `\33[0G`, 0
         mle_len         equ $ - mle



section  .text
         global          increment_lines
         global          clear


increment_lines:
         inc             byte [rel lines]
         ret


move_left:
         mov             rsi, mle               ; the buffer
         mov             rdx, mle_len           ; number of bytes
         mov             rdi, 1                 ; 1 being stdout
         call            write

         cmp             rax, 0
         jl              sys_exit

         ret

move_up:
         mov             rsi, mup               ; the buffer
         mov             rdx, mup_len           ; number of bytes
         mov             rdi, 1                 ; 1 being stdout
         call            write

         cmp             rax, 0
         jl              sys_exit

         ret


clear_line:
         mov             rsi, cline             ; the buffer
         mov             rdx, cline_len         ; number of bytes
         mov             rdi, 1                 ; 1 being stdout
         call            write

         cmp             rax, 0
         jl              sys_exit

         ret

clear:
         cmp             byte [rel lines], 0
         jne             clear_skip_1
         ret

         clear_skip_1    :
         call            move_left

         dec             byte [rel lines]
         call            clear_line

         cmp             byte [rel lines], 0
         jne             clear_skip
         ret

         clear_skip      :
         call            move_up
         jmp             clear
