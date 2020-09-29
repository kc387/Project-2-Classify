.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "../../test_input.bin"

.text
main:
    # Read matrix into memory

    la s0 file_path
ebreak
    
    li a0 4
    jal ra malloc
    mv s1 a0

    li a0 4
    jal ra malloc
    mv s2 a0

    mv a0 s0
    mv a1 s1
    mv a2 s2

    jal ra read_matrix
    
    ebreak

    # Print out elements of matrix

    mv a0 a0
    lw a2 4(a1)
    lw a1 0(a1)
    
    jal print_int_array

    # Terminate the program
    jal exit