.global main #this should be called first
.data #to take input because you can write to it
buffer: .skip 30

.text #read only
format: .asciz "%s " #input as string #Input is always %

main:
#prolouge
enter $0, $0 #1: reserved space on stack

mov $buffer, %rsi
mov $format, %rdi
call scanf

#before calling any functions, you have to mov the value to the register first, then call it, you can't call 2 function consecutively
mov $buffer, %rsi
mov $format, %rdi
call printf

#epilouge
leave
ret
