# Assignment 3 - Practical Question 4; 402106434, 402106456

.data
num1:
    .word   68
num2:
    .word   35
max_value:
    .word   0
.text
    # j       main  ######################## Discomment this for not scanning from input

input_nums:
    li      $v0,    5                      # syscall 5: read_int
    syscall
    sw      $v0,    num1($0)
    li      $v0,    5                      # syscall 5: read_int
    syscall
    sw      $v0,    num2($0)

main:
    lw      $t0,    num1($0)
    lw      $t1,    num2($0)
    sub     $t0,    $t0,            $t1    # $t0 = num1 - num2
    srl     $t0,    $t0,            31     # $t0 = sign bit of num1 - num2
    mul     $s0,    $t0,            $t1    # $s0 = (n1<n2) * n2
    addi    $t0,    $t0,            -1
    neg     $t0,    $t0                    # $t0 = 1 - (n1<n2) -> will be 0 if n1 < n2 ; else will be 1
    lw      $t2,    num1($0)
    mul     $s1,    $t2,            $t0    # $s1 = (n1>=n2) * n1
    add     $a0,    $s1,            $s0    # $a0 = (n1<n2)*n2 + (n1>=n2)*n1 = max(n1, n2)
    sw      $a0,    max_value($0)          # max_value = max(num1, num2)

print:
    li      $v0,    1                      # Print int
    syscall

exit:
    li      $v0,    10                     # syscall 10: exit
    syscall

