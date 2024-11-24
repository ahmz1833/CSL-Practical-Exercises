# Assignment 4 - Practical Question 5; 402106434, 402106456

.macro  read_int, $dest
	li      $v0,    5
	syscall
	move    $dest,  $v0
.end_macro

.macro  print_int, $input
	move    $a0,    $input
	li      $v0,    1
	syscall
.end_macro

.text
.globl  main
main:
	read_int($s0)                  #a
	read_int($s1)                  #b
	read_int($s2)                  #c
	read_int($s3)                  #d
	read_int($s4)                  #x
	mult    $s4,    $s4
	mflo    $t0                    #$t0 = x^2
	mult    $s4,    $t0
	mflo    $t1                    #$t1 = x^3
	mult    $t1,    $s0
	mflo    $t1                    #$t1 = ax^3
	mult    $t0,    $s1
	mflo    $t0                    #$t0 = bx^2
	mult    $s4,    $s2
	mflo    $s4                    #$s4 = cx
	add     $t3,    $t0,    $t1
	add     $t3,    $t3,    $s3
	add     $t3,    $t3,    $s4
	print_int($t3)

