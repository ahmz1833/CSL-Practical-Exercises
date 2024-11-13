# Assignment 3 - Practical Question 3; 402106434, 402106456

.macro  read_int, $memdest
	li      $v0,    5                      # syscall 5: read_int
	syscall                                # read integer
	sw      $v0,    0($memdest)            # store integer in memory
.end_macro

.macro  print_int, $int
	li      $v0,    1                      # syscall 1: print_int
	move    $a0,    $int                   # move integer to $a0
	syscall                                # print integer
.end_macro

.text
	# j       main   ######################## Discomment this for not scanning from input

read_array:
	la      $t0,    array                  # load array address
	read_int($t0)                          # read first element
	addi    $t0,    $t0,            4      # increment address
	read_int($t0)                          # read second element
	addi    $t0,    $t0,            4      # increment address
	read_int($t0)                          # read third element
	addi    $t0,    $t0,            4      # increment address
	read_int($t0)                          # read fourth element
	addi    $t0,    $t0,            4      # increment address
	read_int($t0)                          # read fifth element
	addi    $t0,    $t0,            4      # increment address
	read_int($t0)                          # read sixth element
	addi    $t0,    $t0,            4      # increment address
	read_int($t0)                          # read seventh element

main:
	la      $t0,    array                  # load array address
	lw      $t1,    0($t0)                 # load first element
	lw      $t2,    24($t0)                # load last element
	xor     $s0,    $t1,            $t2    # xor first and last element -> s0
	lw      $t1,    4($t0)                 # load second element
	lw      $t2,    20($t0)                # load second last element
	xor     $s1,    $t1,            $t2    # xor second and second last element  -> s1
	or      $s1,    $s0,            $s1    # or s0 and s1 -> s1
	lw      $t1,    8($t0)                 # load third element
	lw      $t2,    16($t0)                # load third last element
	xor     $s0,    $t1,            $t2    # xor third and third last element -> s0
	or      $s1,    $s0,            $s1    # or s0 and s1 -> s1 (Now, s1 is the or result of all xor operations)

	# Now, We must print 1 if s1 is 0, otherwise print 0 (But we can't use branch instructions)
	neg     $a0,    $s1                    # a0 = -s1
	or      $a0,    $a0,            $s1    # a0 = -s1 | s1
	srl     $a0,    $a0,            31     # a0 >>= 31  (a0 = 0 if s1 = 0, otherwise a0 = -1)
	xori    $a0,    $a0,            1      # s0 = s0 ^ 1 (Negate the least significant bit, so a0 = 1 if s1 = 0, otherwise a0 = 0)
	j       print
	#j exit

print:
	print_int($a0)                         # print the result

exit:
	li      $v0,    10                     # syscall 10: exit
	syscall

.data
array:
    .word   70, 60, 50, 40, 50, 60, 70
length:
    .word   7
one:
    .word   1
