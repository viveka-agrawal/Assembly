#########################################################################################
# Created by: 	Agrawal, Viveka
# 		viagrawa
#		15 May 2021
# Assignment: 	Lab 3: ASCII-risks (Asterisks)
# 		CSE12, Computer Systems and Assembly Language
# 		UC Santa Cruz, Spring 2021
# Description:	This program prints out a pattern with numbers and stars (asterisks).
# Note:		This program is intended to be run from the MARS IDE.
##########################################################################################

# PSEUDOCODE:
# I first created a while loop that checks for user input. The screen will keep prompting the user to enter a
# number greater than 0 until the user does so. Once the user enters a valid input, a nested
# while loop is entered. Again, if the user input is greater than 0, then the inner while loops will be entered.
# In the first inner while loop, tabs are printed. Then there is an if statement where if the number is even,
# it will increase by 2 and will be printed on the left side of the pattern. There is a second while loop inside
# the nested while loop where the asterisks are printed with a tab. There is another if statement where if the
# number is odd, it will increase by 2 and will be printed on the right side of the pattern. The nested while loop
# will not be exited until the user input is less than 0.

# REGISTER USAGE
# t0: user input
# $t1: tabasterisks
# $t2: user input - 1
# $t3: counter
# $t4: number of tabs
# $t5: also number of tabs
# $t6: value for remainder
# $t7: also tabasterisks
# $t8: used for storing user input value

.data

prompt: .asciiz "Enter the height of the pattern (must be greater than 0): \t"
invalidEntry: .asciiz "Invalid Entry! \nEnter the height of the pattern (must be greater than 0): \t"
newLine: .asciiz "\n"
tab: .asciiz "\t"
tabasterisk: .asciiz "\t*"

.text

li, $v0, 4			# using syscall 4
la, $a0, prompt			# loading prompt into argument register
syscall

li $v0, 5			# using syscall 5
syscall				# used for user input

move $t0, $v0			# store $v0 value in $t0

while:				# is input valid? check using while loop
bgt $t0, 0, validInput		# if $t0 >= 0, go to validInput label
li, $v0, 4			# using syscall 4
la, $a0, invalidEntry		# loading invalidEntry into argument register
syscall

li, $v0, 5			# using syscall 5 for user input
syscall

move $t0, $v0			# storing value from $v0 to $t0

j while				# jump to while loop


validInput:
sub $t8 $t0 2 			# subtracting user input by 2 and storing the value to $t8
li $t1 1 			# setting $t1 to have the value 1
sub $t2 $t0 1 			# subtracting user input by 1 and storing it into $t2

firstWhileLoop:
ble $t2 0 exitfirstWhileLoop 	# if the value at $t2 <= 0, go to label exitfirstWhileLoop
li $v0 4 			# using syscall 4
la $a0 tab 			# loading tab into argument register
syscall
sub $t2 $t2 1 			# subtract the value of $t2 by 1 and store it into $t2
j firstWhileLoop 		# jumping to firstWhileLoop

exitfirstWhileLoop:
li $v0 1 			# using syscall 1
li $a0 1 			# loading integer 1 into argument register
syscall
li $v0 4 			# using syscall 4
la $a0 newLine 			# loading newLine into argument register
syscall
li $t3 2 			# setting $t3 to have the value 2
sub $t4 $t0 2 			# subtracting user input by 2 and storing the value to $t4
sub $t2 $t0 1 			# subtracting user input by 1 and storing it to $t2

nestedWhileLoop:
ble $t2 0 exit 			# if $t2 <= 0, then exit
move $t5 $t4 			# set the value of $t4 to the register $t5

jump:

move $t5 $t8			# set the value of $t8 to the register $t5
whileInner1: 			# 3rd while loop, first inner while loop
ble $t5 0 exitwhileInner1 	# if the value at $t5 <= 0, go to the exitWhileInner1 label
li $v0 4			# using syscall 4
la $a0 tab 			# loading tab into argument register
syscall
sub $t5 $t5 1			# subtract $t5 by 1 and store the value in $t5
j whileInner1			# jump to the whileInner1 loop

exitwhileInner1:
addi $t8 $t8 -1			# add $t8 and -1 and store the value in $t8
beq $t8 -2 exit			# if $t8 = -2, go to exit
rem $t6 $t3 2			# storing the remainder of $t3/2 into $t6
bne $t6 0 afterIf		# if $t6 does not equal 0, go to the afterIf label
li $v0 1			# using syscall 1
add $a0 $t3 $zero		# adding $t3 and $zero and storing the value into $a0
syscall

afterIf:
add $t3 $t3 1			# add $t3 and 1 and store the value in $t3
move $t7 $t1			# move $t1 value into $t7

whileInner2:
beq $t7 0 exitWhileInner2	# if $t7 = 0, go to the exitWhileInner2 label
li $v0 4			# using syscall 4
la $a0 tabasterisk		# loading tabasterisk into argument register
syscall
sub $t7 $t7 1			# subtract $t7 by 1 and store the value in $t7
j whileInner2			# jump to whileInner2 loop

exitWhileInner2:
rem $t6 $t3 2 			# storing the remainder of $t3/2 into $t6
ble $t6 0 afterSecondIf		# if $t6 <= 0, go to the afterSecondIf label
li $v0 4			# using syscall 4
la $a0 tab			# loading tab into argument register
syscall
li $v0 1			# using syscall 1
add $a0 $t3 $zero		# adding $t3 and $zero and storing it in $a0
syscall
li $v0 4 			# using syscall 4
la $a0 newLine 			# loading newLine into argument register
syscall

afterSecondIf:
sub $t2 $t2 1 			# subtracting $t2 by 1 and storing it into $t2
add $t3 $t3 1 			# adding $t3 by 1 and storing it into $t3
add $t1 $t1 2 			# adding $t1 by 2 and storing it into $t1
sub $t4 $t4 1 			# subtracting $t4 by 1 and storing it into $t4

j jump 				# jumping to label jump

exit:
la $a0 newLine			# making sure that the bottom of the program reads
li $v0 10			# --program is finished running--
syscall
