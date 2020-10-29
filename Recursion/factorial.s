/*
+Program: Factorial
+Description: The program prints the factorial of a number using recursive method

Java (Pseudo) CODE:
public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    int input = sc.nextInt();
    System.out.print(factorial(input));
}

public static void end() {
    System.out.println("The number should be greater than or equal to 0");
    System.exit(0);
}

public static int factorial(int input) {
    if (input < 0) end();
    if (input == 0) return 1;
    return input * factorial(input - 1);
}
*/

.text
welcome: .asciz "Welcome to the program \n"
prompt: .asciz "Input your number \n"
input: .asciz "%lld"
error: .asciz "The number should be greater than or equal 0, and less than 20 to avoid having result larger than signed integer\n"
output: .asciz "The factorial is: %lld \n"

.global main
/**
+ Routine: main
+ Description: this routine takes an integer as input from a user,
pass it as parameter to subroutine factorial
+ Parameters: there are no parameters and no return value
*/
main:
    mov %rsp, %rbp              # initialize the base pointer
    mov $0, %rax                # no vector registers in use for printf

    mov $welcome, %rdi          # first parameter: welcome string
    call printf                 # call printf to print welcome

    mov $0, %rax                # no vector registers in use of printf
    mov $prompt, %rdi           # first parameter: prompt string
    call printf                 # call printf to print prompt

    sub $8, %rsp                # reserve space in stack for the input
    mov $0, %rax                # no vector registers in use for printf
    mov $input, %rdi            # first parameter: input string
    lea -8(%rbp), %rsi          # second parameter: address of the reserved space
    call scanf                  # call scanf to scan the users input

    pop %rsi                    # pop the input value into RSI

    mov %rsi, %rdi              # first parameter: user's input
    mov $0, %rax                # no vector registers in use for factorial
    call factorial              # call the subroutine factorial

    mov $output, %rdi           # first parameter: output string
    mov %rax, %rsi              # second parameter: the return value of factorial
    mov $0, %rax                # no vector registers in use of printf
    call printf                 # call printf to print output

/**
+ Subroutine: end
+ Description: this subroutine loads the program exit code and exits the program
+ Parameters: there are no parameters and no return value
*/
end: 
    mov $0, %rdi                # first parameter: 0
    call exit                   # call exit to exit the program with error code 0

/**
+ Subroutine: factorial
+ Description: this subrutine takes the user's input from routine main as parameter, and calculate its factorial value
+ Parameters: the user's input number from routine main
+ Return: the subroutine itself
+ Return: the factorial value
*/
factorial:
    #prologue
    push %rbp                  # push the base pointer
    mov %rsp, %rbp              # copy stack poiinter value to base pointer

    cmp $0, %rdi                # compare RDI with 0
    jl .error                   # jump to lable error if RDI less than 0
    cmp $20, %rdi               # compare RDI with 20
    jg .error                   # jump to error if greater than to avoid having number larger than signed integer
    cmp $1, %rdi                # compare RDI with 1
    jle .returnPoint            # jump to lable returnPoint if RDI less than 1
    push %rdi
    decq %rdi                   # first parameter: minus 1 if reach
    call factorial              # call the subroutine factorial
 
    jmp .restorePoint           # jump to lable restorePoint
    .returnPoint:               
    mov $1, %rax                # copy 1 into RAX
    # epilouge
    mov %rbp, %rsp
    pop %rbp
    ret                         # return from factorial
    .restorePoint:            
    pop %rdi                    # pop the calculated value from stack into RBX  
    mul %rdi                    # multiply RDI into RAX
    # epilouge
    mov %rbp, %rsp
    pop %rbp
    ret                         # return from factorial
    .error:
    mov $error, %rdi            # first parameter: error string
    mov $0, %rax                # no vector registers in use for printf
    call printf                 # call printf to print error
    jmp end                     # jump to end
