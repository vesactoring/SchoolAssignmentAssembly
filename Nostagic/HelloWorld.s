.text
message: .asciz "My name is Khoa \nMy netID is khoanguyen@tudelft.nl \nAss: Power \n"
promptB: .asciz "\n Input your base number \n"
inputB: .asciz "%ld"
promptE: .asciz "\n Input your exponent \n"
inputE: .asciz "%ld"
output: .asciz "\n The result is : %ld.\n\n"
error: .asciz "The output should be greater than 0 \n"
.global main
main:
#pro for the main function
movq %rsp, %rbp
movq $0, %rax

mov $message, %rdi
call printf

#get base

movq $0, %rax
movq $promptB, %rdi
call printf

subq $8, %rsp
movq $0, %rax
movq $inputB, %rdi
leaq -8(%rbp), %rsi
call scanf

popq %rsi
mov %rsi, %r12
mov $0, %rax
cmp $0, %r12
jl end

#get exponent

movq $0, %rax
movq $promptE, %rdi
call printf

subq $8, %rsp
movq $0, %rax
movq $inputE, %rdi
leaq -8(%rbp), %rsi
call scanf

popq %rsi

mov $0, %rax
mov %rsi, %r13
mov $1, %r14
cmp $0, %r13
jl end
// add %r12, %rsi # system input
// movq $0, %rax
// movq $output, %rdi
// call printf

// movq %rbp, %rsp
// popq %rbp



loop:
cmp $0, %r13
jle pow
dec %r13

imul %r12, %r14
jmp loop

pow:
#pro
push %rbp
movq %rsp, %rbp
mov $0, %rax
mov %r14, %rsi
mov $output, %rdi
call printf
leave
ret

end: 
movq $error, %rdi
call printf
call exit

// pow:
// #pro for the second function
// pushq %rbp
// movq %rsp , %rbp

// movq $0, %rax
// movq $prompt, %rdi
// call printf

// subq $8, %rsp
// movq $0, %rax
// movq $input, %rdi
// leaq -8(%rbp), %rsi
// call scanf

// popq %rsi

// mov %rsi, %r12


