extern   help
extern   save_help

extern   clear
extern   increment_lines

extern   open_file
extern   write_file
extern   close_file
extern   delete_file

extern   sys_exit

extern   set_raw
; extern set_normal

extern   read
extern   write

extern   delete
extern   stdin

section  .data
         is_saving          dq 0                          ; is the user saving the file? [ESC is pressed]
         file_fd            dq 1                          ; the actual file handle
         backseq            dq 8, ' ', 8

         temp_data_len      dq 0
         file_name_len      dq 0
         temp_data_lines    dq 0


section  .bss
	; REServe Byte of length 128 for text data
         temp_data          resb 128

	; REServe Byte of length 64, for file_name
         file_name          resb 64


section  .text
         global             _start

_start:
         start              :
         mov                qword [is_saving], 0
         call               clear
         call               help

         call               set_raw                       ; set termios to raw mode, to read keystrokes
         call               increment_lines


	; read the given value with 1 buffer
	; function definition
         read_data          :
         lea                r9, [rel temp_data]
         lea                r10, [rel temp_data_len]

         call               stdin                         ; returns the buffer within the AL register (RAX, least sig. byte)
         cmp                rax, 7                        ; 7 return means DEL key was found
         je                 read_data

         cmp                rax, 11                       ; 11 return means ESC key was found
         je                 init_saving                   ; initialize the save function

         cmp                rax, 15                       ; compare the buffer against '\n'
         jne                no_newline
         call               increment_lines               ; increment if \n is found
         no_newline         :

	; move the current data len to rcx whilst filling the rest with zeros
	; mov (zx) => zero extend
         mov                rcx, qword [temp_data_len]

	; loads the effective memory address of the temp_data buffer into rdx
         lea                rbx, [rel temp_data]

	; moves the data in al, into the address at the buffer from rbx at index
	; of rcx
         mov                byte [rbx + rcx], al

	; increments the byte to which temp_data_len is pointing to
         inc                qword [temp_data_len]

	; recursively read all data
         jmp                read_data

         read_file_name     :
         lea                r9, [rel file_name]
         lea                r10, [rel file_name_len]

         call               stdin
         cmp                rax, 7                        ; 7 return means DEL key was found
         je                 read_file_name

         cmp                rax, 11                       ; 'ESC'
         je                 restart                       ; restart the programm from initial sequence

         cmp                rax, 15                       ; compare the buffer against '\n'
         je                 save

         mov                rcx, qword [file_name_len]
         lea                rbx, [rel file_name]
         mov                [rbx + rcx], al

         inc                qword [file_name_len]
         jmp                read_file_name

	; cancel saving process
         restart            :
         mov                qword [is_saving], 0
         call               clear
         call               help
         call               increment_lines

         cmp                qword [temp_data_len], 0
         jle                read_data

         lea                rsi, [rel temp_data]
         mov                rdx, [temp_data_len]
		; mov rdx, 8

         mov                rdi, 1
         call               write

         jmp                read_data

         init_saving        :
         call               clear
         call               save_help
         call               increment_lines

         mov                qword [is_saving], 1

         cmp                qword [file_name_len], 0
         jle                read_file_name

         lea                rsi, [rel file_name]
         mov                rdx, [file_name_len]
         mov                rdi, 1
         call               write

         jmp                read_file_name

         save               :
		; open the target file name
         mov                rdi, file_name
         call               open_file
         mov                [file_fd], rax


		; transfer the data over
         lea                rsi, [rel temp_data]
         mov                rdx, qword [temp_data_len]
         mov                rdi, [file_fd]
         call               write_file                    ; call write_file

         mov                rdi, [file_fd]
         call               close_file                    ; close file

         jmp                sys_exit                      ; sys_exit programm
