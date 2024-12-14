#Assignment-6 Q3 - 402106434 - 402106456
.macro read_int $dest
	li    $v0,    5
	syscall
	move  $dest,  $v0
.end_macro
.macro print_int $src
	move	$a0,	$src
	li	$v0,	1
	syscall
.end_macro

################## End of Macros ###################
.text
.globl main

main:
	read_int($s0)
	read_int($s1)
	read_int($s2)
	move	$a0,	$s0
	move	$a1,	$s1
	move	$a2,	$s2
	
	jal	tak
	print_int($v0)
	li	$v0,	10
	syscall
	
################## Tak Function ####################
	
tak:
	addi	$sp,	$sp,	-16
	sw	$ra,	0($sp)
	sw	$a0,	4($sp)
	move	$t0,	$a0
	sw	$a1,	8($sp)
	move	$t1,	$a1
	sw	$a2,	12($sp)
	move	$t2,	$a2
	
	
	blez	$a0,	xLZ	# if x <= 0
	blez	$a1,	yLZ	# elif y <= 0
	blez	$a2,	zLZ	# elif z <=0
	
	# else
	lw	$t0,	4($sp)
	lw	$t1,	8($sp)
	lw	$t2,	12($sp)
	move	$a0,	$t1		# a0 = y
	addi	$a1,	$t2,	-1	# a1 = z - 1
	move	$a2,	$t0		# a2 = x
	jal	tak
	move	$t3,	$v0		# a2 = tak(y, z - 1, x)
	
	lw	$t0,	4($sp)
	lw	$t1,	8($sp)
	lw	$t2,	12($sp)
	addi	$a0,	$t1,	-1	# a0 = y - 1
	move	$a1,	$t2		# a1 = z
	move	$a2,	$t0		# a2 = x
	jal	tak
	move	$t4,	$v0		# t3 = tak(y - 1, z, x)
	
	lw	$t0,	4($sp)
	lw	$t1,	8($sp)
	lw	$t2,	12($sp)
	move	$a2,	$t3		# a2 = tak(y, z - 1, x)
	move	$a1,	$t4		# a1 = tak(y - 1, z, x)
	addi	$a0,	$t0,	-1	# a0 = x - 1
	jal	tak
	j	end_func

xLZ:
	move	$v0,	$a1
	j	end_func
yLZ:
	move	$v0,	$a2
	j	end_func
zLZ:
	addi	$a0,	$a0,	-1
	addi	$a1,	$a1,	-1
	jal	tak			# tak(x - 1, y - 1, z)
	j	end_func
end_func:
	lw	$ra,	0($sp)
	lw	$a0,	4($sp)
	lw	$a1,	8($sp)
	lw	$a2,	12($sp)
	addi	$sp,	$sp,	16
	jr	$ra
	
	
