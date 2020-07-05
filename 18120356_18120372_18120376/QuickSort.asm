####################################################
# Program Name: Quick Sort
# Programmer: Le Minh Hieu, Tran Trung Hieu
# Date last modified: 01/07/2020
####################################################
# Functional Description: 
# 1. Read array from file input
# 2. Sort array by using Quick sort
# 3. Write array to file output

.include "Macro.asm"
.data # Declare variables
filename_input: 	.asciiz "input_quicksort.txt"
filename_output: 	.asciiz "output_quicksort.txt"
array: 			.word 1000
.text
.globl main

main:
# ----------------------------------- Read array from file input -----------------------------------
# Open file input
	open_file(filename_input,0)	# Mode 0: read
	add $s6, $v0, $0		# Store file descriptor in $s0
	
# Read array from file input		
	read_file($s6)
	move $s7, $v0			# $s1 = $v0 = number of elements(N)
	la $t9, ($t4)			# $t9 = address of array = array[N-1]
	
# Close	file input
	close_file($s6)

# ----------------------------------- Sort array by using Quick sort -----------------------------------
	li $a1, 0
	addi $a2, $s7, -1
	move $a0, $t9
	
	jal QuickSort
	
	move $t9, $a0	
	
# ----------------------------------- Write array to file output -----------------------------------	
# Open file output
	open_file(filename_output,1) 	# Mode 1: write
	add $s6, $v0, $0		# Store file descriptor in $s0
	
# Write array to file output
	write_file($s6,$s7)		# $s7: array
	
# Close	file input
	close_file($s6)

# ----------------------------------- Exit program -----------------------------------		
exitProgram:
	li 	$v0, 10
 	syscall
 	
# ----------------------------------- Quick sort algorithm -----------------------------------	

QuickSort:
	#store $s and $ra
	subi $sp, $sp, 24
	sw		$s0, 0($sp)		#store s0
	sw		$s1, 4($sp)		#store s1
	sw		$s2, 8($sp)		#store s2
	
	sw		$a1, 12($sp)		#store a1
	sw		$a2, 16($sp)		#store a2
	sw		$ra, 20($sp)		#store ra

	#set $s
	move		$s0, $a1		#l = left
	move		$s1, $a2		#r = right
	move		$s2, $a1		#p = left

#while (l < r)
Loop_quick1:
	bge		$s0, $s1, Loop_quick1_done
	
#while (arr[l] <= arr[p] && l < right)
Loop_quick1_1:
	li		$t7, 4			# t7 = 4
	
	#t0 = arr[l]
	mult		$s0, $t7
	mflo		$t0			# t0 =  l * 4bit
	add		$t0, $t0, $a0		# t0 = &arr[l]
	lw		$t0, 0($t0)
	
	#t1 = arr[p]
	mult		$s2, $t7
	mflo		$t1			# t1 =  p * 4bit
	add		$t1, $t1, $a0		# t1 = &arr[p]
	lw		$t1, 0($t1)
	
	#check arr[l] <= arr[p]
	bgt		$t0, $t1, Loop_quick1_1_done
	
	#check l < right
	bge		$s0, $a2, Loop_quick1_1_done
	
	#l++
	addi		$s0, $s0, 1
	j		Loop_quick1_1
	
Loop_quick1_1_done:

#while (arr[r] >= arr[p] && r > left)
Loop_quick1_2:
	li		$t7, 4			# t7 = 4
	#t0 = arr[r]
	mult		$s1, $t7
	mflo		$t0			# t0 =  r * 4bit
	add		$t0, $t0, $a0		# t0 = arr[r]
	lw		$t0, 0($t0)
	
	#t1 = arr[p]
	mult		$s2, $t7
	mflo		$t1			#t1 =  p * 4bit
	add		$t1, $t1, $a0		#t1 = arr[p]
	lw		$t1, 0($t1)
	
	#check arr[r] >= arr[p]
	blt		$t0, $t1, Loop_quick1_2_done
	
	#check r > left
	ble		$s1, $a1, Loop_quick1_2_done
	
	#r--
	addi		$s1, $s1, -1
	
	j		Loop_quick1_2
	
Loop_quick1_2_done:

	#if (l >= r)
	blt		$s0, $s1, If_quick1_jump
	
	#SWAP (arr[p], arr[r])
	li		$t7, 4			#t7 = 4
	
	#t0 = arr[p]
	mult		$s2, $t7
	mflo		$t6			#t6 =  p * 4bit
	add		$t0, $t6, $a0		#t0 = &arr[p]
	
	#t1 = arr[r]
	mult		$s1, $t7
	mflo		$t6			#t6 =  r * 4bit
	add		$t1, $t6, $a0		#t1 = &arr[r]
	
	#Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	#quick(arr, left, r - 1)
	#set arguments
	move		$a2, $s1
	addi		$a2, $a2, -1		#a2 = r - 1
	jal		QuickSort
	
	#pop stack
	lw		$a1, 12($sp)		#load a1
	lw		$a2, 16($sp)		#load a2
	lw		$ra, 20($sp)		#load ra
	
	#quick(arr, r + 1, right)
	# set arguments
	move		$a1, $s1
	addi		$a1, $a1, 1		# a1 = r + 1
	jal		QuickSort
	
	#pop stack
	lw		$a1, 12($sp)		#load a1
	lw		$a2, 16($sp)		#load a2
	lw		$ra, 20($sp)		#load ra
	
	#return
	lw		$s0, 0($sp)		#load s0
	lw		$s1, 4($sp)		#load s1
	lw		$s2, 8($sp)		#load s2
	addi		$sp, $sp, 24		#Adjest sp
	jr		$ra

If_quick1_jump:
# SWAP (arr[l], arr[r])
	li		$t7, 4			#t7 = 4
	
	#t0 = arr[l]
	mult		$s0, $t7
	mflo		$t6			#t6 =  l * 4bit
	add		$t0, $t6, $a0		#t0 = arr[l]
	
	#t1 = arr[r]
	mult		$s1, $t7
	mflo		$t6			#t6 =  r * 4bit
	add		$t1, $t6, $a0		#t1 = arr[r]
	
	#Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		Loop_quick1
	
Loop_quick1_done:
	#return
	lw		$s0, 0($sp)		#load s0
	lw		$s1, 4($sp)		#load s1
	lw		$s2, 8($sp)		#load s2
	addi		$sp, $sp, 24		#Adjest sp
	jr		$ra
