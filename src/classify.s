.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
	
    addi sp, sp, -52
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
    sw s10, 44(sp)
    sw s11, 48(sp)

	lw s1 4(a1) # m0
    lw s2 8(a1) # m1
    lw s3 12(a1) # input
    lw s4 16(a1) # output

	add s5, a2, x0 # print_classification -> if 0 print classification; else don't print anything
    
    # check error -> if argc != 5
    li t1 5
    bne a0, t1, error49 
    
	# =====================================
    # LOAD MATRICES
    # =====================================

	# malloc sadness (for row & col stuff)
    li a0 24
    jal ra malloc
    
    # check for error (malloc correctly)
    beq a0, x0, error60
    
    mv s6 a0 # s6 -> row & col pointer
    
    # 	arguments for read_matrix
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    
    # Load pretrained m0
	mv a0 s1 
    mv a1 s6 # rows
    addi a2, s6, 4 # cols
    jal ra read_matrix
    mv s7 a0 # s7 -> m0 matrix

    # Load pretrained m1
	mv a0 s2
    addi a1, s6, 8 # rows
    addi a2, s6, 12 # cols
    jal ra read_matrix
    mv s8 a0 # s8 -> m1 matrix

    # Load input matrix
    mv a0 s3
    addi a1, s6, 16 # rows
    addi a2, s6, 20 # cols
    jal ra read_matrix
    mv s9 a0 # s9 -> input matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    
    # malloc sadness 2.0 (output arra)
    lw a1 0(s6)
    lw a2 20(s6)
    mul a0, a1, a2
    slli a0, a0, 2 # num bytes need
    jal ra malloc
    
    # check error (doesn't malloc correctly)
    beq a0, x0, error60
    
    mv s10 a0 # s10 -> space malloced for output
    
    # matmul s10 = m0 * input
    # 	a0 (int*)  is the pointer to the start of m0 
	#	a1 (int)   is the # of rows (height) of m0
	#	a2 (int)   is the # of columns (width) of m0
	#	a3 (int*)  is the pointer to the start of m1
	# 	a4 (int)   is the # of rows (height) of m1
	#	a5 (int)   is the # of columns (width) of m1
	#	a6 (int*)  is the pointer to the the start of d
    mv a0 s7
    lw a1 0(s6)
    lw a2 4(s6)
    mv a3 s9
    lw a4 16(s6)
    lw a5 20(s6)
    mv a6 s10
    jal ra matmul
    
    # 2. NONLINEAR LAYER: s10 = ReLU(m0 * input)
    # Arguments:
	# 	a0 (int*) is the pointer to the array
	#	a1 (int)  is the # of elements in the array
    mv a0 s10 # s10 = m0 * input
    lw a1 0(s6)
    lw a2 20(s6)
    mul a1, a1, a2
    jal ra relu 
    
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # malloc sadness 3.0 (malloc space for output array)
    lw a1 8(s6)
    lw a2 20(s6)
    mul a0, a1, a2
    slli a0, a0, 2 # total num bytes for malloc
    jal ra malloc
    
    # check for error (malloc doesn't run properly)
    beq a0, x0, error60
    
    mv s11 a0 # s11 holds malloced space
    
    # matmul s11 = m1 * ReLU(m0 * input) <- s10
    # 	a0 (int*)  is the pointer to the start of m0 
	#	a1 (int)   is the # of rows (height) of m0
	#	a2 (int)   is the # of columns (width) of m0
	#	a3 (int*)  is the pointer to the start of m1
	# 	a4 (int)   is the # of rows (height) of m1
	#	a5 (int)   is the # of columns (width) of m1
	#	a6 (int*)  is the pointer to the the start of d
    mv a0 s8
    lw a1 8(s6)
    lw a2 12(s6)
    mv a3 s10
    lw a4 0(s6)
    lw a5 20(s6)
    mv a6 s11
    jal ra matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
	#   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is the pointer to the start of the matrix in memory
    #   a2 (int)   is the number of rows in the matrix
    #   a3 (int)   is the number of columns in the matrix

	mv a0 s4
    mv a1 s11
    lw a2 8(s6)
    lw a3 20(s6)
    jal ra write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
	# 	a0 (int*) is the pointer to the start of the vector
    #	a1 (int)  is the # of elements in the vector
	mv a0 s11
	lw a2 8(s6)
    lw a3 20(s6)
    mul a1, a2, a3 # elements in vector
    jal ra argmax

	mv t0 a0 # store index of largest element
    addi sp, sp, -4
    sw t0 0(sp) # store t0 (if needed) -> have to use t register bc all s registers are used

	# s5 != 0 -> nothing printed
    bne s5, x0, done 
    
    # Print classification
    mv a1 t0 # print max value
    jal ra print_int
    
    # Print newline afterwards for clarity
	li a1 '\n'
    jal ra print_char

done:
	lw t0, 0(sp)
    addi sp, sp, 4
    mv a0 t0
    
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
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    ret
    
error49:
    li a1 49
    jal exit2

error60:
    li a1 60
    jal exit2