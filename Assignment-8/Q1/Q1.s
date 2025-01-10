# Assignment 8 - Practical Question 1; 402106434, 402106456

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
    enter   0
    read_long
    lgr     %r10,    %r2    # r10 = n
    
    input_loop:
    cgfi    %r10, 0
    je      end_loop
    
    read_long
    larl    %r11,    sum
    lg     %r11,   0(%r11)
    agr     %r11,   %r2     # sum += n
    larl    %r9,    sum
    stg    %r11,   0(%r9)
    lgr     %r2,    %r11
    call    is_square       # r2 = is_square(sum)
    cfi     %r2,    1
    je      print_yes
    j       print_no

print_yes:
    larl    %r2,    yes
    call    printf
    j       continue_loop
print_no:
    larl    %r2,    no
    call    printf

continue_loop:
    aghi    %r10, -1
    j       input_loop

end_loop:

    leave   0
    ret
####################### Functions #######################
is_square:
    enter   0
    lgr     %r7,    %r2     # r7 = n
    lghi    %r8,    1         
    
loop:
    lgr     %r9,    %r8     # r9 = i
    msgr    %r9,    %r8     # r9 = i * i
    cgr     %r9,    %r7     # i * i > n
    jh      not_square
    je      is_square_num
    aghi    %r8,    1       # i++
    j       loop
    
is_square_num:
    lghi    %r2,    1
    j       done

not_square:
    lghi    %r2,    0

done:
    leave   0
    ret
####################### Data #######################
.data
.align    8
scan_num:    .asciz    "%ld"
.align    8
yes:    .asciz    "YES\n"
.align    8
no:     .asciz    "NO\n"
.align    8
sum:    .quad    0
