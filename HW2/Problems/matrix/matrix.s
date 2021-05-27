.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:

    # insert code here
    
    ADDI x5, zero, 128  # t0
    ADD  x27, x0, a1    # s11
    ADDI x6, x0, 0      # t1
    ADDI x31, x0, 0
    ADDI x30, x0, 0     # t4
    ADDI x15, x0, 0     # t3
    ADDI x14, x0, 0     # t2
L1: LHU  x28, 0(a0)     # t5
    LHU  x29, 0(x27)    # t6
    MUL  x28, x28, x29  # A*B
    ADD  x30, x30, x28  # C+A*B
    ANDI x30, x30, 1023 # (C+A*B)%1024
    ADDI a0, a0, 2      # address of A[i][k+1]
    ADDI x27, x27, 256    # address of B[k+1][j]
    ADDI x15, x15, 1   # k--
    BLT  x15, x5, L1    # while (k>=0)

    SH   x30, 0(a2)     # store back C[i][j]    

    ADDI x30, x0, 0     # t4
    ADDI x15, x0, 0     # t3

    ADDI a2, a2, 2      # address of C[i][j+1]
    ADDI a0, a0, -256   # address of A[i][0]
    ADDI x31, x31, 2      # j*2 += 2
    ADD x27, a1, x31 
    ADDI x14, x14, 1   # j--
    BLT  x14, x5, L1    # while (j>=0)
    ADDI x31, x31, -256
    ADDI x14, x0, 0     # t2

    ADDI a0, a0, 256    # address of A[i+1][k]
    ADDI x31, x0, 0
    ADD  x27, x27, -256
    ADDI x6, x6, 1   # i--
    BLT  x6, x5, L1    # while (k>=0)
ret


