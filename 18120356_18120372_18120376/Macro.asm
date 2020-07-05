.data
buffer: 		.space 100

# Push reg to stack
.macro stack_push (%reg)
    sub $sp, $sp, 4
    sw %reg, ($sp)
.end_macro

# Pop from stack and store to reg
.macro stack_pop (%reg)
    lw %reg, ($sp)
    add $sp, $sp, 4
.end_macro

# Open file
.macro open_file (%filename, %mode)
.text
li $v0, 13			# 13: open file
la $a0, %filename		# $a0: name of file
addi $a1, $0, %mode		# $a1: mode 0: read, 1: write
addi $a2, $0, 0
syscall				# open file, $v0: file descriptor
.end_macro

# Read file
.macro read_file (%fileDescriptor)
li $t1, 0	# Initialize "sum" variable to store element
li $t2, 0	# "check" variable to check if an element is a number of array
la $t4, array	# t4: address of array
li $t5, 0   	# "index" variable
readNumber:
	li $v0, 14 			# System call: 14 = read from file
 	move $a0, %fileDescriptor 	# Copy file descriptor to argument
 	la $a1, buffer			# Address of buffer from which to read
 	li $a2, 1			# Buffer length			
 	syscall 			# Read from file
 	
 	lb $t0, buffer			# Byte read save to $t0
 	
 	beq $v0, $0, end		# Handle EOF
 	beq $t0, 10, readElements	# Handle '\n'
 	beq $t0, 13, readElements	# Handle '\r'
 	beq $t0, 32, readElements	# Handle ' '
 	
 	addi $t0, $t0, -48		# Get number from its ASCII code	
	mul $t1, $t1, 10		# t1 = t1 * 10
	add $t1, $t1, $t0		# t1 = t1 + t0
	j readNumber			# Loop
readElements:
	beq $t2,0,returnNumOfElements	# If check = 0, return number of elements
	sll $t6,$t5,2			# t6 = i*4
	add $t6, $t4, $t6		# t6 = array + 4*i
	sw $t1, ($t6)			# Store t1 to array	
	addi $t5,$t5,1			# i++
	li $t1,0			# Reset "sum" to 0
	j readNumber			# Loop
returnNumOfElements:
	stack_push($t1)			# Push $t1 to stack
	stack_pop($t3)			# Pop from stack and store to $t3
	li $t1,0			# Reset "sum" to 0
	addi $t2,$t2,1			# "Check" = 1: success to find number of elements
	j readNumber
end:
	sll $t6,$t5,2			# t6 = i*4
	add $t6, $t4, $t6		# t6 = array + 4*i
	sw $t1, ($t6)			# Store t1 to array	
	move $v0,$t3			# Store number of elements to v0
.end_macro

# Write file
.macro write_file(%fileDescriptor,%size)
move $a0, %fileDescriptor 	# File descriptor 
li $t1, 0			# $t1 = i = 0
write:
	beq $t1,%size,writedone	# If $t1 = array size: return writedone
	
	sll $t2,$t1,2		# t6 = i*4
	add $t2, $t9, $t2	# t6 = array + 4*i
	lw $t3, ($t2)		# Store t1 to array	
				# Pop from stack and store to $t2
	addi $t1,$t1,1		# $t1++
	IntToString($t3)	# Convert $t2 from interger to string $v1
	
# Print number to file	
	la $a1,buffer		# Adress of output buffer
	move $a2,$v1		# $a2 = $v1
	addi $a2,$a2,1 		# For space
	li $v0,15		# System call for write to file
	syscall			# Write to file
	j write			# Start loop
writedone:
.end_macro

# Convert from int to string
# Store i in buffer then convert to string and save at $v1
.macro IntToString(%i) 
la $t4,buffer 		# Load adress of buffer to $t4
beqz %i,Zero		# Because i = 0 can't be divided anymore, so return NULL
li $t5, 10		# Base = 10
li $t6, 0		# Count digit to convert
while:
	beqz %i,done	# if i = 0, return done
	addi $t6,$t6,1	# Increase number of digit
	div %i,$t5	# i = i / 10
	mfhi $t8	# Store remainder to $t8
	stack_push($t8) # Push $t8 to stack
	mflo %i		# Store quotient to i
	j while		# Start loop
Zero:
	addi %i,%i,48	# Change digit into ASCII code
	sb %i, ($t4)	# Store i to buffer
	addi $t4,$t4,1	# Point to next element
	li $v1, 1	# Number of digit
	j end
done:
	move $v1,$t6	# Number of digit
	while2:
		beqz $t6,end	# If number of digit = 0, return end
		subi $t6,$t6,1	# Decrease number of digit
		stack_pop($t7)	# Pop from stack and store to $t7
		addi $t7,$t7,48 # Change digit into ASCII code
		sb $t7,($t4)	# Store t7 to t4
		addi $t4,$t4,1	# Point to next element
		j while2 	# Start loop
end:
	li $t7, 32		# Space
	sb $t7, ($t4)		# Write space to buffer
.end_macro

# Close file
.macro close_file(%fileDescriptor)
li $v0,16			# System call: 16 = close file
move $a0,%fileDescriptor
syscall
.end_macro
