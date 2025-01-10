
# Assignment 8 - Practical Question 2; 402106434, 402106456
.macro enter size
	stmg	%r6, %r15, 48(%r15)
	lay	%r15, -(160+\size)(%r15)
.endm

.macro leave size
	lay	%r15, (160+\size)(%r15)
	lmg	%r6, %r15, 48(%r15)
.endm

.macro print_long			# Output is in r3
	enter	0
	larl	%r2, print_num
	call	printf
	leave	0
.endm

.macro read_string label	# Input is stored in the label
	enter	0
	larl	%r2, scan_str
	larl	%r3, \label
	call	scanf
	leave	0
.endm

.macro ret
	br	%r14
.endm

.macro call func
	brasl	%r14, \func
.endm



.text
.global	main
main:
	enter 0
	read_string str

	larl	%r8, str
	larl	%r9, sum
	larl	%r10, curNum
	

loop_start:
	lgb	%r7,	0(%r8)
	cfi	%r7,	0
	je	loop_end			#	if end of string, end loop
	cfi	%r7,	48
	jl	continue_loop		#	if not a digit, continue loop
	cfi	%r7,	57
	jh	handle_non_digit	#	if a letter, get the number out of the string

handle_digit:
	lg	%r6,	0(%r10)		#	r6 = curNum
	larl	%r11,	ten_const
	lg	%r11,	0(%r11)
	msr	%r6, %r11			#	r6 = r6 * 10
	lgb	%r7,	0(%r8)
	aghi	%r7,	-48		#	r7 = r7 - '0' => r7 becomes integer
	agr	%r6, %r7			#	r6 = r6 + r7
	stg	%r6, 0(%r10)		#	curNum = r6
	j	continue_loop

handle_non_digit:
	lg	%r7, 0(%r10)
	lg	%r6, 0(%r9)
	agr	%r6, %r7		#	sum += curNum
	stg	%r6, 0(%r9)		#	store sum
	xgr	%r7, %r7
	stg	%r7, 0(%r10)	#	curNum = 0
	j	continue_loop

continue_loop:
	la	%r8,	1(%r8)	#	i++
	j	loop_start

loop_end:
	lg	%r7, 0(%r10)
	lg	%r6, 0(%r9)
	agr	%r6, %r7
	stg	%r6, 0(%r9)		#	sum += curNum


	lg	%r3,	0(%r9)
	print_long


	leave 0
	ret

	
.data
.align	8
scan_str:	.asciz	"%100s"
.align	8
print_num:	.asciz	"%ld\n"
.align	8
str:		.space	101
.align	8
sum:		.quad	0
.align	8
curNum:		.quad	0
.align	8
digit_start:	.byte	'0'
.align	8
digit_end:		.byte	'9'
.align	8
zero_char:		.byte	'\0'
.align	8
ten_const:		.quad	10
.align	8
align	8
