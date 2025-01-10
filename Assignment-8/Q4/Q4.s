# Assignment 8 - Practical Question 4; 402106434, 402106456

####################### Macros #######################
.macro call func
    lay   %r15, -160(%r15)              # Allocate stack frame for calling function
    brasl %r14, \func                   # Call the function
    lay   %r15, 160(%r15)               # Disallocate stack frame of called function
.endm

.macro ret
    br %r14                             # Return to the caller
.endm

.macro enter 
    stmg %r6, %r15, 48(%r15)            # Save r6 to r15 in stack
.endm

.macro leave
    lmg %r6, %r15, 48(%r15)             # Restore r6 - r15
.endm

.macro read_long	# Input is in r2
	enter	8
	larl	%r2, scan_num
	lay	%r3, 160(%r15)
	call	scanf
	lg	%r2, 160(%r15)
	leave	8
.endm

####################### Main #######################

.text
.global	main
main:
    enter
    read_long
    lgr     %r7,    %r2
    read_long
    lgr     %r8,    %r2

    lgr     %r2,    %r7
    call    count_bits
    lgr %r9,    %r2

    lgr     %r2,    %r8
    call    count_bits
    lgr %r10,   %r2

### in general i want to store the number with fewer 1s in less_1 and the number with more 1s in more_1
### and store number of 1s of the number with fewer 1s in num_of_1s
    cr       %r9,   %r10
    jl       R7Less
    je       R8Less

R8Less:
    larl    %r11,   less_1
    stg     %r8,    0(%r11)         # less_1 = r8
    larl    %r11,   more_1
    stg     %r7,    0(%r11)         # more_1 = r7
    larl    %r11,   num_of_1s
    stg     %r10,   0(%r11)         # num_of_1s = bitcount(r8)
    j       done

R7Less:
    larl    %r11,   less_1
    stg     %r7,    0(%r11)         # less_1 = r7
    larl    %r11,   more_1
    stg     %r8,    0(%r11)         # more_1 = r8
    larl    %r11,   num_of_1s
    stg     %r9,    0(%r11)
done:
###	now multiply the two numbers
    call    multiply
    lgr     %r3,    %r2
    larl    %r2,    result
    call    printf

    larl    %r3,    num_of_1s
    lg      %r3,    0(%r3)
    larl    %r2,    num_of_adds
    call    printf



    leave
    ret


####################### Function Definitions #######################
######## count_bits ###########
count_bits:
    enter
    xgr     %r9, %r9            # r9 = 0
    lgr     %r11, %r2
count_bits_loop:
    tmll    %r11, 1             # check if the last bit is 1
    jnz     count_increment
count_back:
    srlg    %r11,   %r11,   1   # shift right
    cgfi    %r11,   0           # check if the number is 0
    jnz     count_bits_loop

    lgr     %r2,    %r9
    leave
    ret

count_increment:
    aghi    %r9, 1
    j       count_back


######### Multiply ###########
multiply:
    enter
    larl    %r11,   less_1     
    lg      %r7,    0(%r11)     # r7 = multiplier (number with fewer 1s)
    larl    %r11,   more_1
    lg      %r8,    0(%r11)     # r8 = multiplicand
    xgr     %r9,    %r9         # r9 = 0 (result)
    
multiply_loop:
    tmll    %r7,    1           # if last bit is 0, skip add
    jz      skip_add
    agr     %r9,    %r8         # r9 += r8
    
skip_add:
    srlg    %r7,    %r7,    1   # shift right r7
    sllg    %r8,    %r8,    1   # shift left r8
    cgfi    %r7,    0           # if r7 == 0, return
    jnz     multiply_loop
    
    lgr     %r2,    %r9
    leave
    ret


######### Data Section #########

.data
.align  8
scan_num:	.asciz	"%ld"
.align	8
print_num:	.asciz	"%ld\n"
.align	8
num_of_adds:	.asciz "Number of additions: %ld\n"
.align	8
result:		.asciz "Result: %ld\n"
.align	8
num_of_1s:  .quad   0
.align  8
less_1:     .quad   0
.align  8
more_1:     .quad   0
.align  8

