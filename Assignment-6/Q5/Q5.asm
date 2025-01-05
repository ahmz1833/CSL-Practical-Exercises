# Assignment 6 - Practical Question 5; 402106434, 402106456

# Uses $t9 temp register
.macro digit_cnt %rd %rs
    li      %rd,    1
    move    $t9,    %rs
_cnt_loop:
    div     $t9,    $t9,    10
    beqz    $t9,    _cnt_end
    add     %rd,    %rd,    1
    j       _cnt_loop
_cnt_end:
.end_macro

.macro push %rs
    addi    $sp,    $sp,    -4
    sw      %rs,    0($sp)
.end_macro

.macro peek %rd
    lw      %rd,    0($sp)
.end_macro

.macro pop  %rd
    peek    %rd
    addi    $sp,    $sp,    4
.end_macro

################## End of Macros ###################

.data
palindrome: .asciiz    " is a palindrome\n"
not_pal:    .asciiz    " is not a palindrome\n"
.text
.globl    main
main:
    li      $v0,    5
    syscall                              # Scan input
    move    $s0,    $v0                  # Store into $s0
    move    $a0,    $s0                  # set argument 0 to input
    digit_cnt       $a1,    $a0          # set $a1 to digit count of $a0
    jal     check_palin                  # call check_palin(x)
    # Printing "%d is/is not a palindrome"
    move    $t0,    $v0                  # set $t0 to CheckPalidrome result
    move    $a0,    $s0
    li      $v0,    1
    syscall                              # Printing %d ($s0)
    beqz    $t0,    print_not_palin      # If not palindrome, goto print_not_palin
    la      $a0,    palindrome
    li      $v0,    4
    syscall                              # Printing palindrome text
    j       end_program
print_not_palin:
    la      $a0,    not_pal
    li      $v0,    4
    syscall                              # Printing not palindrome text
end_program:
    li      $v0,    10
    syscall                              # Exit
    
################## CheckPalin Function ####################
########## check_palin($a0: input, $a1: digits) ##########
check_palin:
    bge     $a0,    10,     _cpalin      # If not base, goto _cpalin
    li      $v0,    1
    jr      $ra                          # Base : return 1
_cpalin:
    push    $ra
    # Calculating $t0 = 10 ^ (digit - 1)
    li      $t0,    1
    sub     $t1,    $a1,    1
_cpalin_pow:
    mul     $t0,    $t0,    10
    sub     $t1,    $t1,    1
    bnez    $t1,    _cpalin_pow
    # Now, $t0 is 10 ^ (digit-1)
    div     $t1,    $a0,    $t0          # The most significant digit now is in $t1
    mfhi    $a0                          # Remove most significant digit from $a0
    div     $a0,    $a0,    10           # Remove least significant digit from $a0
    mfhi    $t2                          # The least significant digit now is in $t2
    beq     $t1,    $t2,    _recurse     # If $t1 == $t2, check recurse
    li      $v0,    0
    j       _cpalin_end                  # Else, return 0;
_recurse:
    addi    $a1,    $a1,   -2            # 2 digit removed.
    jal  check_palin                     # return recursive check_palin(input_MSD_LSD_removed,  digit - 2)
_cpalin_end: 
    pop     $ra
    jr      $ra
