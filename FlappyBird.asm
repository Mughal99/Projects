# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
	blue: .word	0x62d9fc
	red: .word	0xff0000
	green: .word	0x0dba24
	pink: .word	0xf576e8

.globl main  # executes main first
.text
	lw $t0, displayAddress	# $t0 stores the base address for display

main:

	lw $a0, blue
	jal func_draw_sky
	
	li $a0, 15
	li $a1, 18
	li $a2, 3
	li $a3, 4
	jal func_draw_obstacles
	
	li $a0, 10
	jal function_draw_bird
	j Exit

		
func_draw_sky: 	# paint the whole screen 
#a0 color
	li $t4, 1095
	move $t5, $a0	# move $a0 to $t5
	sw $t5, 0($t0)
	lw $t0, displayAddress	# $t0 stores the base address for display
	WHILE_sky:
		beqz $t4, DONE_sky   # if $t4 is 0, exits the while loop
		addi $t0, $t0, 4
		sw $t5, 0($t0)
		   
		addi $t4, $t4, -1 
		j WHILE_sky
	DONE_sky:
	jr $ra
	

func_draw_obstacles:
# a0 a1 a2 a3

	move $t7, $ra
	lw $s7, displayAddress 
	lw $s6, green
	li $s5 32
	li $s4 4
	move $s0, $a0	# move $a0 to $t5, $a0 = px0 static
	move $s1, $a1	# move $a1 to $t1, $a1 = px1
	move $s2, $a2	# move $a2 to $t2, $a2 = py0
	move $s3, $a3	# move $a3 to $t3, $a3 = py1
	
	move $t0, $a0		# px start point
	move $t1, $a1		# px end point
	move $t2, $a2		# up length
	move $t3, $a3		# down length
		
	WHILE_OBSTACLE_1:
		beq $t0, $s1, DONE_OBSTACLE_1   # if $a0 = $a1, exits the while loop
		move $t2, $s2			# draw from left down side to left top side
		WHILE_OBSTACLE_COL:
			bltz, $t2, DONE_OBSTACLE_COL	#terminate if pass the first row
			
			#call function to get offset
			move $a0, $t0	# $t0 = px0
			move $a1, $t2	# $t2 = py0
			jal function_get_obsolute_offset
			# return value = $v0
			
			# once get offset, apply it to start point s7
			add $v0, $v0, $s7	# $t9 = (py0 * 32 + px0) * 4 + $s7
			sw $s6, 0($v0)
			
			addi, $t2, $t2, -1	# $py0 -= 1
			j WHILE_OBSTACLE_COL
			
		DONE_OBSTACLE_COL:
			addi $t0, $t0, 1
			j WHILE_OBSTACLE_1
		
	DONE_OBSTACLE_1:
	


	move $t0, $s0   # start px  = a0
	li $t2, 31 	# start py
	sub $t8, $t2, $s3 # end py 31 - down_length

	WHILE_OBSTACLE_2:
	# 4 * (32*py + px)
		# check if to meet end px: a1
		beq $t0, $s1, DONE_OBSTACLE_2   # if $a0 = $a1, exits the while loop
		li $t2, 31 	# start py
		WHILE_OBSTACLE_COL_2:
			blt, $t2, $t8, DONE_OBSTACLE_COL_2
			
			#call function to get offset
			move $a0, $t0	# $t0 = px0
			move $a1, $t2	# $t3 = py1
			jal function_get_obsolute_offset
			# return value = $v0
			
			# once get offset, apply it to start point s7
			add $v0, $v0, $s7	
			sw $s6, 0($v0)
			
			addi, $t2, $t2, -1	# $py1 -= 1
			j WHILE_OBSTACLE_COL_2
			
		DONE_OBSTACLE_COL_2:
			addi $t0, $t0, 1
			j WHILE_OBSTACLE_2
		
	DONE_OBSTACLE_2:
	jr $t7

function_draw_bird:
#start_point #a0 = py
# px = 5
	lw $s0, pink
	lw $s1, displayAddress
	li $s2, 5	# $s2 = px
	move $s3, $a0	# $s3 = py
	
	# last col upper
	move $a0, $s2
	addi $t0, $s3, -1
	move $a1, $t0
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)	
	
	# last col middle
	move $a0, $s2
	move $a1, $s3
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)
	
	# last col lower
	move $a0, $s2
	addi $t0, $s3, 1
	move $a1, $t0
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)	
	
	# middle connect pont
	addi $t0, $s2, 1
	move $a0, $t0
	move $a1, $s3
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)
	
	# front col upper
	addi $t0, $s2, 2
	move $a0, $t0
	addi $t1, $s3, -1
	move $a1, $t1
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)	
	
	# front col middle
	addi $t0, $s2, 2
	move $a0, $t0
	move $a1, $s3
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)	
	
	# front col lower
	addi $t0, $s2, 2
	move $a0, $t0
	addi $t0, $s3, 1
	move $a1, $t0
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)
	
	# front
	addi $t0, $s2, 3
	move $a0, $t0
	move $a1, $s3
	jal function_get_obsolute_offset
	add $v0, $v0, $s1	
	sw $s0, 0($v0)	
	jr $ra




function_get_obsolute_offset:
		
	mult $s5, $a1	# $s5 = 32
	mflo $a1	# $t6 = py0 * 32
	add $a0, $a1, $a0	# $t5 = py0 * 32 + px0
	mult $a0, $s4	# $t4 = 4
	mflo $v0	# $t5 = (py0 * 32 + px0) * 4
	
	jr $ra		
	
	
	
	
	

	
	
	
	
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
	