global  asm_main
extern  scanf
extern  printf

section .text
asm_main:

    sub rsp,    8
    lea rsi,    [input1]
    lea rdi,    [scan]
    call scanf
    lea rsi,    [input2]
    lea rdi,    [scan]
    call scanf
    lea rsi, [input1]
    lea rdi, [input2]

compare:
    mov al, [rsi]     ; Load a byte
    mov bl, [rdi]
    cmp al, bl
    jne not_equal
    cmp al, 0         ; Check if end of string
    je  equal         ; both null -> strings are equal
    inc rsi           ; next byte
    inc rdi
    jmp compare       ; Repeat the comparison

not_equal:
    lea rdi,    [no]
    call    printf
    add rsp,    8
    ret

equal:
    lea rdi,    [yes]
    call    printf
    add rsp,    8     
    ret

section .data

input1: db  1000    dup(0)
input2: db  1000    dup(0)
scan:   db  "%s",   0 
yes:    db  "input1 and input2 are the same!",  10, 0
no:     db  "input1 and input2 are not the same!",  10, 0
