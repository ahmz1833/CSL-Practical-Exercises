# Assignment 6 - Practical Question 1; 402106434, 402106456

.macro read_int %dest
    li      $v0,    5
    syscall
    move    %dest,  $v0
.end_macro

.macro print_int %src
    move    $a0,    %src
    li      $v0,    1
    syscall
    li      $v0,    11
    li      $a0,    '\n'
    syscall
.end_macro

.macro read_string %dest, %n
    li      $v0,    8
    move    $a0,    %dest
    move    $a1,    %n
    addi    $a1,    $a1,    1            # For \0 in destination string
    syscall
.end_macro

.macro alloc %n, %addr
    li      $v0,    9
    move    $a0,    %n
    syscall
    move    %addr,  $v0
.end_macro

################### End of Macros #################

.text
main:
    read_int($t0)                        # Read substring size into k:=$t0
    alloc($t0, $t1)                      # Store base address of substring in $t1
    read_string($t1, $t0)                # Read substring into $t1

    read_int($t2)                        # Read string size into n:=$t2
    alloc($t2, $t3)                      # Store base address of string in $t3
    read_string($t3, $t2)                # Read string into $t3

    move    $a0,    $t2                  # Load n into $a0 
    jal     count_substr                 # Call recursive function f(n)
    j       exit                         # Exit

################################# Function count_substr ###########################################
# count_substr guarantees that preserve $t0 (substr size), $t1 (substr base-adr), $t2 (str size), $t3 (str base-adr)
# a:=$a0 is size of string prefix (we count substrings within this prefix)
count_substr:
    # Base of Recursive (a < k)
    bge     $a0,    $t0,    _csbstr_     # if (a >= k) goto _csbstr_
    print_int($0)                        # print 0
    li      $v0,    0
    jr      $ra                          # else return 0
_csbstr_:
    addi    $sp,    $sp,    -8
    sw      $ra,    0($sp)
    sw      $s0,    4($sp)
    # Check if str[a-k:a] == substr
    li      $s0,    0                    # Load 0 in $s0
    sub     $t4,    $a0,    $t0          # $t4 = a - k
    addi    $t4,    $t4,    -1           # $t4 = a - k - 1
    add     $t4,    $t4,    $t3          # $t4 = str-base-addr + (a - k) + i-1   (i is 1-based counter)
    addi    $t5,    $t1,    -1           # $t5 = substr-base-addr + i-1
    add     $t8,    $t5,    $t0          # $t8 = address of substr[k-1]  (last addr of substr)
_csbstr_loop:
    # i++
    addi    $t4,    $t4,    1
    addi    $t5,    $t5,    1
    lb      $t6,    0($t4)               # $t6 = str[a-k + i-1]
    lb      $t7,    0($t5)               # $t7 = substr[i-1]
    bne     $t6,    $t7,    _csbstr_neq  # if ($t6 != $t7) break (goto _csbstr_neq)
    bne     $t8,    $t5,    _csbstr_loop # if (i != k) loop
# End of The loop, Here, Two substrings are equal:
    li      $s0,    1                    # Load 1 in $s0
_csbstr_neq:
    addi    $a0,    $a0,    -1           # Prepare a-1 for input of recursive
    jal     count_substr                 # Call recursive f(a-1)
    add     $s0,    $v0,    $s0          # Calculate f(a):=$s0 = (1 or 0) + f(a-1)
    print_int($s0)                       # Print the result f(a)
    move    $v0,    $s0                  # Return value f(a)
    lw      $s0,    4($sp)
    lw      $ra,    0($sp)
    addi    $sp,    $sp,    8
    jr      $ra
###################################################
exit:
    li      $v0,    10
    syscall
