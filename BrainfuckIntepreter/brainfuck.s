.text
format_str: .asciz "%c"
input: .asciz "%c"
.data
buffer: .skip 10000            # array to store data
var: .skip 8
.global brainfuck

brainfuck:
    push %rbp
	movq %rsp, %rbp

    push %r11                       # value at PROGRAM[PC]
    push %r12                       # program counter
    push %r13                       # to save the first bracket [
    push %r15                       # the source code of brainfuck
    mov %rdi, %r15                  # the brainfuck string address 104219808
    mov $0, %r12   
    mov $0, %r11
    mov $0, %r13

    .scan:
    mov (%r15), %al
    inc %r15
    cmp $0, %al                     # null
    je .end
    cmp $0x3E, %al                  # >
    je .pcpp                        
    cmp $0x2B, %al                  # +
    je .pcapp
    cmp $0x3C, %al                  # <
    je .pcmm
    cmp $0x5B, %al                  # [
    je .loopStart
    cmp $0x5D , %al                 # ]
    je .loopEnd
    cmp $0x2D, %al                  # -
    je .pcamm
    cmp $0x2C, %al                  # ,
    je  .getChar
    cmp $0x2E, %al                  # .
    je .putchar
    jmp .scan 

    .end:
    pop %r15
    pop %r13
    pop %r12
    pop %r11
    
	movq %rbp, %rsp
	popq %rbp
	ret
        
    .pcpp:
    add $8, %r12                    # move to the next memory location
    jmp .scan

    .pcapp:
    mov buffer(%r12), %r11
    inc %r11
    mov %r11, buffer(%r12)
    jmp .scan

    .pcmm:
    sub $8, %r12                    # move to the previous memory location
    jmp .scan

    .loopStart:
    dec %r15                        # Since up there, there is inc R15
    push %r15
    inc %r15
    cmp $0, buffer(%r12)
    je .jumpforward
    jmp .scan

    .loopEnd:
    cmp $0, buffer(%r12)
    jle .popOld
    pop %r15
    jmp .scan 

    .pcamm:
    mov buffer(%r12), %r11
    dec %r11
    cmp $0, %r11
    jl .convert
    .afterC:
    mov %r11, buffer(%r12)
    jmp .scan

    .putchar:
    movq $0, %rax           
    movq buffer(%r12), %rsi
    mov $format_str, %rdi
    call printf
    jmp .scan
    
    .getChar:
                   // Lay input cua nguoi dung
    movq $1, %rdx           #read length
    movq $var, %rsi         #read buffer
    movq $0, %rax           #syscall no. (SYS_READ)
    movq $0, %rdi           #file no. (STDIN)
    syscall
    movq var, %rdi
    mov %rdi, buffer(%r12)
    jmp .scan

    .popOld:
    add $8, %rsp
    jmp .scan
    
    # Because if the value at [ is 0, it will jump to the its coresponding ], 
    # so if there exists nested [] inside it, this algorithm will deal with it.
    # Algorithm to check the pair of closing and opening racket [] : first, it pushes the first open racket
    # push <memory location of> [
    # then, moves it to R13
    # It iterates the next characters to find another opening/closing racket
    # If it finds an opening, it will then push it to the stack
    # push <memory location of> [
    # It keeps iterating the characters to fine another opening/closing racket
    # If it finds a closing one, it will pop the latest push of opening racket
    # pop RDI <---- pop the memory location of the latest opeining racket to RDI
    # check if that closing bracket ] corresponding to the first open brakcet [
    # cmp RDI, R13
    # If not, continues the loop
    # Else, jump back to .scan to keep working with the brainfuck
    .jumpforward:
    dec %r15
    mov %r15, %r13
    inc %r15
    .check:
    mov (%r15), %al
    inc %r15
    cmp $0x5B , %al                 # [
    je .open
    cmp $0x5D, %al                  # ]
    je .closing
    jmp .check

    .convert:
    mov $255, %r11
    jmp .afterC

    .open:
    dec %r15
    push %r15
    inc %r15
    jmp .check

    .closing:
    pop %rdi
    cmp %rdi, %r13
    jne .check
    jmp .scan
