.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    add s0, a0, x0 # s0 -> pointer to vector
    add s1, a1, x0 # s1 -> number of elements in vector

loop_start:
	li s2 0 # pointer thing for indexing thing
    lw s4 0(s0) # s4 represents greatest current value

loop_continue:
	bge s2 s1 loop_end 
	lw s3 0(s0) # get value at vector[0] and stick it in s3 YAY
    blt s3 s4 less_than # if s3 < s4 goto less_than
    add s4, s3, x0 # s4 = s3
    add a0, s2, x0 # a0 = s2
    
less_than:
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
    lw s4, 20(sp)
    addi sp, sp, 20

    jr ra

    # Epilogue


    ret