;==============================================
    ; Assignment 7 - Question 3
    ; Description: Print the permutations of a string
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
    buffer resb 100

section .data
    scan_format db "%s", 0
    print_format db "%s", 10, 0

section .text
global main
extern printf
extern scanf
extern memmove

;; Function permute(char* begin)
permute:
    enter 2
    mov rcx, rdi                    ; rcx = begin (initialize counter ptr)
    cmp byte [rdi], 0               ; compare *begin with '\0'
    jne _permute_loop               ; if *begin != '\0', go to permute loop
_print:                             ; else, print
    lea rdi, [print_format]         ;|
    lea rsi, [buffer]               ;|
    call printf                     ;| printf("%s\n", buffer)
    jmp _permute_end                ; return
_permute_loop:
    mov rax, [rcx]                  ; rax = *counter
    mov [rsp], rdi                  ; store begin ptr in local variable (begin)
    mov [rsp + 8], rcx              ; store counter ptr in local variable (counter)
    mov [rsp + 16], rax             ; store *counter in local variable (tmp)
    ; remove element <current> from the string
    sub rcx, rdi                    ;| rcx = counter - begin
    mov rsi, rdi                    ;| 2nd argument of memmove: begin
    add rdi, 1                      ;| 1st argument of memmove: begin + 1
    mov rdx, rcx                    ;| 3rd argument of memmove: counter - begin
    call memmove                    ;| memmove(begin+1, begin, counter-begin)
    mov rdi, [rsp]                  ; load begin ptr from local variable
    mov rcx, [rsp + 8]              ; load counter ptr from local variable
    mov rax, [rsp + 16]             ; load tmp from local variable
    mov byte [rdi], al              ; *begin = tmp
    ; call permute(begin + 1)
    add rdi, 1                      ;|
    call permute                    ;| permute(begin + 1)
    mov rdi, [rsp]                  ; restore begin ptr from local variable
    mov rcx, [rsp + 8]              ; restore counter ptr from local variable
    ; get element <current> back to the string
    sub rcx, rdi                    ;| rcx = counter - begin
    mov rsi, rdi                    ;| 1st argument of memmove: begin (already in rdi)
    add rsi, 1                      ;| 2nd argument of memmove: begin + 1
    mov rdx, rcx                    ;| 3rd argument of memmove: counter - begin
    call memmove                    ;| memmove(begin, begin+1, counter-begin)
    mov rcx, [rsp + 8]              ; load counter ptr from local variable
    mov rax, [rsp + 16]             ; load tmp from local variable
    mov byte [rcx], al              ; *counter = tmp
    ; increment counter and check if it's '\0'
    inc rcx                         ; counter++
    cmp byte [rcx], 0               ; compare *counter with '\0'
    jne _permute_loop               ; if *counter != '\0', swap and permute
_permute_end:
    leave 1

main:
    enter 0

    lea rdi, [scan_format]          ;|
    lea rsi, [buffer]               ;|
    mov rax, 0                      ;|
    call scanf                      ;| scanf("%s", buffer)

    lea rdi, [buffer]               ;|
    call permute                    ;| _permute(buffer)

    leave 0
