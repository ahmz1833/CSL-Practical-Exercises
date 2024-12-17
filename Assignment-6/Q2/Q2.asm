# Assignment 6 - Practical Question 2; 402106434, 402106456

.macro read_int $dest
    li      $v0,    5
    syscall
    move    $dest,  $v0
.end_macro

.macro alloc %n, %addr
    li      $v0,    9
    move    $a0,    %n
    addi    $a0,    $a0,    1            # For \0 in destination string
    syscall
    move    %addr,  $v0
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

####################### End of Macros #########################

.text
.globl    main
main:
    read_int($s0)                        # Read n into $s0
    alloc($s0, $s1)                      # Allocate n+1 byte, put first addr in $s1
    
    move    $a0,    $s1
    move    $a1,    $s0
    li      $a2,    0
    jal     generate_binaries            # Call generate_binaries(first_allocated, n, 0)
    
    li      $v0,    10
    syscall                              # Exit Program

################## Generate Binaries Function ####################
##### generate_binaries(char* characters, int n, int index) ######
generate_binaries:
    push    $ra
    # Base of recurse
    beq     $a2,    $a1,    _print_bin   # if (index == n) then print the created number
    beqz    $a2,    _put_one             # if (index == 0) start creating the number by printing 1
    # Recurse step
    add     $t3,    $a0,    $a2          # $t3 = &characters[index]
    addi    $t3,    $t3,    -1           # $t3 = &characters[index-1]
    lb      $t4,    0($t3)               # $t4 = characters[index-1]
    li      $t5,    '1'                  # $t5 = '1'
    beq     $t4,    $t5,    _put_zero    # if (characters[index-1] == '1') print 0
_put_one:                                # _put_one: characters[index] = '1'
    li      $t0,    '1'
    add     $t1,    $a0,    $a2
    sb      $t0,    0($t1)
    # Call generate_binaries(characters, n, index+1)
    push    $a2
    addi    $a2,    $a2,    1
    jal     generate_binaries
    pop     $a2
_put_zero:                               # _put_one: characters[index] = '0'
    li      $t0,    '0'
    add     $t1,    $a0,    $a2
    sb      $t0,    0($t1)
    # Call generate_binaries(characters, n, index+1)
    push    $a2
    addi    $a2,    $a2,    1
    jal     generate_binaries
    pop     $a2
    j       _end_func
_print_bin:
    # Null Terminating the string
    li      $t0,    '\0'
    add     $t1,    $a0,    $a2
    sb      $t0,    0($t1)
    # Address already loaded in $a0
    li      $v0,    4
    syscall
    push    $a0                          # Saving $a0 (it will change for calling syscall)
    li      $a0,    '\n'
    li      $v0,    11
    syscall                              # Print \n at the end of str
    pop     $a0                          # Restore $a0 from stack
_end_func:
    pop     $ra
    jr      $ra
