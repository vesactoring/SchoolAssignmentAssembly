global      main                              ;must be declared for linker (ld)
main:                                         ;tell linker entry point

#######################################################################
### This program creates empty bmp file - 64 bit version ##############
#######################################################################
### main ##############################################################
#######################################################################

    #; open file
    mov     %rax,$85                              #;system call number - open/create file
    mov     %rdi,$msg                             #;file name
                                                #;flags
    mov     %rsi,$111111111b                      #;mode
    syscall                                     #;call kernel

    #; save file descriptor
    mov     %r8, %rax

    #; write headline to file
    mov     %rax, $1                              #;system call number - write
    mov     %rdi, %r8                             #;load file desc
    mov     %rsi, $bmpheadline                    #;load adress of buffer to write
    mov     %rdx, $54                             #;load number of bytes
    syscall                                     #;call kernel

        mov         %rbx, $201                    #;LOOPY counter
        mov         %rdx, $empty_space            #;load address of buffer (space allocated for picture pixels)
LOOPY:
        mov         %rcx, $201                    #;LOOPX counter

LOOPX:
        mov         byte [rdx+0], 0x00          #;BLUE
        mov         byte [rdx+1], 0xFF          #;GREEN
        mov         byte [rdx+2], 0xFF          #;RED

        dec         %rcx                         #;decrease counter_x
        add         %rdx, $3                      #;move address pointer by 3 bytes (1 pixel = 3 bytes, which we just have written)
        cmp         %rcx, $0                      #;check if counter is 0
        jne         LOOPX                       #;if not jump to LOOPX

        dec         %rbx                         #;decrease counter_y
        mov         byte [rdx], 0xFF            #;additional byte per row
        inc         %rdx                         #;increase address
        cmp         %rbx, 0                      #;check if counter is 0
        jne         LOOPY                       #;if not jump to LOOPY



    #; write content to file
    mov     %rax, $1                              #;system call number - write
    mov     %rdi, %r8                             #;load file desc
    mov     %rsi, $empty_space                    #;load adress of buffer to write
    mov     %rdx, $121404                         #;load number of bytes
    syscall                                     #;call kernel

    #; close file
    mov     %rax, $3                              #;system call number - close
    mov     %rdi, %r8                             #;load file desc
    syscall                                     #;call kernel

    #; exit program
    mov     %rax,$60                              #;system call number - exit
    syscall                                     #;call kernel

.data

    msg:         .byte  "filename.bmp",0x00         #;name of out file, 0x00 = end of string
    bmpheadline: .byte  0x42,0x4D,0x72,0xDA,0x01,0x00,0x00,0x00,0x00,0x00,0x36,0x00,0x00,0x00,0x28,0x00,0x00,0x00,0xC9,0x00,0x00,0x00,0xC9,0x00,0x00,0x00,0x01,0x00,0x18,0x00,0x00,0x00,0x00,0x00,0x3C,0xDA,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

.bss                                    #;this section is responsible for preallocated block of memory of fixed size
    empty_space: resb 121404                    #;preallocation of 121404 bytes