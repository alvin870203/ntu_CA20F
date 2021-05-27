.global convert
.type matrix_mul, %function

.align 2
# int convert(char *);
convert:

    # insert your code here

    ADDI x30, x0, 0   # return int in x30
    ADDI x31, x0, 10  # for multification
    ADDI x5, x0, 0    # i in x5 = 0+0
    ADD x6, x5, a0    # address of input[i] in x6
    LBU x7, 0(x6)     # x7 = input[i]
    ADDI x28, x0, 45  # ASCII of -
    ADDI x29, x0, 0   # index in x29, 0 for positive, 1 for negative
    BNE x7, x28, L1   # branch if not -
    ADDI x29, x0, 1   # x29 = 1
    ADDI x5, x0, 1    # i = 1
L1: ADDI x28, x0, 43  # ASCII of +
    BNE x7, x28, L2   # branch if not +
    ADDI x5, x0, 1    # i = 1
L2: ADD x6, x5, a0    # address of number in input[i] in x6
    LBU x7, 0(x6)     # x7 = input[i]
    BEQ x7, x0, L3    # if end of character then end loop
    ADDI x28, x7, -58 # convert(input[i]) - 10 in x28
    BGE x28, x0, L4   # break if not digit
    ADDI x28, x7, -48 # convert(input[i]) in x28
    BLT x28, x0, L4   # break if not digit
    MUL x30, x30, x31 # int = int * 10
    ADD x30, x28, x30 # int = int + convert(input[i])
    ADDI x5, x5, 1    # i++
    JAL x0, L1        # go back to while loop
L3: ADD a0, x0, x30   # a0 = int
    BNE x29, x0, L5   # branch if negative
    ret
L5: XOR a0, x30, -1   # NOT(int), invert the bit
    ADDI a0, a0, 1    # a0 = a0 + 1
    ret               # complete positive to negative
L4: ADDI a0, x0, -1   # not digit, return -1

    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
    ret

