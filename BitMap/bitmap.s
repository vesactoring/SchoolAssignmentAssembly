.text
message: .asciz "The answer for exam question 42 is not F."
leadAndTrail: .asciz "CCCCCCCCSSSSEE1111444400000000"
pattern: .asciz "WWWWWWWWBBBBBBBBWWWWBBBBWWBBBWWR"
ln: .asciz "File created sucessfully\n"
format_str: .asciz "%s"
.data
fname: .asciz "bitmap.bmp"
bmpheadline: .byte 0x42,0x4D,0x36,0x0C,0x00,0x00,0x00,0x00,0x00,0x00,0x36,0x00,0x00,0x00,0x28,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x20,0x00,0x00,0x00,0x01,0x00,0x18,0x00,0x00,0x00,0x00,0x00,0x00,0x0C,0x00,0x00,0x12,0x0B,0x00,0x00,0x12,0x0B,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00  # 3072
red: .byte 0xFF
green: .byte 0xFF
blue: .byte 0xFF
adder: .skip 200
rle: .skip 200
barColor: .skip 3072
.global main
main:
    pushq %rbp
    mov %rsp, %rbp

    mov $message, %rdi
    call appendLeadAndTrail

    mov %rax, %rdi
    call runLengthEncoding

    // call barcode
    call BarcodeColor

    call encryption
    call createFile
    call bitmap

    mov $ln, %rdi
    mov $0, %rax
    call printf

    .end:
    pop %rbp
    mov $0, %rdi
    call exit

appendLeadAndTrail:
    push %rbp
    mov %rsp, %rbp

    push %r15 
    push %r14
    push %r13

    mov $30, %rcx # first counter
    mov $0, %r14 # second counter
    mov $0, %r13 # third counter
    .appendLead:
    mov leadAndTrail(%r14), %r15b
    cmp $0, %r15b
    je .next1
    mov %r15b, adder(%r13)
    inc %r13
    inc %r14
    jmp .appendLead

    .next1:
    mov $0, %rdx
    .appendMes:
    mov (%rdi, %rdx), %r15b
    cmp $0, %r15b
    je .next
    mov %r15b, adder(%r13)
    inc %rdx
    inc %r13
    jmp .appendMes

    .next:
    mov $0, %rdx # second counter
    .appendTrail:
    mov leadAndTrail(%rdx), %r15b
    cmp $0, %r15b
    je .returnP
    mov %r15b, adder(%r13)
    inc %rdx
    inc %r13
    jmp .appendTrail

    .returnP:
    mov $adder, %rax

    pop %r13    
    pop %r14
    pop %r15
    pop %rbp
    ret

runLengthEncoding:
    push %rbp
    mov %rsp, %rbp

    push %r15
    push %r14
    push %r13
    
    mov (%rdi), %r14b
    mov $0, %r13
    mov %rdi, %r15
    mov $0, %rcx # counter
    mov $0, %rdx # counter 2
    .loop:
    mov (%r15, %rcx), %dil
    inc %rcx
    cmp %dil, %r14b
    je .increment
    cmp $0, %dil
    jmp .appendRLE
    .back:
    mov %dil, %r14b
    jmp .loop

    .increment:
    inc %rdx
    jmp .back

    .appendRLE:
    mov %rdx, rle(%r13)
    mov $0, %rdx
    inc %r13
    mov %r14, rle(%r13)
    inc %r13
    dec %rcx
    mov (%r15, %rcx), %r14b
    cmp $0, %r14b
    je .return
    jmp .loop
    
    .return:
    mov $rle, %rax
    pop %r13
    pop %r14
    pop %r15
    pop %rbp
    ret

BarcodeColor:
    push %rbp
    mov %rsp, %rbp

    push %r11
    push %r12
    push %r13
    push %r14
    push %r15

    mov $0, %r11
    mov $0, %r14
    mov $0, %r13
    mov $0, %r12
    mov $0, %r15

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
    mov $0, %r11
    inc %r12
    inc %r13
    cmp $1024, %r12
    je .returnBarColor
    cmp $32, %r13
    je .loopBarColor
    jmp .loopPixelColor

    .white:
    movzb blue, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    movzb green, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    movzb red, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    cmp $3, %r11
    je .backBarColor

    .black:
    mov $0, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    mov $0, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    mov $0, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    cmp $3, %r11
    je .backBarColor

    .red:
    mov $0x0, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    mov $0x0, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    mov red, %rax
    mov %rax, barColor(%r15)
    inc %r11
    inc %r15
    cmp $3, %r11
    je .backBarColor

    .returnBarColor:
    mov $barColor, %rax
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %r11
    pop %rbp
    ret

encryption:
    push %rbp
    mov %rsp, %rbp

    push %r11
    push %r12
    push %r13
    push %r14
    push %r15

    mov $0, %r11
    mov $0, %r14
    mov $0, %r13
    mov $0, %r12
    mov $1, %r15

    .loopEncryptionCheckpoint:
    cmp $0,%r15
    je .encryptionReturn
    movb rle(%r13), %r15b
    movb barColor(%r13), %r14b
    xor %r14, %r15
    movb %r15b, barColor(%r13)
    movb barColor(%r13), %r11b
    inc %r13
    jmp .loopEncryptionCheckpoint

    .encryptionReturn:
    mov $barColor, %rax
    pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %r11
    pop %rbp
    ret
createFile:
    push %rbp
    mov %rsp, %rbp

    mov $2, %rax
    mov $fname, %rdi
    mov $64, %rsi
    mov $420, %rdx
    syscall

    mov %rax, %r8

    mov $1, %rax
    mov %r8, %rdi
    mov $bmpheadline, %rsi
    mov $54, %rdx
    syscall

    mov $3, %rax
    mov %r8, %rdi
    syscall

    pop %rbp
    ret

bitmap:
    push %rbp
    mov %rsp, %rbp

    mov $2, %rax
    mov $fname, %rdi
    mov $2, %rsi
    mov $402, %rdx
    syscall

    mov %rax, %r8

    mov $1, %rax
    mov %r8, %rdi
    mov $bmpheadline, %rsi
    mov $54, %rdx
    syscall


    mov $1, %rax
    mov $barColor, %rsi
    mov %r8, %rdi
    mov $3072, %rdx
    syscall

    mov $3, %rax
    mov %r8, %rdi
    syscall

    pop %rbp
    ret
