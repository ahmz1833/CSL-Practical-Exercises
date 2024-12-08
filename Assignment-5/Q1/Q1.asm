# Assignment 5 - Practical Question 1; 402106434, 402106456

.data
command:     .space  4       # variable to store the command
stack_ptr:   .word   0       # pointer to the top of the stack
.text

main_loop:
    li     $v0,  8          # syscall 8: read_string
    la     $a0,  command    # load address of command into a0
    li     $a1,  4
    syscall                 # read variable bytes into command
    jal    execute_command  # jump to execute_command
    j      main_loop

####################### Execute Command Function #######################

execute_command:
    addi $sp, $sp, -8       # allocate space for 2 registers
    sw   $ra, 4($sp)        # store the return address
    sw   $s0, 0($sp)        # store the value to be pushed

    lw   $t0, 0($a0)        # load the first 4 bytes of command into t1
    li   $t1, 0x00687370    # "psh" in hex
    beq  $t0, $t1, _psh     # if the command is "psh" jump to psh
    li   $t1, 0x00706F70    # "pop" in hex
    beq  $t0, $t1, _pop     # if the command is "mul" jump to mul
    li   $t1, 0x00646461    # "add" in hex
    beq  $t0, $t1, _add     # if the command is "pop" jump to pop
    li   $t1, 0x00627573    # "sub" in hex
    beq  $t0, $t1, _sub     # if the command is "sub" jump to sub
    li   $t1, 0x006C756D    # "mul" in hex
    beq  $t0, $t1, _mul     # if the command is "add" jump to add
    li   $t1, 0x00747865    # "ext" in hex
    beq  $t0, $t1, _ext     # if the command is "ext" jump to ext
    li   $v0, 127           # error code for invalid command
    j    exec_command_end   # jump to exec_command_end
_psh:
    li   $v0, 5             # syscall 5: read_int
    syscall
    move $a0, $v0           # read into $a0  (pushed value)
    jal  push               # call push
    j    exec_command_end
_pop:
    jal  pop                # call pop
    move $a0, $v0           # move the popped value to $a0
    li   $v0, 1             # syscall 1: print_int
    syscall
    li   $v0, 11            # syscall 11: print_character
    li   $a0, '\n'          # print newline
    syscall
    li   $v0, 0             # return 0
    j    exec_command_end
_add:
    # pop 2 values from stack and push the sum
    jal  pop                # pop 1st value into $v0
    move $s0, $v0           # store the popped value in $s0
    jal  pop                # pop 2nd value into $v0
    add  $a0, $s0, $v0      # add the 2 values into $a0
    jal  push               # call push (push $a0)
    j    exec_command_end
_sub:
    # pop 2 values from stack and push the difference
    jal  pop                # pop 1st value into $v0
    move $s0, $v0           # store the popped value in $s0
    jal  pop                # pop 2nd value into $v0
    sub  $a0, $v0, $s0      # subtract the 2 values into $a0
    jal  push               # call push (push $a0)
    j    exec_command_end
_mul:
    # pop 2 values from stack and push the product
    jal  pop                # pop 1st value into $v0
    move $s0, $v0           # store the popped value in $s0
    jal  pop                # pop 2nd value into $v0
    mul  $a0, $s0, $v0      # multiply the 2 values into $a0
    jal  push               # call push (push $a0)
    j    exec_command_end
_ext:
    li	 $v0, 10            # syscall 10: exit
    syscall
exec_command_end:
    lw   $ra, 4($sp)        # restore the return address
    lw   $s0, 0($sp)        # restore the value to be pushed
    addi $sp, $sp, 8        # deallocate space for 2 registers
    jr   $ra                # return from funtion

####################### Push Function #######################

push:
    move $t0, $a0           # move the value to be pushed to $t0
    li   $v0, 9             # syscall 9: sbrk
    li   $a0, 8             # allocate 8 bytes
    syscall
    lw   $t1, stack_ptr($0) # load the last stack pointer
    sw   $v0, stack_ptr($0) # store the new stack pointer
    sw   $t1, 0($v0)        # store the last - 1 value to the new stack
    sw   $t0, 4($v0)        # store the value to be pushed to the new stack
    li   $v0, 0             # return 0
    jr   $ra                # return from function

####################### Pop Function #######################

pop:
    lw   $t0, stack_ptr($0) # load the stack pointer
    li   $v0, 0             # return 0 if the stack is empty
    beqz $t0, _pop_end      # if the stack is empty, return
    lw   $v0, 4($t0)        # load the last value from the stack
    lw   $t1, 0($t0)        # load the last - 1 address from the stack
    sw   $t1, stack_ptr($0) # store the last - 1 value to the stack_ptr
_pop_end:
    jr   $ra                # return from function