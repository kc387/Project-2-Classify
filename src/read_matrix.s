.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

	# Prologue
	addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    add s0, a0, x0 # pointer to string
    add s1, a1, x0 # pointer to int to store rows
    add s2, a2, x0 # pointer to int to store cols

    # open file
    mv a1 s0
    mv a2 x0
    jal ra fopen

	# check for error (fopen error)
    li t1 -1 
    beq a0, t1, error50 # don't have file descriptor

    mv s3 a0 # file descriptor

    # malloc sadness
    li a0 8
    jal ra malloc
    
    # check for error (malloc doesn't work right) -> malloced 0 space
    beq a0, x0, error48 
    
    mv s4 a0 # size of matrix (8 spaces)

	# fread cols & rows
    mv a1 s3 
    mv a2 s4 
    li a3 8
    jal ra fread
    
    # check for error (doesn't read 8 bytes like it was supposed to)
    li a3 8 
    bne a0, a3, error51 

    lw s5, 0(s4) 
    lw s6, 4(s4) 
    sw s5, 0(s1) #set row
    sw s6, 0(s2) #set col

    # malloc sadness 2.0
    mul a0, s5, s6
    slli a0, a0, 2
    jal ra malloc
    
    # check for error (malloc wrong -> 0 space allocated)
    beq a0, x0, error48 
    
    mv s7 a0 # matrix pointer

	# fread rest of matrix
    mv a1 s3
    mv a2 s7
    mul a3, s5, s6
    slli a3, a3, 2 
    jal ra fread

	# check for error (fread doesn't go right -> size read isn't right)
    mul a3, s5, s6 
    slli a3, a3, 2 
    bne a0, a3, error51 
    
    # close file
    mv a1, s3
    jal ra fclose
    
    # check for error (doesn't close right)
    bne a0, x0, error52 

    j done

done:
    mv a0 s7

    #Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44
    
    jr ra
    
    ret

error48:
    li a1 48
    jal exit2

error50:
    li a1 50
    jal exit2

error51:
    li a1 51
    jal exit2

error52:
    li a1 52
    jal exit2