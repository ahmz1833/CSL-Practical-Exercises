.data
a:  .word   0, 0
.text

.macro  read_int, $dest
	li      $v0,    5              # syscall 5: read_int
	syscall
	move    $dest,  $v0            # read into $zero
.end_macro

.macro  read_char, $dest
	li      $v0,    12             # syscall 12: read_character
	syscall
	move    $dest,  $v0            # read into $zero
.end_macro

.macro  print_int, $src
	li      $v0,    1              # syscall 1: print_int
	move    $a0,    $src
	syscall                        # print $src
.end_macro

main:
	read_int($s0)
	read_char($t0)
	read_int($s1)

	add     $s2,    $s0,    $s1
	sub     $s3,    $s0,    $s1
	la      $t1,    a
	sw      $s2,    0($t1)
	sw      $s3,    4($t1)
	sub     $t0,    $t0,    43     # Now, $t0 will be 0 or 2 (relate to '+' and '-')
	add     $t0,    $t0,    $t0    # Now, $t0 will be 0 or 4 ///
	lw      $s0,    a($t0)

	print_int($s0)
