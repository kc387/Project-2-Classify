.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    add s0, s0, x0 # s0 -> pointer to array
    add s1, s1, x0 # s1 -> number of elements in array

loop_start:
    li s2 0 

loop_continue:
    bge s2 s1 loop_end
    lw s3 0(s0)
    blt x0 s3 greater_than_zero # if s3 > 0 goto greater_than_zero
    li s3 0

greater_than_zero:
    sw s3 0(s0)
    addi s0 s0 4
    addi s2 s2 1
    j loop_continue

loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    jr ra

    # Epilogue

    
	ret