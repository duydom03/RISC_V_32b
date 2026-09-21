.section .text
.globl _start
_start:
    addi x1, x0, 10        # x1 = 10
    addi x2, x0, 20        # x2 = 20
    add  x3, x1, x2        # x3 = 30
    sub  x4, x1, x2        # x4 = -10
    and  x5, x1, x2        # x5 = 0
    or   x6, x1, x2        # x6 = 30
    xor  x7, x1, x2        # x7 = 30
    slt  x8, x1, x2        # x8 = 1
    addi x9, x0, 1
    sll  x10, x1, x9
    nop
