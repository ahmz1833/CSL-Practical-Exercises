#Assignment-6 Q3 - 402106434 - 402106456
.macro read_int $dest
	li    $v0,    5
	syscall
	move  $dest,  $v0
.end_macro

################## End of Macros ###################
.data
.align	0
.text
.globl	main
main:
	read_int($s0)
	move	$a0,	$s0
	addi	$a0,	$a0,	1
	li	$v0,	9
	syscall
	move	$s1,	$v0	# allocated number of characters needed
	
	move	$a0,	$s1
	move	$a1,	$s0
	li	$a2,	0		# index
	jal	generate_binaries	# generate_binaries(char* characters, int n, int index)
	
	li	$v0,	10
	syscall
################## Generate Binaries Function ####################
generate_binaries:
	addi	$sp,	$sp,	-16
	sw	$ra,	0($sp)
	sw	$a0,	4($sp)
	sw	$a1,	8($sp)
	sw	$a2,	12($sp)
	
	beq	$a2,	$a1,	print_binary	# index == n then print the created number
	beqz	$a2,	print_one		# start creating the number by printing 1
	
	add	$t3,	$a0,	$a2
	addi	$t3,	$t3,	-1
	lb	$t4,	0($t3)
	li	$t5,	'1'
	beq	$t4,	$t5,	print_zero	# if last index was 1, print 0
	
print_one:
	li	$t0,	'1'
	add	$t1,	$a0,	$a2
	sb	$t0,	0($t1)
	addi	$a2,	$a2,	1
	jal	generate_binaries
	
	lw	$a2,	12($sp)
	
print_zero:
	li	$t0,	'0'
	add	$t1,	$a0,	$a2
	sb	$t0,	0($t1)
	addi	$a2,	$a2,	1
	jal	generate_binaries
	
	lw	$a2,	12($sp)
	j	end_func
	
print_binary:
	li	$t0,	'\0'
	add	$t1,	$a0,	$a2
	sb	$t0,	0($t1)
	
	li	$v0,	4
	syscall
	
	li	$a0,	'\n'
	li	$v0,	11
	syscall
	lw	$a0,	4($sp)

end_func:
	
	lw	$ra,	0($sp)
	lw	$a0,	4($sp)
	lw	$a1,	8($sp)
	lw	$a2,	12($sp)
	addi	$sp,	$sp,	16
	jr	$ra
