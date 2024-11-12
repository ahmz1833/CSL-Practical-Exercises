.data
array:  .word   70, 60, 50, 40, 50, 60, 70
length: .word   7
one:    .word   1

.text
main:
	la      $t0,    array
	lw      $t1,    0($t0)
	lw      $t2,    24($t0)
	xor     $s0,    $t1,        $t2
	lw      $t1,    4($t0)
	lw      $t2,    20($t0)
	xor     $s1,    $t1,        $t2
	or      $s1,    $s0,        $s1
	lw      $t1,    8($t0)
	lw      $t2,    16($t0)
	xor     $s0,    $t1,        $t2
	or      $s1,    $s0,        $s1
	sub     $s0,    $zero,      $s1
	or      $s0,    $s0,        $s1
	srl     $s0,    $s0,        31
	addi    $s0,    $s0,        1
	andi    $s0,    $s0,        1
	li      $v0,    1                          # syscall 1: print_int
	move    $a0,    $s0
	syscall                                    # print $zero