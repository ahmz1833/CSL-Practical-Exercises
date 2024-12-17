# Assignment 6 - Practical Question 3; 402106434, 402106456

.macro read_int %dest
    li      $v0,    5
    syscall
    move    %dest,  $v0
.end_macro

.macro print_int %src
    move    $a0,    %src
    li      $v0,    1
    syscall
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
.text
.globl main

main:
    read_int($a0)
    read_int($a1)
    read_int($a2)
    jal     tak                          # Call tak(input(), input(), input())
    print_int($v0)
    li      $v0,    10                   # Exit
    syscall

################## Tak Function: tak(x:$a0, y:$a1, z:$a2) ####################

tak:
    blez    $a0,    _xLZ                 # if x <= 0: goto _xLZ
    blez    $a1,    _yLZ                 # elif y <= 0: goto _yLZ
    j       _tak
_xLZ:
    move    $v0,    $a1
    jr      $ra                          # return y
_yLZ:
    move    $v0,    $a2
    jr      $ra                          # return z
_tak:
    push    $ra
    push    $s0
    push    $s1
    blez    $a2,    _zLZ                 # if z <= 0: goto _zLZ
    # Else; if x,y,z > 0
    # We Want to Calculate tak(x-1, tak(y-1, z, x), tak(y, z-1, x))
    push    $a2                          # push z
    push    $a1                          # push y
    push    $a0                          # push x
    # Calculate $s0 := tak(y-1, z, x)
    move    $t0,    $a2                  # Temp: $t0 = z
    move    $a2,    $a0                  # $a2 = x
    addi    $a0,    $a1,    -1           # $a0 = y-1
    move    $a1,    $t0                  # $a1 = z
    jal     tak                          # $v0 = tak(y-1, z, x)
    move    $s0,    $v0                  # Save into $s0
    # Calculate $s1 := tak(y, z-1, x)
    addi    $a0,    $a0,    1            # Change y-1 into y (for 1st arg)
    addi    $a1,    $a1,    -1           # Change z into z-1 (for 2nd arg)
    jal     tak                          # $v0 = tak(y, z-1, x)
    move    $s1,    $v0                  # Save into $s1
    # Calculate $v0 := tak(x-1, $s0, $s1)
    peek    $a0                          # Peek Stack (x) into $a0
    addi    $a0,    $a0,    -1           # $a0 = x-1
    move    $a1,    $s0                  # $a1 = $s0
    move    $a2,    $s1                  # $a2 = $s1
    jal     tak                          # $v0 = tak(x-1, $s0, $s1)
    pop     $a0                          # pop x
    pop     $a1                          # pop y
    pop     $a2                          # pop z
    j       _end_func                    # return
_zLZ:
    push    $a0                          # Push $a0 into stack
    push    $a1                          # Push $a1 into stack
    addi    $a0,    $a0,    -1
    addi    $a1,    $a1,    -1
    jal     tak                          # $v0 = tak(x - 1, y - 1, z)
    pop     $a1                          # Pop $a1 from stack
    pop     $a0                          # Pop $a0 from stack
_end_func:
    pop     $s1
    pop     $s0
    pop     $ra
    jr      $ra
