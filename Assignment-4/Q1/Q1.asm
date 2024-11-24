# Assignment 4 - Practical Question 1; 402106434, 402106456
.macro  read_int, $dest
	li      $v0,        5
	syscall
	move   $dest,      $v0
.end_macro
.macro  hemar, $src1, $src2, $src3, $dest
	add $dest, $src1, $src2
	sub $dest, $src3, $dest
.end_macro
.macro  print_int, $input
	move      $a0,        $input
	li	 $v0,		1
	syscall
.end_macro
.text
	.globl main
main:
	read_int($t1)
	read_int($t2)
	read_int($t3)
	hemar($t1, $t2, $t3, $s1)	#$s1 = c - (a + b)
	hemar($t2, $t3, $t1, $s2)	#$s2 = a - (b + c)
	hemar($t1, $t3, $t2, $s3)	#$s3 = b - (a + c)
	### s1 and s2 and s3 all must be negative numbers. If it is not a triangle, one of them is positive
	srl $s1, $s1, 31
	srl $s2, $s2, 31
	srl $s3, $s3, 31
	and $t4, $s1, $s2
	and $t4, $t4, $s3
	print_int($t4)
	
	