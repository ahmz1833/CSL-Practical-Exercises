.data
rel_prime_count:	.word	0     # Counter for relatively prime pairs
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
.globl	main
main:
	read_int($s0)
	move	$a0,	$s0
	sll	$a0,	$a0,	2
	li	$v0,	9
	syscall
	move	$s1,	$v0
	move	$t2,	$s0
	move	$t3,	$s1
	input($t2, $t3)
	
	
	li	$t0,	0	# $t0 = prime pairs
	li	$t1,	0	# i = 0
outer_loop:
	beq	$t1,	$s0,	end_outer

	add	$t2,	$t1,	1	# j = i + 1
inner_loop:
	beq	$t2,	$s0,	end_inner
	mul	$t3,	$t1,	4
	add	$t3,	$t3,	$s1	# $t3 = arr + i
	lw	$a0,	0($t3)		# $a0 = arr[i]

	mul	$t4,	$t2,	4
 	add	$t4,	$t4,	$s1	# $t4 =  arr + j
	lw	$a1,	0($t4)		# $a1 = a[j]
	jal	gcd
	li	$t5,	1
	beq	$v0,	$t5,	increment_count
	
	j	skip_increment
increment_count:
	addi	$t0,	$t0,	1	# Increment counter for relatively prime pairs

skip_increment:
	addi	$t2,	$t2,	1	# j++
	j	inner_loop
end_inner:
	addi	$t1,	$t1,	1	# i++
	j	outer_loop
end_outer:

	sw	$t0,	rel_prime_count
	print_int($t0)

	li $v0, 10
	syscall


gcd:
gcd_loop:
	beq	$a1,	$zero,	gcd_done
	move	$t6,	$a1
	rem	$a1,	$a0,	$a1		# y = x % y
	move	$a0,	$t6			# x = $t6 (old y)
	j	gcd_loop
gcd_done:
	move	$v0,	$a0
	jr	$ra