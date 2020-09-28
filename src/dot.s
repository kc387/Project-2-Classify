.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
	addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    
    add s0, a0, x0 # s0 -> pointer to vector v0
    add s1, a1, x0 # s1 -> pointer to vector v1
    add s2, a2, x0 # s2 -> length of vectors
    add s3, a3, x0 # s3 -> stride of v0
    add s4, a4, x0 # s4 -> stride of v1

loop_start:
	li s5 0 # pointer thing for indexing thing
    addi t1, t1, 4
    mul t2, s3, t1
    mul t3, s4, t1


loop_continue:
	bge s5 s2 loop_end 
    lw s6 0(s0) # get value at v0[0] and stick it in s6 YAY
    lw s7 0(s1) # get value at v1[0] and stick it in s7 YAY
    mul t0, s6, s7 # t0 = s6 * s7
    add a0, a0, t0 # add t0 to a0
    
    sw s6 0(s0)
    sw s7 0(s0)
    #add s0, s0, t2
    addi s0, s0, 4
    #add s1, s1, t3
    addi s1, s1, 4
    addi s5, s5, 1 # index increases by 1
    j loop_continue


loop_end:
	lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    addi sp, sp, 32

    jr ra


    # Epilogue

    
    ret