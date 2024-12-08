# Assignment 5 - Practical Question 2; 402106434, 402106456

.text
main:
    # Read (a) into $a0
	li      $v0,    5
	syscall
	move    $a0,    $v0

    # Read (b) into $a1
	li      $v0,    5
	syscall
	move    $a1,    $v0

    jal power            # Call the power function

    # Print the result
    move   $a0,    $v0
    li     $v0,    1
    syscall

    # Exit
    j      exit

########################## Function power ############################

power:
    addi   $sp,    $sp,    -12
    sw     $ra,    0($sp)
    sw     $s0,    4($sp)
    sw     $s1,    8($sp)
    beq    $a1,    $0,     _power_base  # if a1 == 0, return 1
    # we should return power(a0, a1/2)^2 * ((a1 % 2) ? a0 : 1)
    and    $s0,    $a1,    1            # s0 = a1 % 2  
    srl    $s1,    $a1,    1            # s1 = a1 / 2
    move   $a1,    $s1                  # set second argument to a1/2
    jal    power                        # call power(a0, a1/2)
    mul    $v0,    $v0,    $v0          # v0 = power(a0, a1/2)^2
    beq    $s0,    $0,     _power_end   # if a1 % 2 == 0, return v0
    mul    $v0,    $v0,    $a0          # v0 = v0 * a0
    j      _power_end                   # return v0
_power_base:
    li     $v0,    1                    # v0 = 1
    j      _power_end                   # return 1
_power_end:
    lw     $ra,    0($sp)
    lw     $s0,    4($sp)
    lw     $s1,    8($sp)
    addi   $sp,    $sp,    12
    jr     $ra

###############################################################
exit:
    li     $v0,    10
    syscall