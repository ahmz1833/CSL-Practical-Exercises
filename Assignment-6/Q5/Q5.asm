#Assignment-6 Q5 - 402106434 - 402106456
.data
palindrome:	.asciiz	" is a palindrome\n"
not_pal:	.asciiz	" is not a palindrome\n"
input:		.space	4

.text
.globl	main
main:
	li	$v0,	5
	syscall
	sw	$v0,	input
	move	$a0,	$v0
	jal	is_palindrome
	
	move	$t0,	$v0
	lw	$a0,	input
	li	$v0,	1
	syscall
	
	beqz	$t0,	print_not_palin
	la	$a0,	palindrome
	li	$v0,	4
	syscall
	j	end_program
print_not_palin:
	la	$a0,	not_pal
	li	$v0,	4
	syscall	
end_program:
	li	$v0,	10
	syscall
	
	
################## Is_palindrome Function ####################
is_palindrome:
	addi	$sp,	$sp,	-8
	sw	$a0,	0($sp)
	sw	$ra,	4($sp)
	bgez	$a0,	continue
	li	$v0,	0
	addi	$sp,	$sp,	8
	jr	$ra
continue:
	jal	countdigits
	lw	$a0,	0($sp)
	lw	$ra,	4($sp)	
	move	$a1,	$v0
	jal	checkPalin
	lw	$a0,	0($sp)
	lw	$ra,	4($sp)
	addi	$sp,	$sp,	8
	jr	$ra
	
################## CountDigits Function ####################
countdigits:
	addi	$sp,	$sp,	-8
	sw	$a0,	0($sp)
	sw	$ra,	4($sp)
	li	$v0,	0
countloop:
	beqz	$a0,	endCounting
	div	$a0,	$a0,	10
	add	$v0,	$v0,	1
	j	countloop
	lw	$a0,	0($sp)
	lw	$ra,	4($sp)
endCounting:
	addi	$sp,	$sp,	8
	jr	$ra

################## CheckPalin Function ####################

checkPalin:
	addi	$sp,	$sp,	-12
	sw	$a0,	0($sp)
	sw	$a1,	4($sp)
	sw	$ra,	8($sp)
	blt	$a0,	10,	base
	li	$t0,	1		# used to get last digit
	sub	$a1,	$a1,	1
compute_power:
	# t0 = 10 ^ (digit - 1)
	mul	$t0,	$t0,	10
	sub	$a1,	$a1,	1
	bnez	$a1,	compute_power
	
	lw	$a1,	4($sp)
	div	$t1,	$a0,	$t0	# last digit
	rem	$t2,	$a0,	10	# first digit
	bne	$t1,	$t2,	notPalin
	
	rem	$a0,	$a0,	$t0	# remove last digit
	div	$a0,	$a0,	10	# remove first digit
	addi	$a1,	$a1,	-2	# 2 digit less
	
	jal	checkPalin
	j	end_check
base:
	li	$v0,	1
	j end_check
notPalin:
	li	$v0,	0
	j end_check
end_check:
	lw	$a0,	0($sp)
	lw	$a0,	4($sp)
	lw	$ra,	8($sp)	
	addi	$sp,	$sp,	12
	jr	$ra
