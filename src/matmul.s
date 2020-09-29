.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

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
    
    add s0, a0, x0 # s0 -> pointer to start of m0 (left matrix)
    add s1, a1, x0 # s1 -> # rows of m0
    add s2, a2, x0 # s2 -> # cols of m0
    add s3, a3, x0 # s3 -> pointer to start of m1 (right matrix)
    add s4, a4, x0 # s4 -> # rows of m1
    add s5, a5, x0 # s5 -> # cols of m1
    add s6, a6, x0 # s6 -> pointer to start of d (return matrix)
    add s9, a3, x0
    
    # Error checks
    li t0 1
    blt s1 t0 error2
    blt s2 t0 error2
    blt s4 t0 error3
    blt s5 t0 error3
    bne s2 s4 error4

loop_start:
	li s7 0 # s7 -> which row of m0 you are on
    li s8 0 # s8 -> which col of m1 you are on
    li t1 1 # stride of m0
    li t2 0
    add t2, t2, s5 # stride of m1
    
outer_loop_start:
    bge s7 s1 end

inner_loop_start:
    bge s8 s5 outer_loop_end
    # dot
    mv a0 s0
    mv a1 s3
    mv a2 s2
    li a3 1
    mv a4 s5
    jal ra dot
	sw a0 0(s6) # store dot in d[0]
    addi s6, s6, 4 # shift over one
    addi s3, s3, 4
    addi s8, s8, 1
    j inner_loop_start
    
outer_loop_end:
	mv s3 s9
    li t4 4
    mul t3, t4, s2
    add s0, s0, t3
    addi s7, s7, 1
    li s8, 0
    j outer_loop_start
    
end:
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
    

	# error
error2:
	li a1 2
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
    jal exit2
    
error3:
	li a1 3
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
    jal exit2
    
error4:
	li a1 4
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
    jal exit2

    # Epilogue
    
    
    ret