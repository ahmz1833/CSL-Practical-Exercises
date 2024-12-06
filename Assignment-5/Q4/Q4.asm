.data
array:	.space	800
result:	.space	800
.text
.macro	print_int,	$src
	move	$a0,	$src
	li	$v0,	1
	syscall

.end_macro

.macro	print_char,	$src
	move	$a0,	$src
	li	$v0,	11
	syscall
.end_macro

.macro	input,	$src,	$addr
coef:
	read_int($t0)
	sw	$t0,	0($addr)
	addi	$addr,	$addr,	4
	subi	$src,	$src,	1
	bnez	$src,	coef	
.end_macro

.macro	read_int, $dest
	li	$v0,	5
	syscall
	move	$dest,	$v0
.end_macro

.macro	print_array,	$size,	$addr
print:
	lw	$t2,	0($addr)
	print_int($t2)
	li	$t3,	' '
	print_char($t3)
	addi	$addr,	$addr,	4
	subi	$size,	$size,	1
	bnez	$size,	print
.end_macro
.globl main
main:
	read_int($s0)
	la	$t2,	array
	move	$t1,	$s0
	input($t1, $t2)
	
	la	$t0,	array
	move	$t1,	$s0	# i = n
outer_loop:
	subi	$t1,	$t1,	1
	blez	$t1,	done
    
	move	$t2,	$t1

	li   $t3, 0	# j = 0
    
inner_loop:
	add  $t4, $t0, $t3     
	lw   $t5, 0($t4)       # array[j]
	lw   $t6, 4($t4)       # array[j+1]
    
	ble  $t5, $t6, no_swap # array[j] <= array[j+1] -> no swap
    
	# swap
	sw   $t6, 0($t4)
	sw   $t5, 4($t4)
    
no_swap:
	addi	$t3,	$t3,	4       # j++
	subi	$t2,	$t2,	1
	bgtz	$t2,	inner_loop
    
	j	outer_loop

done:
	la	$t0,	array
	print_array($s0, $t0)
	
	