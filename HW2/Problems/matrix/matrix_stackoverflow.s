.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here

        addi t0, zero, 128 # size
        add s11, zero, a1 # B
        add t1, zero, zero # i = 0 
loop1:  add t2, zero, zero # j = 0
loop2:  add t3, zero, zero # k = 0
        add t4, zero, zero # sum = 0
loop3:  lhu t5, 0(a0) # A[i][k]
        lhu t6, 0(s11) # B[k][j]
        mul t5, t5, t6 # A*B
        add t4, t4, t5 # C += A*B
        andi t4, t4, 1023 # mod 1024
        addi a0, a0, 2 # A[i][k+1]
        addi s11, s11, 256 # B[k+1][j]
        addi t3, t3, 1 # k++ 
        blt t3, t0, loop3 # k<size , continue
        # loop3 end #
        sh t4, 0(a2) # store back to C[i][j]
        addi a2, a2, 2 # C[i][j+1]
        addi a0, a0, -256 # A go back
        addi a1, a1, 2 # B[k][j+1]
        add  s11, zero, a1 # B
        addi t2, t2, 1 # j++
        blt t2, t0, loop2 # j<size , continue
        # loop2 end #
        addi a0, a0, 256 # A[i+1][k]
        addi a1, a1, -256 # B go back (because line 40 add 2*128=256)
        add s11, zero, a1 # B
        addi t1, t1, 1 # i++
        blt t1, t0, loop1 # i<size , continue
        # loop1 end #    

    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
    
    ret
