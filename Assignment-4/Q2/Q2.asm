.macro  read_int, $dest
	li      $v0,        5
	syscall
	move   $dest,      $v0
.end_macro
.macro  print_int, $input
	move      $a0,        $input
	li	 $v0,		1
	syscall                            
.end_macro
.macro  print_newline
	li      $v0,        11             # syscall 11: print_character
	li      $a0,        '\n'
	syscall                            # print $zero
.end_macro
.macro print_space
	li	$v0,	11
	li	$a0,	' '
	syscall
.end_macro
###swapping 2 numbers using xor, $t3 to check if swap is needed
.macro swap, $src1, $src2
	sub $t3, $src1, $src2
	sra $t3, $t3, 31		#$t3 is -1 if it is negative, else 0
	xor $t4, $src1, $src2
	and $t4, $t4, $t3
	xor $src1, $src1, $t4
	xor $src2, $src2, $t4
.end_macro  

.data
nums:
	.word 0, 0, 0        # Array to hold the three input numbers

.text
	.globl main
main:
	read_int($t0)
	read_int($t1)
	read_int($t2)
	swap($t0, $t1)
	swap($t1, $t2)
	swap($t0, $t1) 	
	print_int($t0)
	print_space
	print_int($t1)
	print_space
	print_int($t2)
	print_space
	print_newline
	    