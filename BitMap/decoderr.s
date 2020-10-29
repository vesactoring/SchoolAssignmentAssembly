.text
fname: .asciz "bitmap.bmp"
pattern: .asciz "WWWWWWWWBBBBBBBBWWWWBBBBWWBBBWWR"
leadAndTrailString: .asciz "CCCCCCCCSSSSEE1111444400000000"
size: .equ length, size - leadAndTrailString
.data
barColor: .skip 3126
format_str: .asciz "%s"
rle: .skip 200
leadAndTrail: .skip 200
decoded: .skip 100
red: .byte 0xFF
green: .byte 0xFF
blue: .byte 0xFF
.global main
main:
push %rbp
mov %rsp, %rbp

call bitmap
call runLengthEncoding
call final
mov $0, %rax
mov $decoded, %rsi
mov $format_str, %rdi
call printf

pop %rbp
mov $0, %rdi
call exit

bitmap:
    push %rbp
    mov %rsp, %rbp

    push %r11
    push %r12
    push %r13
    push %r14
    push %r15

    mov $54, %r15

    mov $2, %rax
    mov $fname, %rdi
    mov $2, %rsi
    mov $402, %rdx
    syscall

    mov %rax, %r8

    mov $0, %rax
    mov %r8, %rdi
    mov $barColor, %rsi
    mov $3126, %rdx
    syscall

    mov $3, %rax
    mov %r8, %rdi
    syscall

    mov $0, %r11
    .loopBarColor:
    mov $0, %r13
    .loopPixelColor:
    mov pattern(%r13), %r14
    cmp $0x57, %r14b
    je .white
    cmp $0x42, %r14b
    je .black
    cmp $0x52, %r14b
    je .red
    .backBarColor:
    inc %r12
    inc %r13
    cmp $1024, %r12
    je .returnBarColor
    cmp $32, %r13
    je .loopBarColor
    jmp .loopPixelColor

    .white:
    mov $0, %rax
    movzb barColor(%r15), %rax
    cmp $255, %al
    je .returnBarColor
    inc %r15
    xor blue, %rax
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    movzb barColor(%r15), %rax
    cmp $255, %al
    je .returnBarColor
    inc %r15
    xor green, %rax
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    movzb barColor(%r15), %rax
    cmp $255, %al
    je .returnBarColor
    inc %r15
    xor red, %rax
    movb %al, rle(%r11)
    inc %r11
    jmp .backBarColor

    .black:
    mov $0, %rax
    movzb barColor(%r15), %rax
    inc %r15
    xor $0, %al
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    movzb barColor(%r15), %rax
    inc %r15
    xor $0, %al
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    movzb barColor(%r15), %rax
    inc %r15
    xor $0, %al
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    jmp .backBarColor

    .red:
    mov $0, %rax
    movzb barColor(%r15), %rax
    inc %r15
    xor $0, %al
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    movzb barColor(%r15), %rax
    inc %r15
    xor $0, %al
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    movzb barColor(%r15), %rax
    inc %r15
    xor red, %al
    movb %al, rle(%r11)
    inc %r11
    mov $0, %rax
    jmp .backBarColor

    .returnBarColor:
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %r11
    pop %rbp
    ret

runLengthEncoding:
    push %rbp
    mov %rsp, %rbp

    push %r15
    push %r14
    push %r13
    push %r12
    
    mov $0, %r12
    mov $0, %r15
    mov $0, %r14
    mov $0, %r13

    .loopRLE:
    movzb rle(%r15), %r14 # counter
    inc %r15
    movzb rle(%r15), %r13 # the character
    inc %r15
    cmp $0, %r13b
    je .return
    jmp .loopAppend

    .loopAppend:
    cmp $0, %r14b
    je .loopRLE
    movb %r13b, leadAndTrail(%r12)
    inc %r12
    dec %r14b
    jmp .loopAppend
    
    .return:
    mov $rle, %rax
    pop %r12
    pop %r13
    pop %r14
    pop %r15
    pop %rbp
    ret

final:
    push %rbp
    mov %rsp, %rbp

    push %r15
    push %r14
    push %r13
    push %r12
    push %r11

    mov $0, %rcx
    mov $0, %r11
    mov $0, %r12
    mov $0, %r15
    mov $0, %r14
    mov $0, %r13


    .loopFinal:
    cmp $2, %rcx
    je .returnF
    movzb leadAndTrailString(%r13), %r12
    inc %r13
    mov $31, %rdx
    cmp %rdx, %r13
    je .rest
    .loopFF:
    movzb leadAndTrail(%r15), %r14
    inc %r15
    .reset:
    cmp %r12, %r14
    je .loopFinal
    mov %r14b, decoded(%r11)
    inc %r11
    jmp .loopFF
    
    .rest:
    mov $0, %r13
    inc %rcx
    jmp .loopFinal
    .returnF:
    pop %r11
    pop %r12
    pop %r13
    pop %r14
    pop %r15
    pop %rbp
    ret
