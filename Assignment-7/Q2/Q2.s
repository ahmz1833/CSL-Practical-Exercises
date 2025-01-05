;==============================================
    ; Assignment 7 - Question 2
    ; Description: Find the longest substring without repeating characters
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
    visit_index dq 26 dup(-1)

section .text
global main
extern printf
extern scanf

main:
    enter 2                         ; 32 bytes local variables (3 pointers, 1 space for 16 bytes alignment)

    lea rdi, [scan_format]          ;|
    lea rsi, [buffer]               ;| 
    mov rax, 0                      ;|
    call scanf                      ;| scanf("%s", buffer)

    lea rcx, [buffer]               ; current pointer (rcx)
    mov [rsp], rcx                  ; ptr1 : [rsp]
    mov [rsp + 8], rcx              ; ptr2 : [rsp + 8]
    mov [rsp + 16], rcx             ; ptr3 : [rsp + 16]

_loop:
    movzx rax, byte [rcx]           ; current char (read byte and zero extend to rax)
    cmp rax, 'a'                    ;|
    jl _case_upper                  ;| if current char < 'a', it's upper case
    sub rax, 'a' - 'A'              ;| convert to upper case
_case_upper:
    sub rax, 'A'                    ; rax = current char alphabet index
    mov rbx, [visit_index + rax*8]  ; rbx = visit_index[curr char]
    cmp rbx, [rsp + 8]              ; compare visit_index[curr char] with ptr2
    jl _case_not_repeat             ; if visit_index[curr char] < ptr2, it's not repeat
    ; now we have repeat char
    ; check if ptr2->current is the longest ?
    mov rdx, rcx                    ; rdx = current
    sub rdx, [rsp + 8]              ; rdx = current - ptr2
    mov rdi, [rsp + 16]             ; rdi = ptr3
    sub rdi, [rsp]                  ; rdi = ptr3 - ptr1
    cmp rdx, rdi                    ; compare current - ptr2 with ptr3 - ptr1
    jle _small_interval             ; if current - ptr2 <= ptr3 - ptr1, go to small_interval
    ; if current - ptr2 > ptr3 - ptr1 , update ptr1 and ptr3
    mov rdx, [rsp + 8]              ; rdx = ptr2
    mov [rsp], rdx                  ; ptr1 = ptr2
    mov [rsp + 16], rcx             ; ptr3 = current
_small_interval:
    mov [rsp + 8], rbx              ; ptr2 = visit_index[curr char]
    add qword [rsp + 8], 1          ; ptr2 = visit_index[curr char] + 1
_case_not_repeat:
    mov [visit_index + rax*8], rcx  ; visit_index[curr char] = current
    add rcx, 1                      ; rcx+ (current++)
    cmp byte [rcx], 0               ; check if current is null
    jnz _loop                       ; if not null, loop
    ; check if ptr2->end is the longest ?
    sub rcx, [rsp + 8]              ; rcx = end - ptr2
    mov rdx, [rsp + 16]             ; rdx = ptr3
    sub rdx, [rsp]                  ; rdx = ptr3 - ptr1
	mov rsi, [rsp + 8]              ; rsi = ptr2 (assuming ptr2->end is the longest, so we want to print it)
    cmp rcx, rdx                    ; compare ptr2->end with ptr1->ptr3
	; Here we have 2 options,
	; if using jg, we print the first longest substring
	; if using jge, we print the last longest substring
    jg _print_result               ; if end - ptr2 > ptr3 - ptr1, print result 
	; if end - ptr2 < ptr3 - ptr1, null terminate buffer at ptr3 and set rsi to ptr1
	mov rdx, [rsp + 16]             ; rdx = ptr3
	mov byte [rdx], 0               ; set [ptr3] to \0 (end of string)
	mov rsi, [rsp]                  ; rsi = ptr1
_print_result:
    lea rdi, [print_format]         ;|
    call printf                     ;| printf("%s\n", result)

    leave 2
