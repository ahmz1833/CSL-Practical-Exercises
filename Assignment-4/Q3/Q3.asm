# Assignment 4 - Practical Question 3; 402106434, 402106456

.macro print_char %reg
	li      $v0,        11
	move    $a0,        %reg
	syscall
.end_macro

.macro print_newline
	li      $v0,        11
	li      $a0,        10
	syscall
.end_macro

.macro print_int %reg
	li      $v0,        1
	move    $a0,        %reg
	syscall
.end_macro

.macro  print_hex_digit %reg
	addi    $t1,        %reg,           '0'
	addi    $t2,        %reg,           'a'
	addi    $t2,        $t2,            -10
	addiu   $t3,        %reg,           -10
	sra     $t3,        $t3,            31             # is -1 if digit < 10
	and     $t4,        $t3,            $t1            # select '0' to '9' if digit < 10
	not     $t3,        $t3
	and     $t5,        $t3,            $t2            # select 'a' to 'f' if digit >= 10
	or      $t1,        $t4,            $t5
	print_char          $t1
.end_macro

.macro  print_hex %reg
	srl     $t0,        %reg,           4
	print_hex_digit     $t0
	andi    $t0,        %reg,           0xf
	print_hex_digit     $t0
.end_macro

.macro  print_bin_digit %reg, %idx
	srl     $t0,        %reg,           %idx
	and     $t0,        $t0,            1
	add     $t0,        $t0,            '0'
	print_char          $t0
.end_macro

.macro  print_bin %reg
	print_bin_digit %reg, 5
	print_bin_digit %reg, 4
	print_bin_digit %reg, 3
	print_bin_digit %reg, 2
	print_bin_digit %reg, 1
	print_bin_digit %reg, 0
.end_macro

.macro  form_digit %base, %idx, %rev, %reg
	lb      $at,        %idx(%base)                    # load byte from string
	addi    $at,        $at,            -48            # convert to integer
	sll     $at,        $at,            %rev           # shift left by 1
	or      %reg,       %reg,           $at            # add the new bit
.end_macro

.macro  parse_bin %str, %reg
	la      $t0,        %str
	li      %reg,       0                              # init register to zero
	form_digit $t0,     0,      5,      %reg
	form_digit $t0,     1,      4,      %reg
	form_digit $t0,     2,      3,      %reg
	form_digit $t0,     3,      2,      %reg
	form_digit $t0,     4,      1,      %reg
	form_digit $t0,     5,      0,      %reg
.end_macro

########################### End of Macros #############################

.data
bin_in_str: .space 8
.text
.globl  main
main:

	##------------------- Part 1 -------------------

	li      $v0,        8                              # syscall 8: read_string
	la      $a0,        bin_in_str
	li      $a1,        7
	syscall                                            # read into bin_in_str
	parse_bin bin_in_str, $s0                          # parse binary string into $s0

	print_int    $s0                                   # print $s0 in decimal
	print_newline
	print_hex    $s0                                   # print $s0 in hex
	print_newline

	##------------------- Part 2 -------------------

	li      $v0,        5                              # syscall 5: read_int
	syscall
	move    $s0,        $v0                            # read into $s0

	print_bin    $s0                                   # print $s0 in binary
	print_newline
	print_hex    $s0                                   # print $s0 in hex
