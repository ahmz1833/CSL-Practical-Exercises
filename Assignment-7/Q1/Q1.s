;; Assignment 7 - Practical Question 5; 402106434, 402106456
global  asm_main
extern  scanf
extern  printf
extern  strcmp
section .text

%macro  printShort 1
    movsx   rsi,    word %1
    mov     rdi,    print_short
    call    printf
%endmacro

%macro  printInt 1
    mov     rsi,    %1
    mov     rdi,    print_int
    call    printf
%endmacro

%macro  scanInt 0
    mov rdi,    scan_int
    call    scanf
%endmacro

%macro  scanShort 0
    mov rdi,    scan_short
    call    scanf
%endmacro
asm_main:

    sub rsp,    8
    lea rsi,    [input]
    scanShort
    lea rsi,    [input+2]
    scanShort
    lea rsi,    [input+4]
    scanShort
    lea rsi,    [input+6]
    scanShort

while:
    lea rsi,    [str]
    lea rdi,    [scan_str]
    call scanf
    lea rdi,    [end]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  end_while


    lea rdi,    [cmp]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  compare
    
    lea rdi,    [swap]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  swapping

    lea rdi,    [msb]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  MSB


    lea rdi,    [lsb]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  LSB


    lea rdi,    [overflow]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  flow

    lea rdi,    [div]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  division

    lea rdi,    [mul]
    lea rsi,    [str]
    call strcmp
    cmp rax,    0
    je  multiply

    jmp while
    
end_while:
    add rsp,    8
    ret

compare:
    lea rsi,    [num]
    scanInt
    lea rsi,    [num+4]
    scanInt
    mov eax,    [num]
    shl eax, 1
    mov ebx,    [num+4]
    shl ebx, 1
    mov ax,    [input + eax]
    mov bx,    [input + ebx]
    cmp ax,    bx
    jg  .num1
    jmp .num2
.num1:
    printShort  ax
    jmp while
.num2:
    printShort  bx
    jmp while

swapping:
    lea rsi,    [num]
    scanInt
    lea rsi,    [num+4]
    scanInt
    mov r8d,    [num]
    shl r8d, 1
    mov r9d,    [num+4]
    shl r9d, 1
    mov ax,    [input + r8d]
    mov bx,    [input + r9d]
    mov [input + r8d],   bx
    mov [input + r9d],   ax
    jmp while

MSB:
    lea rsi,    [num]
    scanInt
    mov eax,     [num]
    shl eax,     1
    mov ax,     [input + eax]
    mov bx,     -1
.msb_loop:
    cmp ax, 0
    je  .end_msb
    shr ax, 1
    inc bx
    jmp .msb_loop
.end_msb:
    printShort  bx
    jmp while

LSB:
    lea rsi,    [num]
    scanInt
    mov eax,     [num]
    shl eax,     1
    mov ax,     [input + eax]
    mov bx,     0
.lsb_loop:
    movsx r8,    ax
    and r8,    1
    cmp r8,    1
    je  .lsb_end
    shr ax, 1
    inc bx
    jmp .lsb_loop
.lsb_end:
    printShort  bx
    jmp while


flow:
    lea rsi,    [num]
    scanInt
    lea rsi,    [num+4]
    scanInt
    mov eax,    [num]
    shl eax, 1
    mov ebx,    [num+4]
    shl ebx, 1
    mov ax,    [input + eax]
    mov bx,    [input + ebx]
    add ax,    bx
    jo  .overflow
    lea rsi,    [no]
    lea rdi,    [print_str]
    call    printf
    jmp while
.overflow:
    lea rsi,    [yes]
    lea rdi,    [print_str]
    call    printf
    jmp while


division:
    lea rsi,    [num]
    scanInt
    lea rsi,    [num+4]
    scanInt
    mov eax,    [num]
    shl eax, 1
    mov ebx,    [num+4]
    shl ebx, 1
    mov bx,    [input + ebx]
    cmp bx,    0
    je  .invalid
    mov ax,    [input + eax]
    cwd
    idiv bx
    mov bx,    dx
    printShort  ax
    printShort  bx
    jmp while
.invalid:
    lea rsi,    [invalid]
    lea rdi,    [print_str]
    call    printf
    jmp while

multiply:
    lea rsi,    [num]
    scanInt
    lea rsi,    [num+4]
    scanInt
    mov eax,    [num]
    shl eax, 1
    mov ebx,    [num+4]
    shl ebx, 1
    mov ax,    [input + eax]
    mov bx,    [input + ebx]
    imul bx
    movsx rax,   ax
    printInt    rax
    jmp while

section .data

scan_int:       db  "%d",   0
scan_short:     db  "%hd",  0
print_short:    db  "%hd",  10, 0
print_str:      db  "%s",   10, 0
print_int:      db  "%d",   10, 0
input:          dw  0,  0,  0,  0
num:            dd  0,  0
str:            db  1000    dup(0)
scan_str:       db  "%s",   0
cmp:            db  "cmp",  0
swap:           db  "swap", 0
mul:            db  "mul",  0
div:            db  "div",  0
msb:            db  "msb",  0
lsb:            db  "lsb",  0
overflow:       db  "overflow", 0
carry:          db  "carry", 0
end:            db  "end", 0
yes:            db  "YES", 0
no:             db  "NO",  0
invalid:        db  "Invalid division!", 0
