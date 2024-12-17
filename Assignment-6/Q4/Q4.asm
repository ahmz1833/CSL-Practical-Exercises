# Assignment 6 - Practical Question 4; 402106434, 402106456

.macro read_int $dest
    li      $v0,    5
    syscall
    move    $dest,  $v0
.end_macro

.macro print_int %src
    move    $a0,    %src
    li      $v0,    1
    syscall
.end_macro

.macro print_char %src
    li      $a0,    %src
    li      $v0,    11
    syscall
.end_macro

.macro print_str %str
.data
    _pstr_str: .asciiz %str
.text
    li      $v0,    4
    la      $a0,    _pstr_str
    syscall
.end_macro

.macro alloc %n, %addr
    li      $v0,    9
    move    $a0,    %n
    syscall
    move    %addr,  $v0
.end_macro

# Macro of reading a matrix from input. assuming total number of elements stored in %n
# Using registers $t0, $t1, $t2, $v0
.macro read_mat %addr, %n
    li      $t0,    0                    # $t0 = loop counter (i)
    move    $t1,    %addr                # $t1 points to the current storage location
_rmat_loop:
    beq     $t0,    %n,    _rmat_done    # Check if all elements have been read
    read_int        $t2                  # $t2 = input integer
    sb      $t2,    0($t1)               # Store byte at address in $t1
    addi    $t1,    $t1,    1            # Increment address by 1 bytes (next element)
    addi    $t0,    $t0,    1            # i++
    j       _rmat_loop                   # Jump back to the start of the loop
_rmat_done:
.end_macro

# Macro for printing a matrix in a pretty format.
# Assuming total elements stored in %n, and number of columns stored in %cols
# Using $t0, $t1, $t2, $v0, $a0
.macro print_mat %addr, %n, %cols
    li      $t0,    0                    # $t0 = loop counter (i)
    move    $t1,    %addr                # $t1 points to the current element to print
_pmat_loop:
    beq     $t0,    %n,    _pmat_done    # Check if all elements have been printed
    lb      $t2,    0($t1)               # Load byte into $t2
    print_int       $t2                  # Print the element
    print_str       "    "               # Print some spaces
    # Determine if a newline should be printed
    # Calculate (i + 1) % n to check for end of row
    addi    $t2,    $t0,    1            # $t3 = i + 1
    div     $t2,    %cols                # Divide by number of columns (n)
    mfhi    $t2                          # $t3 = remainder
    bne     $t2,    $0,     _pmat_noLF   # If remainder != 0, skip printing \n
    print_char      '\n'                 # If remainder == 0, print \n
_pmat_noLF:
    addi    $t1,    $t1,    1            # Increment address by 1 bytes (next element)
    addi    $t0,    $t0,    1            # i++
    j       _pmat_loop                   # Jump back to th start of the loop
_pmat_done:
.end_macro

####################### End of Macros #########################

.text
.globl main
main:
    # Input matrix dimensions
    read_int        $s0                  # Load number of rows (m) into $s0
    read_int        $s1                  # Load number of columns (n) into $s1
    mul     $s2,    $s0,    $s1          # $s2 = m*n
    alloc   $s2,    $a2                  # Allocate m*n Word and put its address into $a2 (Source Matrix)
    read_mat($a2, $s2)                   # Read Source Matrix
    alloc   $s2,    $a3                  # Allocate m*n Word and put its address into $a3 (Destination Matrix)

    # Outer loop: iterate over rows of the target matrix
    move    $t0,    $zero                # init target row index (j = 0)
_outer:
    beq     $t0,    $s1,    _done        # If j == n, we are done
    # Inner loop: iterate over cols of the target matrix
    move    $t1,    $zero                # init target col index (i = 0)
_inner:
    beq     $t1,    $s0,    _next_row    # If i == m, move to the next row
    # Calculate source index in source matrix
    sub     $t2,    $s0,    $t0          # t2 = m - j
    sub     $t2,    $t2,    1            # t2 = m - j - 1 (adjust for 0-based index)
    mul     $t2,    $t2,    $s1          # t2 = (m - j - 1) * n
    add     $t2,    $t2,    $t1          # t2 = (m - j - 1) * n + i
    add     $t2,    $t2,    $a2          # t2 = Address of source[m-j-1][i]
    lb      $t2,    0($t2)               # t2 = source[m-j-1][i]
    # Calculate target index in destination matrix
    mul     $t3,    $t1,    $s0          # t3 = i * m
    add     $t3,    $t3,    $t0          # t3 = i * m + j
    add     $t3,    $t3,    $a3          # t3 = Address of destination[i][j]
    sb      $t2,    0($t3)               # Store source[m-j-1][i] into destination[i][j]
    # Increment col index in target (i++)
    addi    $t1,    $t1,    1
    j       _inner
_next_row:
    # Increment row index in target (j++)
    addi    $t0,    $t0,    1
    j       _outer
_done:
    print_mat($a3, $s2, $s0)             # Print Destination Matrix
    # Exit program
    li      $v0,    10                   # Exit syscall
    syscall


# .macro read_int %dest
#     li      $t6,    0                    # $t6 = accumulated integer value
#     li      $t9,    0                    # $t9 = negative flag (0 = positive, 1 = negative)
# _rint_loop:
#     read_char       $t7                  # Read a single character into $t7
#     li      $t8,    '-'                  # ASCII code for '-'
#     beq     $t7,    $t8,    _rint_neg    # Check is negative, goto neg
#     li      $t8,    '0'
#     blt     $t7,    $t8,    _rint_loop   # If char < '0', skip and repeat
#     li      $t8,    '9'
#     bgt     $t7,    $t8,    _rint_loop   # If char > '9', skip and repeat
#     j       _rint_proc                   # Continue Conversion
# _rint_neg:
#     li      $t9,    1                    # $t9 = 1 (negative)
#     j       _rint_loop                   # Skip '-' and continue input
# _rint_continue:
#     read_char       $t7                  # Read a single character into $t7
#     li      $t8,    '0'
#     blt     $t7,    $t8,    _rint_end    # If char < '0', end
#     li      $t8,    '9'
#     bgt     $t7,    $t8,    _rint_end    # If char > '9', end
# _rint_proc:
#     sub     $t7,    $t7,   '0'           # Convert ASCII digit to integer
#     mul     $t6,    $t6,   10            # $t6 = $t6 * 10
#     add     $t6,    $t6,   $t7           # $t6 = $t6 + digit
#     j       _rint_continue               # Continue reading next character
# _rint_end:                               # Apply negative flag if necessary
#     beq     $t9,    $0,    _rint_store   # If not negative, skip negation
#     neg     $t6,    $t6                  # $t6 = -$t6
# _rint_store:
#     move    %dest,  $t6                  # Move the accumulated integer to the destination register
# .end_macro
