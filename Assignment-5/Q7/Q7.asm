# Assignment 5 - Practical Question 7; 402106434, 402106456
.data
coef1:	.space	404
coef2:	.space	404
result:	.space	808
message:	.asciiz	"This input represents "
message2:	.asciiz	" Output:\n"
.text

.macro	print_char,	$src
	move	$a0,	$src
	li	$v0,	11
	syscall
.end_macro
.macro	print_int,	$src
	move	$a0,	$src
	li	$v0,	1
	syscall

.end_macro

.macro read_int, $dest
	li	$v0,	5
	syscall
	move	$dest,	$v0
.end_macro


.macro	input,	$src,	$addr
	li	$t0,	-1
coef:
	read_int($t1)
	sw	$t1,	0($addr)
	addi	$addr,	$addr,	4
	subi	$src,	$src,	1
	bne	$src,	$t0,	coef	
.end_macro

.macro	print_polynomial,	$addr,	$deg
	lw	$t0,	0($addr)
cal:
	li	$t1,	' '
	print_char($t1)
	bgez 	$t0,	positive
	li	$t1,	-1
	beq	$t0,	$t1,	negative
	print_int($t0)
	j	x_print
negative:
	li	$t2,	'-'
	print_char($t2)
	j	x_print
positive:
	li	$t2,	'+'
	print_char($t2)
	li	$t1,	1
	beq	$t0,	$t1,	x_print
	print_int($t0)
x_print:
	beqz	$deg,	result
	li	$t2,	'x'
	print_char($t2)
	li	$t1,	1
	beq	$deg,	$t1, end_print
	li	$t2,	'^'
	print_char($t2)
	print_int($deg)
end_print:
	beqz	$deg,	result
	subi	$deg,	$deg,	1
	addi	$addr,	$addr,	4
	lw	$t0,	0($addr)
	bnez	$t0,	cal
	j	end_print
result:
	li	$t1,	1
	beq	$t0,	$t1,	print
	li	$t1,	-1
	beq	$t0,	$t1,	print
	j finish
print:
	li	$t1,	1
	print_int($t1)
finish:
.end_macro
.globl main
main:
	read_int($s0)
	move	$t8,	$s0
	la	$t9,	coef1
	input($t8, $t9)
	
	read_int($s1)
	move	$t8,	$s1
	la	$t9,	coef2
	input($t8, $t9)
	
	la	$a0,	message
	li	$v0,	4
	syscall
	li	$t8,	'('
	print_char($t8)
	la	$t8,	coef1
	move	$t9,	$s0
	print_polynomial($t8, $t9)
	li	$t8,	')'
	print_char($t8)
	li	$t8,	'('
	print_char($t8)
	la	$t8,	coef2
	move	$t9,	$s1
	print_polynomial($t8, $t9)
	li	$t8,	')'
	print_char($t8)
	la	$a0,	message2
	li	$v0,	4
	syscall
	
	la $t3, coef1
	la $t4, coef2
	la $t5, result

	move $t6, $zero          # i = 0
outer_loop:
	bgt $t6, $s0, done
	li $t7, 0                # j = 0

inner_loop:
	bgt $t7, $s1, end_inner
	mul $t8, $t6, 4 
	add $t9, $t3, $t8        # Address of coef1[i]
	lw $a0, 0($t9)
	mul $t8, $t7, 4
	add $t9, $t4, $t8        # Address of coef2[j]
	lw $a1, 0($t9)
	mul $a2, $a0, $a1        # coef1[i] * coef2[j]

	# Add to result[i+j]
	add $t8, $t6, $t7
	mul $t8, $t8, 4
	add $t9, $t5, $t8        # Address of result[i+j]
	lw $a3, 0($t9)
	add $a3, $a3, $a2
	sw $a3, 0($t9)           # result[i + j] = result[i + j] + coef[i] * coef[j]

	addi $t7, $t7, 1
	j inner_loop
end_inner:
	addi $t6, $t6, 1
	j outer_loop
done:
	add	$s2,	$s1,	$s0
	print_polynomial($t5, $s2)