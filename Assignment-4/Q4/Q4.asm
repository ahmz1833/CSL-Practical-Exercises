# Assignment 4 - Practical Question 4; 402106434, 402106456

.data
input:          .word   -1
shift_amount:   .word   3
.text
.globl  main
main:
    lw      $s0,    input
    lw      $a0,    shift_amount

    # li $a0, 3   # for work as sra  (constant shift amount)

    ####### Start of srav logic (input in $s0, shift amount in $a0) #######
    srl     $t0,    $s0,    31        # get the sign bit
    beqz    $t0,    pos               # if sign bit is 0, jump to pos (just shift right logical)
    xori    $s0,    $s0,    -1        # if sign bit is 1, invert the bits,
    srlv    $v0,    $s0,    $a0       # then shift right logical
    xori    $v0,    $v0,    -1        # then invert the bits again
    j       exit                      # ok! done
pos:
    srlv    $v0,    $s0,    $a0       # shift right logical
exit:
    ################### End of Logic (result in $v0) #####################

    move    $a0,    $v0
    li      $v0,    34                     # print hex
    syscall
