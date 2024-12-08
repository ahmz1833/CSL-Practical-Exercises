# Assignment 5 - Practical Question 3; 402106434, 402106456

.macro print_int %src
    move  $a0,    %src
    li    $v0,    1
    syscall
.end_macro

.macro print_char %src
    move  $a0,    %src
    li    $v0,    11
    syscall
.end_macro

.macro read_int %dest
    li    $v0,    5
    syscall
    move  %dest,  $v0
.end_macro

.macro input_array %n, %addr
_input_loop:
    read_int($t9)
    sw    $t9,    0(%addr)
    addi  %addr,  %addr,    4
    addi  %n,     %n,      -1
    bnez  %n,     _input_loop
.end_macro

.macro print_array %n, %addr
_print_loop:
    lw    $t9,    0(%addr)
    print_int($t9)
    li    $t8,    ' '
    print_char($t8)
    addi  %addr,  %addr,    4
    addi  %n,     %n,      -1
    bnez  %n,     _print_loop
.end_macro

.macro alloc %n, %size
    li    $v0,    9
    move  $a0,    %n
    sll   $a0,    $a0,     %size
    syscall
.end_macro

################## End of Macros ###################

.data
rel_prime_count:    .word    0       # Counter for relatively prime pairs

.text
main:
    read_int($s0)                    # Read n
    alloc   $s0,    2                # Allocate space for array
    move    $s1,    $v0              # $s1 = address of arr
    move    $t2,    $s0              # $t2 = n
    move    $t3,    $s1              # $t3 = address of arr
    input_array($t2, $t3)            # Input array
    
    li      $t0,    0                # init counter for relatively prime pairs (t0)
    li      $t1,    0                # init i = 0
outer_loop:
    beq     $t1,    $s0,   end_outer # if i == n, end outer loop

    addi    $t2,    $t1,   1         # j = i + 1
inner_loop:
    beq     $t2,    $s0,   end_inner # if j == n, end inner loop
    mul     $t3,    $t1,   4         # $t3 = 4 * i
    add     $t3,    $t3,   $s1       # $t3 = &arr[i]
    lw      $a0,    0($t3)           # $a0 = arr[i]
    mul     $t4,    $t2,   4         # $t4 = 4 * j
    add     $t4,    $t4,   $s1       # $t4 = &arr[j]
    lw      $a1,    0($t4)           # $a1 = arr[j]
    jal     gcd                      # $v0 = gcd(arr[i], arr[j])
    li      $t5,    1                # $t5 = 1
    bne     $v0,    $t5,   _skip_inc # if gcd != 1, skip increment counter
    addi    $t0,    $t0,   1         # Increment counter for relatively prime pairs
_skip_inc:
    addi    $t2,    $t2,   1         # j++
    j       inner_loop               # Repeat inner loop
end_inner:
    addi    $t1,    $t1,   1         # i++
    j       outer_loop               # Repeat outer loop
end_outer:

    sw      $t0,    rel_prime_count  # Store result in rel_prime_count
    print_int($t0)                   # Print result

    li      $v0,    10               # Exit
    syscall

################## GCD Function ####################
gcd:
_gcd_loop:
    beq     $a1,    $0,    _gcd_done   # if y == 0, return x
    move    $t6,    $a1                # $t6 = y
    rem     $a1,    $a0,   $a1         # y = x % y
    move    $a0,    $t6                # x = $t6 (old y)
    j       _gcd_loop                  # repeat
_gcd_done:
    move    $v0,    $a0                # return x
    jr      $ra                        # return