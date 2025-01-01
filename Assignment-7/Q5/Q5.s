;; Assignment 7 - Practical Question 5; 402106434, 402106456
global  asm_main
extern  scanf
extern  printf

section .text
asm_main:
    sub rsp,    8

while:
    mov rdi,    scan_char
    mov rsi,    chr
    call    scanf
    cmp byte    [chr],  10
    je  end_while
    cmp byte    [chr],  '1'
    je  else
    cmp byte    [chr],  '0'
    je  then
    jmp while
then:
    mov rbx,    [zero]
    inc rbx
    mov [zero], rbx
    jmp while
else:
    mov rbx,    [one]
    inc rbx
    mov [one],  rbx
    jmp while
end_while:
    mov rsi,    num_of_zeros
    mov rdi,    print_str
    call    printf
    mov rsi,    [zero]
    mov rdi,    print_int
    call    printf
    mov rsi,    num_of_ones
    mov rdi,    print_str
    call    printf
    mov rsi,    [one]
    mov rdi,    print_int
    call    printf
    add rsp,    8
    ret

section .data
scan_char:  db  "%c",   0
print_str:  db  "%s",   0
print_int:  db  "%d",   10, 0
num_of_ones:    db  "Number of ones: ", 0
num_of_zeros:   db  "Number of zeros: ", 0
newline:    db  10, 0
chr:    db  0
zero:   dd  0
one:    dd  0

