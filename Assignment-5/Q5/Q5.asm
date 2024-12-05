# Assignment 5 - Practical Question 5; 402106434, 402106456
.data
N: .word 3               
M: .word 2               
P: .word 4
A: .word 1, 2, 3, 4, 5, 6
B: .word 8, 7, 6, 5, 4, 3, 2, 1

.text
.macro	printInt, $src
	move $a0, $src
	li $v0, 1
	syscall
.end_macro
.macro	printSpace
	li $a0, ' '
	li $v0, 11
	syscall
.end_macro
.macro	printNewline
	li $a0, '\n'
	li $v0, 11
	syscall
.end_macro
.macro	printMatrix, $addr
	move $s3, $s2
	move $s0, $zero
outerLoop:
	beq $s0, $t0, finish
	move $s1, $zero
innerLoop:
	beq $s1, $t2, end_inner
	lw $s5, 0($s3)
	printInt($s5)
	printSpace
	addi $s3, $s3, 4
	addi $s1, $s1, 1
	j innerLoop
end_inner:
	addi $s0, $s0, 1
	printNewline
	j outerLoop
finish:
.end_macro
.globl main
main:
	lw $t0, N
	lw $t1, M
	lw $t2, P
	la $s0, A
	la $s1, B
	# allocate memory
	mul $a0, $t0, $t2
	sll $a0, $a0, 2
	li $v0, 9
	syscall
	move $s2, $v0	# $s2 = Address of allocated memory
	move $s3, $s2	# copy of $s2
	# calculating result
	li $t3, 0	# i = 0
row_A:
	beq $t3, $t0, end
	move $t4, $zero	# j = 0
	mul $t5, $t3, $t1	# beginning index of row i of A
column_B:
	beq $t4, $t2, end_row
	move $t6, $zero	# k = 0
	li $t7, 0	# element = 0
	# A[i] . B[j]
calculateElement:
	beq $t6, $t1, storeElement
	# A[i][k] * B[k][j]
cross:
	mul $t8, $t6, $t2	# $t8 = k * p
	add $t9, $t8, $t4	# $t9 = k * p + j
	sll $t9, $t9, 2
	add $t8, $t5, $t6	# $t8 = i * M + k
	sll $t8, $t8, 2
	lw $s4, A($t8)		# A[i][k]
	lw $s5, B($t9)		# B[k][j]
	mul $s6, $s5, $s4
	add $t7, $t7, $s6	
	addi $t6, $t6, 1
	j calculateElement
storeElement:
	sw $t7, 0($s3)
	addi $s3, $s3, 4
	addi $t4, $t4, 1
	j column_B
end_row:
	addi $t3, $t3, 1
	j row_A
end:
	printMatrix($s2)
	li $v0, 10
   	syscall
