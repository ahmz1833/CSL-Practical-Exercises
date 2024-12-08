# Assignment 5 - Practical Question 6; 402106434, 402106456

.data
    .align 2
yes:.asciiz "YES\n"
    .align 2
no: .asciiz "NO\n"

.text
main:
    li   $v0, 5                     # syscall 5: read_int
    syscall

############## Calculate the sum of the digits of the input number raised to the number of digits ##############
####### Input: $v0 (the input number) Output: $t3 (the sum of the digits raised to the number of digits) #######
    li   $t0, 10                    # load 10 into $t0
    li   $t3, 0                     # load 0 into $t3
    move $t4, $v0                   # copy the input into $t4
_outer:
    div  $t4, $t0                   # divide the t4 by 10
    mfhi $t1                        # get the remainder into $t1 (t1 = t4 % 10)
    mflo $t4                        # get the quotient into $v0 (t4 = t4 / 10)
    li   $t2, 1                     # load 1 into $t2
    move $t5, $v0                   # copy the original input into $t5
_inner:                             # loop to calculate the digit^(number of digits)
    mul  $t2, $t2, $t1              # multiply the into $t2
    div  $t5, $t0                   # divide the t5 by 10
    mflo $t5                        # then: t5 /= 10
    bne  $t5, $0,  _inner           # if t5 is not 0, repeat the loop
_:
    add  $t3, $t3, $t2              # add the remainder into $t3
    bne  $t4, $0,  _outer           # if quotient is not 0, repeat the loop (with the next digit)

########################################### Print the result #####################################################
    bne  $t3, $v0,  _print_no       # if the sum of the digits is not equal to the original number, print NO
    li   $v0, 4                     # syscall 4: print_str
    la   $a0, yes                   # load the address of yes into $a0
    syscall
    j    exit                       # exit the program
_print_no:
    li   $v0, 4                     # syscall 4: print_str
    la   $a0, no                    # load the address of no into $a0
    syscall
exit:
    li   $v0, 10                    # syscall 10: exit
    syscall

