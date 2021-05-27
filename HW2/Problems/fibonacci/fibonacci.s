.global fibonacci
.type fibonacci, %function

.align 2
# unsigned long long int fibonacci(int n);
fibonacci:  
    
    # insert code here
    
    ADDI x5, x0, 0    # F_0 = 0
    ADDI x6, x0, 1    # F_1 = 1
                      # x5 == fibonacci(n-1), x6 == fibonacci(n-2)
    BEQ a0, x5, EXIT  # if (n==0) then fibonacci(0) = 0
    BEQ a0, x6, EXIT  # if (n==1) then fibonacci(1) = 1
    ADDI a0, a0, -1   # n = n - 1
L1: ADDI a0, a0, -1   # n-- (for n >= 2)
    ADD x7, x5, x6    # fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)
    ADDI x5, x6, 0    # x5 = x6
    ADDI x6, x7, 0    # x6 = x7
    BNE a0, x0, L1    # if (n!=0) then goto L1
    ADD a0, x7, x0   # a0 = fibonacci(n)

    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
EXIT: ret
    
