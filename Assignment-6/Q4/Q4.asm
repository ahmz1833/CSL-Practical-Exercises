.data
size_m: .word 4    # Number of rows
size_n: .word 4    # Number of cols
matrix:
    .byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
rotated_matrix:    # Memory space for rotated matrix
    .space 16      # 4x4 matrix = 16 elements, 4 bytes each

.text
.globl main
main:
    # Load matrix dimensions
    la   $a0, size_m       # Load address of size_m
    lw   $a0, 0($a0)       # Load number of rows (m) into $a0
    la   $a1, size_n       # Load address of size_n
    lw   $a1, 0($a1)       # Load number of columns (n) into $a1

    # Calculate starting address of matrix
    la   $a2, matrix       # Base address of the original matrix
    la   $a3, rotated_matrix # Base address of rotated matrix

    # Outer loop: iterate over rows of the target matrix
    move $t0, $zero        # target row index (j = 0)
rotate_outer_loop:
    beq  $t0, $a1, rotate_done  # If j == n, we are done

    # Inner loop: iterate over cols of the target matrix
    move $t1, $zero        # target col index (i = 0)
rotate_inner_loop:
    beq  $t1, $a0, next_column  # If i == m, move to the next row

    # Calculate source index in source matrix
    sub  $t2, $a0, $t0    # t2 = m - j
    sub  $t2, $t2, 1     # t2 = m - j - 1 (adjust for 0-based index)
    mul  $t2, $t2, $a1   # t2 = (m - j - 1) * n
    add  $t2, $t2, $t1   # t2 = (m - j - 1) * n + i
    add  $t2, $t2, $a2   # t2 = Address of source[m-j-1][i]
    lb   $t2, 0($t2)     # t2 = source[m-j-1][i]
    
    # Calculate target index in destination matrix
    mul  $t3, $t1, $a0     # t3 = i * m
    add  $t3, $t3, $t0     # t3 = i * m + j
    add  $t3, $t3, $a3     # t3 = Address of destination[i][j]
    sb   $t2, 0($t3)      # Store source[m-j-1][i] into destination[i][j]

    # Increment row index (i++)
    addi $t1, $t1, 1
    j    rotate_inner_loop

next_column:
    # Increment column index (j++)
    addi $t0, $t0, 1
    j    rotate_outer_loop

rotate_done:
    # Exit program
    li   $v0, 10           # Exit syscall
    syscall
