/*
+Program: Power
+Description: The program prints the value of a base raise to the power of a exponent

Java (Pseudo) CODE:
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    int base = sc.nextInt();
    if (base < 0) end();
    int exponent = sc.nextInt();
    if (exponent < 0) end();
    System.out.print( "The result is: " + pow(base, exponent));
}

public static void end() {
    System.out.println("The input should be greater than 0");
    System.exit(0);
}

public static int power(int base, int exponent) {
    int pow = 1;
    while (exponent > 0) {
        pow *= base;
        exponent--;
    }
    return pow;
}
*/
.text
message: .asciz "My name is Khoa \nMy netID is khoanguyen@tudelft.nl \nAss: Power \n"
promptB: .asciz "\nInput your base number \n"
inputB: .asciz "%ld"
promptE: .asciz "\nInput your exponent\n"
inputE: .asciz "%ld"
output: .asciz "\nThe result is: %ld.\n\n"
error: .asciz "The input should be greater than 0 \n"

.global main
/**
+ Routine: main
+ Description: this routine takes two integers as inputs from a user,
pass them as parameters to subroutine power
+ Parameters: there are no parameters and no return value
*/
main:
    mov %rsp, %rbp             # initialize the base pointer

    mov $0, %rax               # no vector registers in use for printf
    mov $message, %rdi         # first parameter: message string
    call printf                # call printf to print message

    mov $0, %rax               # no vector registers in use for printf
    mov $promptB, %rdi         # first parameter: promptB string
    call printf                # call printf to print promptB

    sub $8, %rsp               # reserve space in stack for the input
    mov $0, %rax               # no vector registers in use for scanf
    mov $inputB, %rdi          # first parameter: inputB string for base
    lea -8(%rbp), %rsi         # second parameter: address of the reserved space
    call scanf                 # call scanf to scan the user's input

    pop %rsi                   # pop the input value into RSI

    mov %rsi, %r14             # copy RSI into R14
    cmp $0, %rsi               # compare 0 with RSI
    jl end                     # jump to end if less than 0

    mov $0, %rax               # no vector registers in use for printf
    mov $promptE, %rdi         # first parameter: promptE string
    call printf                # call printf to print promptE

    sub $8, %rsp               # reserve space in stack for the input
    mov $0, %rax               # no vector registers in use for scanf
    mov $inputE, %rdi          # first parameter: inputE string for the exopent
    lea -8(%rbp), %rsi         # second parameter: address of the reserved space
    call scanf                 # call scanf to scan the user input

    pop %rsi                   # pop the input value into RSI
                               # second parameter: exponent value
    mov $0, %rax               # no vector registers in use for pow
    cmp $0, %rsi               # compare 0 with RSI
    jl end                     # jump to end of RSI is less than 0

    mov %r14, %rdi             # first parameter: base
    mov $0, %r14               # clean the caller saver to the original value
    call pow                   # call pow to calculate the power value

    mov %rax, %rsi             # copy the return value of pow (RAX) into RSI
                               # second parameter: the return value of pow
    mov $output, %rdi          # first parameter: output string
    mov $0, %rax               # no vector registers in use for printf
    call printf                # call printf to print the output

/**
+ Subroutine: pow
+ Description: this routine takes two integers as paramter and return the power result
+ Parameters: base and exponent
+ Return: the value of base raised to the power of exponent
*/
pow:
    # prologue
    push %rbp                  # push the base pointer
    mov %rsp, %rbp             # copy stack poiinter value to base pointer

    mov $1, %rax               # copy 1 to RAX

    loop:
        cmp $0, %rsi           # compare 0 with RSI
        jle .returnPoint       # jump to lable returnPoint if RSI is equal 0
        dec %rsi               # RSI minus by 1
        imul %rdi, %rax        # multiply RDI into RAX
        jmp loop               # jump back to loop

    .returnPoint:           
    mov %rbp, %rsp             # clear local variable from stack
    pop %rbp                   # restore base pointer location
    ret                        # return

/** 
+ Subroutine: end
+ Description: this subroutine print out the error and exit the program
+ Parameters: there are no parameters
+ Return: there are no return values
*/
end: 
    mov $error, %rdi           # first parameter: error string
    mov $0, %rax               # no vector in use for printf
    call printf                # call printf to print the string error

    mov $0, %rdi               # first parameter: 0
    call exit                  # call exit to exit the program with the exit code of 0
