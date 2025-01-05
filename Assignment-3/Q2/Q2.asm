# Assignment 3 - Practical Question 2; 402106434, 402106456

.macro  read_float, $dest
    li      $v0,        6
    syscall
    mov.s   $dest,      $f0
.end_macro

.macro  print_newline
    li      $v0,        11             # syscall 11: print_character
    li      $a0,        '\n'
    syscall                            # print $zero
.end_macro

.macro  print_float, $src
    mov.s   $f12,       $src
    li      $v0,        2
    syscall
.end_macro

.text
    .globl  main

main:
    read_float($f2)                    # $f2 = a
    read_float($f4)                    # $f4 = b
    read_float($f6)                    # $f6 = c

    jal     cal_delta                  # read $f2 as a | $f4 as b | $f6 as c -> delta returned as $f8

    sqrt.s  $f8,        $f8            # $f8 = rad(delta)
    neg.s   $f4,        $f4            # $f4 = -b
    add.s   $f16,       $f4,    $f8    # $f16 = -b+rad(delta)
    div.s   $f16,       $f16,   $f2    # $f16 = root1
    sub.s   $f18,       $f4,    $f8    # $f18 = -b-rad(delta)
    div.s   $f18,       $f18,   $f2    # $f18 = root2

    print_float($f16)
    print_newline
    print_float($f18)
    j       exit

cal_delta:
    mul.s   $f8,        $f4,    $f4    # $f8 = b^2
    mul.s   $f10,       $f2,    $f6    # $f10 = a*c
    l.s     $f14,       coef
    mul.s   $f10,       $f14,   $f10   # $f8 = 4*a*c
    add.s   $f2,        $f2,    $f2    # $f2 = 2a
    sub.s   $f8,        $f8,    $f10   # $f8 = delta = b^2 - 4ac
    jr      $ra

exit:
    li      $v0,        10             # syscall 10: exit
    syscall

.data
coef:
    .float  4
