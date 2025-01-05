;==============================================
    ; Assignment 7 - Question 5
    ; Description: This program counts the number of 0s and 1s in the input string.
    ; AmirHossein MohammadZadeh - 402106434
    ; MohammadMahdi Mohammadi - 402106456
;==============================================

%macro enter 1
    push rbp
    mov rbp, rsp
    sub rsp, %1*16
%endmacro

%macro leave 1
    add rsp, %1*16
    leave
    ret
%endmacro

section .bss
    buffer: resb 100

section .data
    scanf_format: db  "%s",   0
    num_of_ones:  db  "Number of ones: %d", 10, 0
    num_of_zeros: db  "Number of zeros: %d", 10, 0

section .text
global main
extern printf
extern scanf

main:
    enter 1                             ; allocate space for 2 (2*8byte) local variable on the stack
    mov qword [rsp], 0                  ; initialize the first local variable to 0 (number of 0s)
    mov qword [rsp + 8], 0              ; initialize the second local variable to 0 (number of 1s)

    lea rdi, [scanf_format]             ; load the address of the format string into rdi
    lea rsi, [buffer]                   ; load the address of the buffer into rsi
    call scanf                          ; call scanf to read the input string

    lea rcx, [buffer]                   ; load the address of the buffer into rcx
_loop:
    movzx rax, byte [rcx]               ; move the first byte of the buffer into rax
    cmp rax, '0'                        ; test if rax is zero
    je _zero                            ; if it is, jump to _zero
    cmp rax, '1'                        ; test if rax is one
    je _one                             ; if it is, jump to _one
    jmp _next                           ; jump to _next
_zero:
    inc qword[rsp]                      ; increment the number of 0s
    jmp _next                           ; jump to _next
_one:
    inc qword[rsp + 8]                  ; increment the number of 1s
_next:
    inc rcx                             ; move to the next byte
    cmp byte [rcx], 0                   ; compare the first byte of the buffer with 0
    jne _loop                           ; if it is not zero, jump to _loop

    lea rdi, [num_of_zeros]             ; load the address of the format string into rdi
    mov rsi, [rsp]                      ; load the number of 0s into rsi
    call printf                         ; call printf to print the number of 0s

    lea rdi, [num_of_ones]              ; load the address of the format string into rdi
    mov rsi, [rsp + 8]                  ; load the number of 1s into rsi
    call printf                         ; call printf to print the number of 1s

    leave 1
