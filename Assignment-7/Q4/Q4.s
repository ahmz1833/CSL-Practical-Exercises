;==============================================
    ; Assignment 7 - Question 4
    ; Description: Check if two strings are the same
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
    input1 resb 1000
    input2 resb 1000

section .data
    scan:   db  "%s",   0 
    yes:    db  "input1 and input2 are the same!",  10, 0
    no:     db  "input1 and input2 are not the same!",  10, 0

section .text
global main
extern printf
extern scanf

main:
    enter 0
    lea rsi, [input1]           ; Load the address of the string
    lea rdi, [scan]             ; Load the address of the format string
    call scanf                  ; Call scanf

    lea rsi,    [input2]        ; Load the address of the string
    lea rdi,    [scan]          ; Load the address of the format string
    call scanf                  ; Call scanf

    lea rsi, [input1]           ; Load the address of the input1 into rsi
    lea rdi, [input2]           ; Load the address of the input2 into rdi

compare:
    mov al, [rsi]               ; Load the byte from the input1 into al
    mov bl, [rdi]               ; Load the byte from the input2 into bl
    cmp al, bl                  ; Compare the two bytes
    jne not_equal               ; If they are not equal, jump to not_equal
    cmp al, 0                   ; Check if we reached the end of both strings
    je  equal                   ; if yes, both null -> strings are equal
    inc rsi                     ; next byte in input1
    inc rdi                     ; next byte in input2
    jmp compare                 ; Repeat the comparison for the next byte

not_equal:
    lea rdi, [no]               ; Load the address of the no string into rdi
    call printf                 ; Call printf
    jmp end                     ; Jump to the end

equal:
    lea rdi, [yes]              ; Load the address of the yes string into rdi
    call printf                 ; Call printf

end:
    leave 0
