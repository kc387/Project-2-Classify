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
	addi sp, sp, -40
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
	
    add s0, a0, x0 # pointer to string
    add s1, a1, x0 # pointer to int to store rows
    add s2, a2, x0 # pointer to int to store cols
    
	
	# fopen
    mv a1 s0
    mv a2 x0
	jal ra fopen
    add s3, a0, x0 # store a0

	# fread rows
    mv a1 s3
    mv a2 s1
    li t1 4
    mv a3 t1
    jal ra fread

	# fread col
    mv a1 s3
    mv a2 s2
    li t1 4
    mv a3 t1
    jal ra fread
    
    # fread col
    mv a1 s3
    mv a2 a0
    li t1 4
    mul s4, s1, s2
    mul s5, s4, t1
    mv a3 s5
    jal ra fread

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
    addi sp, sp, 40
    
    # Epilogue


    ret