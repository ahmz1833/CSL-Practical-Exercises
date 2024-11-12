.data
num1:
	.word 68
num2:
	.word 35
max_value:
	.word 0
.text
.globl main
main:
	la $t0, num1
	lw $t0, 0($t0)
	la $t1, num2
	lw $t1, 0($t1)
	sub $t0, $t0, $t1
	srl $t0, $t0, 31	#$t0 = sign bit of num1 - num2
	mult $t1, $t0
	mflo $s0		#$s0 = sign * num2
	subi $t0, $t0, 1
	neg $t0, $t0		#$t0 = 1 - sign
	la $t2, num1
	lw $t2, 0($t2)
	mult $t2, $t0
	mflo $s1		#$s1 = (1 - sign) * num1
	la $t3, max_value
	add $s2, $s1, $s0
	sw $s2, 0($t3)		#max_value = max(num1, num2)
	
	lw $a0, 0($t3)
	li $v0 1
	syscall
	
	
		