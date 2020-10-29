.text
character: .asciz "\033[38;5;%dm\033[48;5;%dm%c"
effect: .asciz "\033[%dm"
// .include "helloWorld.s"
// .include "abc_sorted.s"
.include "final.s"

.global main
# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte color                                           *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq %rbp 			            # push the base pointer (and align the stack)
	movq %rsp, %rbp		            # copy stack pointer value to base pointer
    # your code goes here
    mov     $0, %rcx                # counter
    mov $0, %r13
    .decodeLoop:
    push %rdi                       # to save RDI
    mov %r10, %r14                  # to save the previous R10
    mov %r11, %r15                  # to save the prevous R11
    mov  (%rdi, %rcx, 8), %rdi      # to get the address to RDI
    mov  %dil, %r8b                 # character
    shr  $8, %rdi                   # shift 1 byte from the right
    mov  %dil, %r9b                 # number of character
    shr  $8, %rdi                   # shift 1 byte from the right
    mov  %edi, %ecx                 # index
    shr  $32, %rdi                  # shift 4 byte from the right
    mov %dil, %r10b                 # foreground color - 30
    shr $8, %rdi                    # shift 1 byte from the right
    mov %dil, %r11b                 # background color - 40
    
    cmp %r10, %r11                  # compare if the background and the foreground equal or not
    je .same                        # jump to same if they are equal to each other

    .savePoint:
	push    %rcx                    # to save RCX

    .printLoop:
    push %r11                       # to save R11
    push %r10                       # to save R10
    push %r9                        # to save R9
    push %r8                        # to save R8

    mov  %r8b, %cl                  # fourth parameter: the character
    mov %r11, %rdx                  # third parameter: the background color
    mov %r10, %rsi                  # second parameter: the foreground color
    mov  $character, %rdi           # first parameter: the charater string
    mov  $0, %rax                   # no usage of vector
    call printf                     # call subroutine pritnf

    pop  %r8                        # get the value of R8
    pop  %r9                        # get the value of R9
    pop %r10                        # get the value of R10
    pop %r11                        # get the value of R11
    dec  %r9b                       # decriment R9b by 1
    cmp  $0, %r9b                   # compare 0 with R9b
    jne  .printLoop                 # jump to .printLoop if not equal

    pop  %rcx                       # get the value of RCX
    pop  %rdi                       # get the value of RDI
    cmp  $0, %ecx                   # compare 0 with ECX
    je   .end                       # jump to end (no more lines to go to anymore) if ECX equals to 0
    jmp  .decodeLoop                # else, jump to .decodeLoop to keep printing
    .end:
    mov $0, %rsi                    # second parameter: reset the effect
    mov $effect, %rdi               # first parameter: the effect string
    mov $0, %rax                    # no vector
    call printf                     # call printf to reset 
	# epilogue
	movq %rbp, %rsp		            # clear local variables from stack
	popq %rbp			            # restore base pointer location 
	ret                             # return the values 

    .same:
    cmp $0, %r10                    # compare with the requirement from the lab manual
    je .reset
    cmp $37, %r10
    je .stopBlinking
    cmp $42, %r10
    je .bold
    cmp $66, %r10
    je .faint
    cmp $105, %r10
    je .conceal
    cmp $153, %r10
    je .reveal
    cmp $182, %r10
    je .blink
    .moveback:
    push %rcx
    push %r11
    push %r10
    push %r9
    push %r8
    mov %r13, %rsi                   # second parameter: the effect
    mov $effect, %rdi                # first parameter: the effect string to print out
    mov $0, %rax                     # no vector
    call printf                      # call printf
    pop  %r8
    pop  %r9
    pop %r10
    pop %r11
    pop %rcx
    mov %r14, %r10
    mov %r15, %r11
    jmp .savePoint                    # jump back

    .reset:
    mov $0, %r13
    jmp .moveback
    .stopBlinking:
    mov $25, %r13
    jmp .moveback
    .bold: 
    mov $1, %r13
    jmp .moveback
    .faint:
    mov $2, %r13
    jmp .moveback
    .conceal:
    mov $8, %r13
    jmp .moveback
    .reveal:
    mov $28, %r13
    jmp .moveback
    .blink:
    mov $5, %r13
    jmp .moveback
main:
	pushq %rbp 			            # push the base pointer (and align the stack)
	movq  %rsp, %rbp		        # copy stack pointer value to base pointer

	movq  $MESSAGE, %rdi	        # first parameter: address of the message
	call  decode			        # call decode

	popq  %rbp			            # restore base pointer location 
	movq  $0, %rdi		            # first parameter: the program exit code
	call  exit			            # exit the program
