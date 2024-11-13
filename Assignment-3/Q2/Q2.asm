.data
coef:
	.float	4
newline:
	.asciiz "\n"
root1:
	.asciiz "Root1: "
root2:
	.asciiz "Root2: "
.text
.globl main
main:

	li $v0, 6
	syscall
	mov.s $f2, $f0		#$f2 = a
	li $v0, 6
	syscall
	mov.s $f4, $f0		#$f4 = b
	li $v0, 6
	syscall
	mov.s $f6, $f0 		#$f6 = c
	mul.s $f8, $f4, $f4	#$f8 = b^2
	mul.s $f10, $f2, $f6	#$f10 = a*c
	l.s $f14, coef
	mul.s $f10, $f14, $f10	#$f8 = 4*a*c
	add.s $f2, $f2, $f2 	#$f2 = 2a
	
	sub.s $f8, $f8, $f10	#$f8 = delta = b^2 - 4ac
	sqrt.s $f8, $f8		#$f8 = rad(delta)
	neg.s $f4, $f4		#$f4 = -b
	add.s $f16, $f4, $f8
	div.s $f16, $f16, $f2
	sub.s $f18, $f4, $f8
	div.s $f18, $f18, $f2
	#output
	li $v0, 4
	la $a0, root1
	syscall
	mov.s $f12, $f16
	li $v0, 2
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, root2
	syscall
	mov.s $f12, $f18
	li $v0, 2
	syscall
