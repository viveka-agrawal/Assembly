############################################################################################################
# Created by: 	Agrawal, Viveka
# 		viagrawa
#		1 June 2021
# Assignment: 	Lab 4: Functions and Graphics
# 		CSE12, Computer Systems and Assembly Language
# 		UC Santa Cruz, Spring 2021
# Description:	This program implements functions that perform graphics operations on a simulated display.
# Note:		This program is intended to be run from the MARS IDE.
############################################################################################################


# Spring 2021 CSE12 Lab 4 Template
######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	srl %x, %input, 16			# shift %input to the right 16 bits and storing the value in %x
	andi, %y, %input, 0x000000FF		# ANDing %input and 0x000000FF and storing the value in %y
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	sll %output, %x, 16			# shifting %x and storing it in %output
	or %output, %output, %y			# ORing %output and %y to get output
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	# YOUR CODE HERE
	mul %output, %y, 128			# multiply %y and 128 and store the value in %output
	add %output, %output, %x		# add %output and %x and store the value in %output
	mul %output, %output, 4			# multiply %output and 4 and store the value in %output
	addi %output, %output, 0xFFFF0000	# add %output and 0xFFFF0000 and store the value in %output
.end_macro


.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	
	li $t1 0			# setting $t1 to 0
	
	whileLoopX:			# whileLoopX label
	beq $t1 128 exitX  		# if $t1 equals 128 jump to the label exitX
	
	li $t2 0			# setting $t2 to 0
	
	whileLoopY:			# whileLoopY label
	getPixelAddress($t3 $t1 $t2)	# obtain properly formatted pixel address 
	sw $a0 ($t3)			# store contents of $t3 into $a0
	addi $t2 $t2 1			# add 1 to $t2 and store the value in $t2
	beq $t2 128 exitY		# if $t2 is equal to 128 jump to label exitY
	j whileLoopY			# jump to the whileLoopY label
	
	exitY:				# exitY label
	addi $t1 $t1 1			# add 1 to $t1 and store the value in $t1
	j whileLoopX			# jump to the whileLoopX label
	
	exitX:				# exitX label
 	jr $ra					

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	
	getCoordinates($a0 $t4 $t5)	# obtain x and y coordinates from $a0 
	getPixelAddress($a0 $t4 $t5)	# obtain properly formatted pixel address
	sw $a1 ($a0)			# store contents of $a0 into $a1
	jr $ra				
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	
	getCoordinates($a0 $t4 $t5)	# obtain x and y coordinates from $a0
	getPixelAddress($a0 $t4 $t5)	# obtain properly formatted pixel address
	lw $v0 ($a0)			# store contents of $a0 into $v0
	jr $ra				

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	
	li $t6 0			# setting $t6 to 0
	
	firstPixelLoop:			# firstPixelLoop label
	beq $t6 128 firstExit		# if $t6 is equal to 128 jump to the label firstExit
	getPixelAddress($t7 $t6 $a0)	# obtain properly formatted pixel address 
	sw $a1 ($t7)			# store contents of $t7 into $a1
	addi $t6 $t6 1			# add 1 to $t6 and store the value in $t6
	j firstPixelLoop		# jump to the label firstPixelLoop
	
	firstExit:			# firstExit label
 	jr $ra				


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	
	li $t6 0			# setting $t6 to 0
	
	secondPixelLoop:		# secondPixelLoop label
	beq $t6 128 secondExit		# if $t6 equals 128 jump to the label secondExit
	getPixelAddress($t7 $a0 $t6)	# obtain properly formatted pixel address
	sw $a1 ($t7)			# store contents of $t7 into $a1
	addi $t6 $t6 1			# add 1 to $t6 and store the value in $t6
	j secondPixelLoop		# jump to the label secondPixelLoop
	
	secondExit:			# secondExit label
 	jr $ra				


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
	
	getCoordinates($a0 $t1 $t2)	# obtain x and y coordinates from $a0
	jal get_pixel			# jump and link to get_pixel
	push($v0)			# push $v0 to the stack
	push($t2)			# push $t2 to the stack
	push($t1)			# push $t1 to the stack
	move $a0 $t2			# move contents of $t2 into $a0
	jal draw_horizontal_line	# jump and link to the draw_horizontal_line label
	pop($t1)			# pop $t1 from the stack
	move $a0 $t1			# move contents of $t1 into $a0
	push($t1)			# push $t1 from the stack
	jal draw_vertical_line		# jump and link to the draw_vertical_line label
	pop($t1)			# pop $t1 from the stack
	pop($t2)			# pop $t2 from the stack
	pop($v0)			# pop $v0 from the stack
	getPixelAddress($t3 $t1 $t2)	# obtain properly formatted pixel address 
	sw $v0 ($t3)			# store contents of $t3 into $v0
	pop($ra)			# pop $ra from the stack
	
	# HINT: at this point, $ra has changed (and you're likely stuck in an infinite loop). 
	# Add a pop before the below jump return (and push somewhere above) to fix this.
	
	jr $ra				