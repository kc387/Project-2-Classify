.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

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

	add s0 a0 x0 # s0 -> pointer to string representing filename
    add s1 a1 x0 # s1 -> pointer to start of matrix in memory
    add s2 a2 x0 # s2 -> number of rows in matrix
    add s3 a3 x0 # s3 -> number of cols in matrix
    
    # fopen
    mv a1 s0 
    li a2 1
    jal ra fopen
    
    # check for error (fopen doesn't get a file descriptor)
    li t1 -1
    beq a0, t1, error53
    
    add s4 a0 x0 # file descriptor
    
    # malloc sadness
    li a0 8
    jal ra malloc
    
    # cehck for error (malloc only 0 space)
    beq a0, x0, error56
    
    mv s5 a0 # store first 8 bytes
    
    sw s2 0(s5) # rows
    sw s3 4(s5) # cols
    
    # fwrite
    mv a1 s4
    mv a2 s5
	li a3 2
    li a4 4
    jal ra fwrite
    
    # check for error (a0 != a3)
    li a3 2
    bne a0, a3, error54
    
    mv a1 s4
    mv a2 s1 # start of matrix in memory
    mul s6, s2, s3 # row * col
    mv a3 s6
    li a4 4
    jal ra fwrite
    
    # check for error (a0 != a3)
    bne a0, s6, error54
    
    # fclose
    mv a1 s4
    jal ra close
    
    # check for closing error
    bne a0, x0, error55
    
    j done
    
done:

    # Epilogue
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
    
error53:
	li a1 53
    jal exit2
    
error54:
	li a1 54
    jal exit2
    
error55:
	li a1 55
    jal exit2
    
error56:
	li a1 56
    jal exit2

