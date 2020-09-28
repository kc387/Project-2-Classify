.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

# static values for testing
.data
m0: .word 1 2 3 4 #5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 #9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    
    la s0 m0
    li s1 1
    li s2 4
    la s3 m1
    li s4 4
    li s5 2

    la s6 d

    mv a0 s0
    mv a1 s1
    mv a2 s2
    jal print_int_array





    # Call matrix multiply, m0 * m1

    mv a0 s0
    mv a1 s1
    mv a2 s2
    mv a3 s3
    mv a4 s4
    mv a5 s5
    mv a6 s6

    jal ra matmul



    # Print newline

    li a1 '\n'
    jal print_char
    

    



    # Print the output (use print_int_array in utils.s)

    mv a0 a6
    li a1 1
    li a2 2
    jal print_int_array




    # Exit the program
    jal exit











     # Print m0 before running relu
    mv a0 s0
    mv a1 s1
    mv a2 s2
    jal print_int_array

    # Print newline
    li a1 '\n'
    jal print_char