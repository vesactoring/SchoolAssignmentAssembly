.text
memory:
.quad 0X30
.quad 0X31
.quad 0X32
.quad 0X33
.quad 0X34
.quad 0X35
.quad 0X36
.quad 0X37
.quad 0X38
.quad 0X39
percentageSign: .asciz "%"
negativeSign: .asciz "-"

output: .asciz "%d %d %d \033[38;5;%um\033[48;5;%um %s %s %s %s \n 100%% what the f**** is happening %r %lfajsdf;lj \033[0m \n"
end: .equ length, end - output
firstMes: .asciz "Khofasdfsadf \n"
secondMes: .asciz " Earth "
thirdMes: .asciz " pho"
fourthMes: .asciz " the sky "
.global main
main:
    push %rbp
    mov %rsp, %rbp

    mov $output, %rdi
    mov $100, %rsi
    mov $-2134234324234, %rdx
    mov $-34323, %rcx
    mov $2, %r8
    mov $4, %r9
    push $firstMes
    push $secondMes
    push $thirdMes
    push $fourthMes
    call my_printf

    #epilogue
    pop %rbp
    mov $0, %rdi
    call exit

my_printf:
	# prologue
	pushq %rbp 			            # push the base pointer (and align the stack)
	movq %rsp, %rbp		            # copy stack pointer value to base pointer

    push %r12
    mov $2, %r12                    # how deep we need to loop pass the RBP
    push %r13
    mov $0, %r13                    # Counter of arguments
    push %r14               
    push %r15
    push %r9
    push %r8
    push %rcx
    push %rdx
    push %rsi
    mov $length, %rcx               # counter
    .savePoint:
    cmp $5, %r13
    inc %r13
    jae .morethan5Args
    pop %r15
    .printLoop:
    push %rcx
    push %rdi
    cmp $0, %rcx
    jle .end
    mov (%rdi), %al
    cmp $0x25, %al      
    je .specialEffect
    mov $1, %rax
    mov $1, %rdx
    mov %rdi, %rsi
    mov $1, %rdi 
    syscall

    pop %rdi
    pop %rcx
    dec %rcx
    inc %rdi
    jmp .printLoop
    .end:
    # epilogue
    pop %r15
    pop %r14
    pop %r13
	movq %rbp, %rsp
	popq %rbp
	ret 

    .specialEffect:
    pop %rdi
    pop %rcx
    inc %rdi
    dec %rcx
    mov (%rdi), %al
    cmp $0x75, %al
    je .decimalU
    cmp $0x64, %al
    je .decimal
    cmp $0x73, %al
    je .string
    cmp $0x25, %al
    je .percentage
    jmp .trash

    .decimalU:
    push %rdi
    push %rcx
    mov %r15, %rax
    # Convert number to ansii
    mov %r15, %rax
    mov $0, %rcx
    .print:
        inc %rcx
        mov $memory, %rdi
        mov $0, %rdx
        mov $10, %r8
        div %r8
        imul $8, %rdx
        add %rdx, %rdi
        push %rdi
        cmp $0, %rax
        jne .print
        .syscall:
        pop %rdi
        dec %rcx
        push %rcx
        push %rdi
        mov %rdi, %rsi
        mov $1, %rdi
        mov $1, %rdx
        mov $1, %rax
        syscall
        pop %rdi
        pop %rcx
        cmp $0, %rcx
        jne .syscall
        pop %rcx
        pop %rdi
        inc %rdi
        dec %rcx
        jmp .savePoint
    
    .decimal:
    push %rdi
    push %rcx
    mov %r15, %rax
    cmp $0, %rax
    jl .signedPoint
    # Convert number to ansii
    mov $0, %rcx
    .printD:
        inc %rcx
        mov $memory, %rdi
        mov $0, %rdx
        mov $10, %r8
        div %r8
        imul $8, %rdx
        add %rdx, %rdi
        push %rdi
        cmp $0, %rax
        jne .printD
        .syscallD:
        pop %rdi
        dec %rcx
        push %rcx
        push %rdi
        mov %rdi, %rsi
        mov $1, %rdi
        mov $1, %rdx
        mov $1, %rax
        syscall
        pop %rdi
        pop %rcx
        cmp $0, %rcx
        jne .syscallD
        pop %rcx
        pop %rdi
        inc %rdi
        dec %rcx
        jmp .savePoint
    
    .signedPoint:
    mov $0, %rcx
    sub %rax, %rcx
    mov %rcx, %rax
    mov $0, %rcx
    push %rax
    push %rcx
    mov $negativeSign, %rsi
    mov $1, %rdi
    mov $1, %rdx
    mov $1, %rax
    syscall
    pop %rcx
    pop %rax
    jmp .printD

    .string:
    push %rdi
    push %rcx
    mov %r15, %rdi
    .anotherString:
    push %rdi
    mov (%rdi), %al
    cmp $0x00, %al
    jle .jumpback
    mov $1, %rax
    mov $1, %rdx
    mov %rdi, %rsi
    mov $1, %rdi 
    syscall

    pop %rdi
    inc %rdi
    jmp .anotherString
    .jumpback:
    pop %rdi
    pop %rcx
    pop %rdi
    inc %rdi
    dec %rcx
    jmp .savePoint

    .percentage:
    push %rdi
    push %rcx
    mov $1, %rax
    mov $1, %rdx
    mov %rdi, %rsi
    mov $1, %rdi
    syscall
    pop %rcx
    pop %rdi
    inc %rdi
    dec %rcx
    jmp .printLoop

    .trash:
    push %rdi
    push %rcx
    mov $1, %rax
    mov $1, %rdx
    mov $percentageSign, %rsi
    mov $1, %rdi
    syscall
    pop %rcx
    pop %rdi
    jmp .printLoop

    .morethan5Args:
    mov %rbp, %r14
    mov (%r14, %r12, 8), %r14
    push %r14
    inc %r12
    pop %r15
    jmp .printLoop
