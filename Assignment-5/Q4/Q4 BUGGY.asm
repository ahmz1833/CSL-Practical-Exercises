# Assignment 5 - Practical Question 1; 402106434, 402106456

.macro print_int %src
    move  $a0,    %src
    li    $v0,    1
    syscall
.end_macro

.macro print_char %src
    move  $a0,    %src
    li    $v0,    11
    syscall
.end_macro

.macro read_int %dest
    li    $v0,    5
    syscall
    move  %dest,  $v0
.end_macro

.macro input_array %n, %addr
_input_loop:
    read_int($t9)
    sw    $t9,    0(%addr)
    addi  %addr,  %addr,    4
    addi  %n,     %n,      -1
    bnez  %n,     _input_loop
.end_macro

.macro print_array %n, %addr
_print_loop:
    lw    $t9,    0(%addr)
    print_int($t9)
    li    $t8,    ' '
    print_char($t8)
    addi  %addr,  %addr,    4
    addi  %n,     %n,      -1
    bnez  %n,     _print_loop
.end_macro

.macro alloc %n, %size
	li    $v0,    9
	move  $a0,    %n
	sll   $a0,    $a0,     %size
	syscall
.end_macro

################## End of Macros ###################

.text
main:
	read_int($s0)                    # Read n
    alloc   $s0,    2                # Allocate space for array
	move    $s1,    $v0              # $s1 = address of arr
    input_array($s0, $s1)            # Input array
    
	# Bubble Sort
	move    $t0,    $v0              # $t0 = address of arr
	move    $t1,    $s0              # $t1 = n (t1 is i)
outer_loop:
	subi    $t1,    $t1,    1        # i--
	blez    $t1,    done             # if i <= 0, done
	move    $t2,    $t1              # $t2 = i (t2 is j)
	li      $t3,    0                # j = 0
inner_loop:
	add     $t4,    $t0,    $t3     
	lw      $t5,    0($t4)           # array[j]
	lw      $t6,    4($t4)           # array[j+1]    
	ble     $t5,    $t6,    no_swap  # if array[j] <= array[j+1] -> no swap
	# swap
	sw      $t6,    0($t4)           # array[j] = array[j+1]
	sw      $t5,    4($t4)           # array[j+1] = array[j]
no_swap:
	addi    $t3,    $t3,    4        # j++
	subi    $t2,    $t2     1        # i--
	bgtz    $t2,    inner_loop       # if j > 0, inner_loop
	j       outer_loop               # outer_loop

done:
	print_array($s0, $s1)
