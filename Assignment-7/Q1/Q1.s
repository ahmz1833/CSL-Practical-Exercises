;==============================================
    ; Assignment 7 - Question 1
    ; Description: Apply some operations on an array of short integers
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

%macro strcheck 3
    lea rdi, [%2]                           ; Load the address of the desired command into rdi
    lea rsi, [%1]                           ; Load the address of the command buffer into rsi
    call strcmp                             ; Call strcmp to compare the command with the desired command
    cmp rax, 0                              ; Check if the command is equal to the desired command
    je %3                                   ; Jump to the desired label if the command is equal to the desired command
%endmacro

%macro strncheck 3
    lea rdi, [%2]                           ; Load the address of the desired command into rdi
    call strlen                             ; Call strlen to get the length of the desired command
    lea rdi, [%1]                           ; Load the address of the command buffer into rsi
    lea rsi, [%2]                           ; Load the address of the command string into rdi
    mov rdx, rax                            ; Load the length of the desired command into rdx
    call strncmp                            ; Call strncmp to compare the command with the desired command
    cmp rax, 0                              ; Check if the command is equal to the desired command
    je %3                                   ; Jump to the desired label if the command is equal to the desired command
%endmacro

%macro sscan2number 3
    sub rsp, 16                             ; Allocate space for two numbers
    lea rdi, [%1]                           ;|
    lea rsi, [two_num_format]               ;|
    lea rdx, [rsp]                          ;|
    lea rcx, [rsp + 4]                      ;|
    call sscanf                             ;| sscanf(%1, "%d %d", &num1, &num2);
    mov %2, dword [rsp]                     ;|
    mov %3, dword [rsp + 4]                 ;|
    add rsp, 16                             ; Free the allocated space
%endmacro

%macro sscannumber 2
    sub rsp, 16                             ; Allocate space local
    lea rdi, [%1]                           ;|
    lea rsi, [num_scan_fmt]                 ;|
    lea rdx, [rsp]                          ;|
    call sscanf                             ;| sscanf(%1, "%d", &num);
    mov %2, dword [rsp]                     ;|
    add rsp, 16                             ; Free the allocated space
%endmacro

%macro printnumber 1
    lea rdi, [num_print_fmt]                ; Load the address of the number format string into rdi
    mov rsi, %1                             ; Load the number into rsi
    call printf                             ; Call printf to print the number
%endmacro

%macro safepush 1
    sub rsp, 16
    mov [rsp], %1
%endmacro

%macro safepop 1
    mov %1, [rsp]
    add rsp, 16
%endmacro

section .bss
    command:        resb    1000

section .rodata
    input_format:   db  "%hd %hd %hd %hd", 0
    read_line_fmt:  db  "%[^", 10, "]",    0
    num_scan_fmt:   db  "%d",     0
    num_print_fmt:  db  "%d",     10, 0
    two_num_format: db  "%d %d",  0
    cmp_format:     db  "cmp ",      0
    swap_format:    db  "swap ",     0
    mul_format:     db  "mul ",      0
    div_format:     db  "div ",      0
    msb_format:     db  "msb ",      0
    lsb_format:     db  "lsb ",      0
    overflow_format:db  "overflow ", 0
    exit_format:    db  "exit",      0
    yes_format:     db  "YES", 10, 0
    no_format:      db  "NO",  10, 0
    invalid_fmt:    db  "Invalid division!", 10, 0
    error_msg:      db  "Invalid command!", 10, 0

section .data
    input:          dw 0, 0, 0, 0

section .text
global main
extern printf
extern scanf
extern strlen
extern strncmp
extern sscanf
extern stdin
extern getchar
extern strcmp

;============================== main() ===================================
main:
    enter 0

    lea rdi, [input_format]                 ; Load the address of the input format string into rdi
    lea rsi, [input]                        ; Load the address of the first element of the input array into rsi
    lea rdx, [input + 2]                    ; Load the address of the second element of the input array into rdx
    lea rcx, [input + 4]                    ; Load the address of the third element of the input array into rcx
    lea r8, [input + 6]                    ; Load the address of the fourth element of the input array into r8
    call scanf                              ; Call scanf to read the input values
    call getchar                            ; Read the newline character

_main_loop:
    ; Read the command with fgets
    lea rdi, [read_line_fmt]                ; Load the address of the read line format string into rdi
    lea rsi, [command]                      ; Load the address of the command buffer into rdi
    call scanf                              ; Call scanf to read the command
    call getchar                            ; Read the newline character

    ; Check if the command is "exit"
    strcheck command, exit_format, _exit

    ; Check if the command is "cmp "
    strncheck command, cmp_format, _compare

    ; Check if the command is "swap "
    strncheck command, swap_format, _swap

    ; Check if the command is "mul "
    strncheck command, mul_format, _multiply

    ; Check if the command is "div "
    strncheck command, div_format, _divide

    ; Check if the command is "msb "
    strncheck command, msb_format, _msb_index

    ; Check if the command is "lsb "
    strncheck command, lsb_format, _lsb_index

    ; Check if the command is "overflow "
    strncheck command, overflow_format, _overflow

    ; If the command is not valid, print an error message
    lea rdi, [error_msg]                    ; Load the address of the error message into rsi
    call printf                             ; Call printf to print the error message
    jmp _main_loop                          ; Jump to the main loop

_compare:
    sscan2number command + 4, eax, ebx      ; Parse the indexes from the command and store them in rax and rbx
    mov ax, word [input + eax*2]            ; Load the first number into ax
    mov si, word [input + ebx*2]            ; Load the second number into si
    cmp ax, si                              ; Compare the two numbers
    jge .num1                               ; If value1 >= value2, jump to num1
    mov ax, si                              ; Otherwise, move value2 to ax
.num1:
    movsx rax, ax                           ; Zero-extend the result
    printnumber rax                         ; Print the result of the comparison
    jmp _main_loop                          ; Jump to the main loop

_swap:
    sscan2number command + 5, eax, ebx      ; Parse the indexes from the command and store them in rax and rbx
    mov di, word [input + eax*2]            ; Load the first number into rdi
    mov si, word [input + ebx*2]            ; Load the second number into rsi
    mov word [input + eax*2], si            ; Swap the two numbers
    mov word [input + ebx*2], di            ; Swap the two numbers
    jmp _main_loop                          ; Jump to the main loop

_multiply:
    sscan2number command + 4, eax, ebx      ; Parse the indexes from the command and store them in rax and rbx
    mov ax, word [input + eax*2]            ; Load the first number into ax
    imul word [input + ebx*2]               ; Multiply the first number by the second number
    movsx rax, ax                           ; Sign-extend the result
    printnumber rax                         ; Print the result of the multiplication
    jmp _main_loop                          ; Jump to the main loop

_divide:
    sscan2number command + 4, eax, ebx      ; Parse the indexes from the command and store them in rax and rbx
    mov ax, word [input + eax*2]            ; Load the first number into rdi
    mov bx, word [input + ebx*2]            ; Load the second number into rsi
    movsx rax, ax                           ; Sign-extend the numbers
    movsx rbx, bx                           ; Sign-extend the numbers
    cmp rbx, 0                              ; Check if the second number is zero
    je _invalid                             ; Jump to the invalid label if the second number is zero
    cqo                                     ; Sign-extend rax into rdx:rax
    idiv rbx                                ; Divide the rdx:rax by the rbx
    safepush rdx                            ; Save the remainder
    printnumber rax                         ; Print the quotient
    safepop rdx                             ; Restore the remainder
    printnumber rdx                         ; Print the remainder
    jmp _main_loop                          ; Jump to the main loop
_invalid:
    lea rdi, [invalid_fmt]                  ; Load the address of the "Invalid division!" string into rdi
    call printf                             ; Print the error message
    jmp _main_loop                          ; Jump to the main loop

_msb_index:
    sscannumber command + 4, eax            ; Parse the index from the command and store it in rax
    bsr ax, word [input + eax*2]            ; Determine the index of the most significant bit
    movzx rax, ax                           ; Zero-extend the result
    printnumber rax                         ; Print the index of the most significant bit
    jmp _main_loop                          ; Jump to the main loop

_lsb_index:
    sscannumber command + 4, eax            ; Parse the index from the command and store it in rax
    bsf ax, word [input + eax*2]            ; Load the number into rdi
    movzx rax, ax                           ; Zero-extend the result
    printnumber rax                         ; Print the index of the least significant "one" bit
    jmp _main_loop                          ; Jump to the main loop

_overflow:
    sscan2number command + 9, eax, ebx      ; Parse the indexes from the command and store them in rax and rbx
    mov di, word [input + eax*2]            ; Load the first number into rdi
    mov si, word [input + ebx*2]            ; Load the second number into rsi
    add di, si                              ; Add the two numbers
    jo .overflow_yes                        ; Jump to the overflow_yes label if the result is not zero
    lea rdi, [no_format]                    ; Load the address of the "NO" string into rsi
    jmp .overflow_end
.overflow_yes:
    lea rdi, [yes_format]                   ; Load the address of the "YES" string into rsi
.overflow_end:
    call printf                             ; Print the result of the overflow check
    jmp _main_loop                          ; Jump to the main loop

_exit:
    leave 1

