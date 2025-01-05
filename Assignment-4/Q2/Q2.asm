# Assignment 4 - Practical Question 2; 402106434, 402106456

.macro  read_int %dest
    li      $v0,    5
    syscall
    move    %dest,  $v0
.end_macro

.macro  print_int %input
    move    $a0,    %input
    li      $v0,    1
    syscall
.end_macro

.macro print_char %reg
    li      $v0,        11
    move    $a0,        %reg
    syscall
.end_macro

.macro  print_newline
    li      $v0,    11                 # syscall 11: print_character
    li      $a0,    '\n'
    syscall                            # print $zero
.end_macro

.macro  print_space
    li      $v0,    11
    li      $a0,    ' '
    syscall
.end_macro

    ### Swapping 2 numbers using xor, $t3 to check if swap is needed
.macro  swap %src1, %src2
    sub     $t3,    %src1,  %src2
    sra     $t3,    $t3,    31         #$t3 is -1 if it is negative, else 0
    xor     $t4,    %src1,  %src2
    and     $t4,    $t4,    $t3
    xor     %src1,  %src1,  $t4
    xor     %src2,  %src2,  $t4
.end_macro

.macro  print_bin_digit %reg, %idx
    srl     $t9,    %reg,   %idx
    and     $t9,    $t9,    1
    add     $t9,    $t9,    '0'
    print_char $t9
.end_macro

.macro  print_bin_rev %reg
    print_bin_digit %reg,   0
    print_bin_digit %reg,   1
    print_bin_digit %reg,   2
    print_bin_digit %reg,   3
    print_bin_digit %reg,   4
    print_bin_digit %reg,   5
.end_macro

.text
.globl  main
main:
    read_int($t0)
    read_int($t1)
    read_int($t2)
    swap($t0, $t1)
    swap($t1, $t2)
    swap($t0, $t1)
    print_int($t0)
    print_space
    print_int($t1)
    print_space
    print_int($t2)
    print_space
    print_newline
    print_bin_rev($t0)
    print_space
    print_bin_rev($t1)
    print_space
    print_bin_rev($t2)
