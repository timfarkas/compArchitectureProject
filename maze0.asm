.data
myarray: .ascii "0000, 0000, 0000, 0000, 0000, 0000, 0000, 1000, 0110, 1000, 1110, 0011, 0000, 1100, 1111, 0010, 0101, 0100, 0000, 0001, 1001, 1110, 0011, 0101, 0000, 1100, 1110, 0111, 1000, 0111, 0000, 0001, 0101, 1001, 1110, 0011, 1000, 1000, 1011, 0010, 1001, 0010,"
# Each cell contains 4 digits of number, 1 digit of ',' , and 1 digit of ' '. The 4 numeric digits stand for 4 operations, which are "Forward,Right,Back,Left" respectively, where "0" stands for wall, "1" stands for valid path
# All cells in the first row and first column are considered outside the maze, and are filled with number "0000", except for the starting point.
# The maze is 5x6 

mazewidth: .word 6
ycord: .word 6 # The beginning point of the robot, which is row 6. Input ranges from 0-6 (7 rows in total).
xcord: .word 0 # The beginning point of the robot, which is column 0. Input ranges from 0-5 (6 columns in total). Input above 5 will make the address jumping to next row and return wrong result.

exit_ycord: .word 0 # The exit of the maze, which is row 0.
exit_xcord: .word 5 # The exit of the maze, which is column 5.

mistakes: .word 0     # Number of mistakes
total_moves: .word 0  # Total number of moves

welcome_msg: 
    .asciiz "\n\nWelcome to the MiPS maze solver!\nSteer the robot by enter directions: R for right, L for left, F for forward, and B for backward.\n"
enter_maze_msg: 
    .asciiz "\nInput F to enter the maze.\n"
maze_start_msg:
    .asciiz " ---- YOU ENTER THE MAZE"
move_error_msg:
    .asciiz "\nInvalid move! Try again..."
stuck_msg:
    .asciiz "\nYou are stuck in the wall. Please get out first."
new_line:
    .asciiz "\n"
exit_msg:
    .asciiz "\nCongratulations! You reached the exit.\nNumber of mistakes: "
total_moves_msg:
    .asciiz "\nTotal number of moves: "
input_error_msg:
    .asciiz "\nInvalid input! Please enter R, L, F, or B. (Uppercase or Lowercase)"
empty_msg:
    .asciiz "\nEmpty input. Abort the program now.\n"
arrow: 
    .asciiz "->"

.text
.globl main
main:
    la $s0, myarray       # Load the base address of the maze
    lw $s1, mazewidth     # Load maze width into $s1
    lw $s2, exit_xcord     # Load maze exit x-coordinate into $s2
    lw $s3, exit_ycord     # Load maze exit y-coordinate into $s3

     # $s4 is reserved to load 10, which is '\n' in ascii. This is used to escape program with empty user input
        
    lw $t0, xcord         # Load x-coordinate into $t0
    lw $t1, ycord         # Load y-coordinate into $t1
    lw $t2, mistakes      # Load the number of mistakes into $t2
    lw $t3, total_moves   # Load the total number of moves into $t3

     # $t4 is reserved to save user input
     # $t5 is reserved to save the beginning address of a cell in the 1-D array
     # $t6 is reserved to save the value of a certain direction (wall) within a certain cell
     # $t7 is reserved for checking if the move direction is valid
     # $t8 is reserved for checking if the input is correct when the robot has been stuck in a wall
     # $t9 is reserved for checking if user input is valid
    
    la $a0, welcome_msg   # Load the address of the welcome message
    li $v0, 4             # Print the welcome message
    syscall

    j beginning_loop

# loops until user enters maze
beginning_loop:
    la $a0, enter_maze_msg   # Load the address of the enter maze message
    li $v0, 4             # Print the enter maze message
    syscall

    # Read inital character
    addi $v0, $zero, 12 
	syscall
	move $v1, $v0

    beq $v1, 'F', start_maze
    beq $v1, 'f', start_maze
    li $s4, 10                 # 10 is '\n' in ascii, this code is used to escape program with empty user input
    beq $v1, $s4, empty_abort
	j beginning_loop

# informs user they have entered the maze and starts main loop
start_maze:
    jal increase_xcord
    # Increment the total moves counter
    addi $t3, $t3, 1
    sw $t3, total_moves

	addi $v0, $zero, 4 
	la $a0, maze_start_msg
	syscall
	j main_loop

main_loop:
    # Get user input (direction)
    jal get_user_input
    move $t4, $v1            # Store the user input (R, L, F, B) in $t4
    
    # Update the robot's position based on the user input

    jal update_position

    # Check if the robot has reached the exit
    jal check_exit
    beq $v0, 1, exit           # If reached exit, go to exit
    
    j main_loop                # Otherwise, continue with the main loop
    
get_user_input:
    la $a0, new_line
    li $v0, 4
    syscall
    
    # Read user input (F, B, L, R)
    addi $v0, $zero, 12
    syscall
    move $v1, $v0

    # Check if the user input is valid (F, B, L, R)
    li $t9, 'F'
    beq $v1, $t9, valid_input
    li $t9, 'f'
    beq $v1, $t9, valid_input
    li $t9, 'B'
    beq $v1, $t9, valid_input
    li $t9, 'b'
    beq $v1, $t9, valid_input
    li $t9, 'L'
    beq $v1, $t9, valid_input
    li $t9, 'l'
    beq $v1, $t9, valid_input
    li $t9, 'R'
    beq $v1, $t9, valid_input
    li $t9, 'r'
    beq $v1, $t9, valid_input
    
    li $s4, 10                 # 10 is '\n' in ascii, this code is used to escape program with empty user input
    beq $v1, $s4, empty_abort

    # Invalid input: Show error message and repeat
    la $a0, input_error_msg
    li $v0, 4
    syscall
    j get_user_input

valid_input:
    # Input is valid; proceed
    jr $ra
    
update_position:
    # Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    # Increment the total moves counter
    addi $t3, $t3, 1
    sw $t3, total_moves

    # Update the robot's position based on the user input
    beq $t4, 'F', move_forward
    beq $t4, 'f', move_forward
    beq $t4, 'B', move_backward
    beq $t4, 'b', move_backward
    beq $t4, 'L', move_left
    beq $t4, 'l', move_left
    beq $t4, 'R', move_right
    beq $t4, 'r', move_right

    # Restore return address and stack pointer
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back

    jr $ra

decrease_xcord:
    # Decrease the x-coordinate by one
    addi $t0, $t0, -1 
    jr $ra

increase_xcord:
    # Increase the x-coordinate by one
    addi $t0, $t0, 1 
    jr $ra

decrease_ycord:
    # Decrease the y-coordinate by one
    addi $t1, $t1, -1 
    jr $ra

increase_ycord:
    # Increase the y-coordinate by one
    addi $t1, $t1, 1 
    jr $ra


move_forward:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    #check if valid move
    jal check_forward ### this returns only if move is valid

    jal increase_xcord ## move forward

    ## Restore return address and stack pointer
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back

    jr $ra

move_backward:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    #check if valid move
    jal check_backward ### this returns only if move is valid
    
    jal decrease_xcord

    ## Restore return address and stack pointer
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back

    jr $ra

move_left:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    #check if valid move
    jal check_left ### this returns only if move is valid
    
    jal decrease_ycord ## move left

    ## Restore return address and stack pointer
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back
    
    jr $ra

move_right:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address
    
    #check if valid move
    jal check_right 
    
    jal increase_ycord ## move right

    ## Restore return address and stack pointer
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back

    jr $ra

check_forward:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    jal load_cell_address # Load beginning address of current cell
    
    lb $t6,0($t5)  # return the forward direction value within current cell 
    li $t7, '1'  # load '1' into temporary register for later use (indeed, this variable can also be assigned at the begining)
    beq $t7, $t6, return_label ### check if this direciton is valid with value of "1". Return to move function if valid move
    j invalid_move_forward ## jump to invalid_move_forward if invalid

check_right:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    jal load_cell_address # Load beginning address of current cell
    
    lb $t6,1($t5)  # return the right direction value within current cell 
    li $t7, '1' # load '1' into temporary register for later use (indeed, this variable can also be assigned at the begining)
    beq $t7, $t6, return_label ### check if this direciton is valid with value of "1". Return to move function if valid move
    j invalid_move_right ## jump to invalid_move_right move if invalid

check_backward:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address
    
    jal load_cell_address # Load beginning address of current cell
    
    lb $t6,2($t5)   # return the back direction value within current cell 
    li $t7, '1' # load '1' into temporary register for later use (indeed, this variable can also be assigned at the begining)
    beq $t7, $t6, return_label ### check if this direciton is valid with value of "1". Return to move function if valid move
    j invalid_move_backwards ## jump to invalid_move_backwards if invalid

check_left:
    ## Update stack with return address
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp)         # Save return address

    jal load_cell_address # Load beginning address of current cell
    
    lb $t6,3($t5)  # return the left direction value within current cell 
    li $t7, '1'  # load '1' into temporary register for later use (indeed, this variable can also be assigned at the begining)
    beq $t7, $t6, return_label  ### check if this direciton is valid with value of "1". Return to move function if valid move
    j invalid_move_left ## jump to invalid_move_left if invalid

return_label:
    ## Restore return address and stack pointer
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back
    jr $ra

invalid_move_forward:
    li $v0, 4 # initialise the programme to print a string
    la $a0, move_error_msg # load error message into $a0
    syscall # execute the string being printed

    # Save return address before calling get_user_input 
    addi $sp, $sp, -4 
    sw $ra, 0($sp) 
    jal get_user_input # Use the existing get_user_input function 
    
    # Restore return address 
    lw $ra, 0($sp) 
    addi $sp, $sp, 4

    addi $t2, $t2, 1 # increment the number of mistakes by 1
    sw $t2, mistakes # save the number of mistakes to the 'mistakes' variable

    li $t8, 'B' # load the character 'B' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'B' to get unstuck
   
    li $t8, 'b' # load the character 'b' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'b' to get unstuck
    
    la $a0, stuck_msg
    li $v0, 4
    syscall

    j invalid_move_forward # if 'B' or 'b' is not entered run invalid_move_forward again

invalid_move_backwards:
    li $v0, 4 # initialise the programme to print a string
    la $a0, move_error_msg # load error message into $a0
    syscall # execute the string being printed

    # Save return address before calling get_user_input 
    addi $sp, $sp, -4 
    sw $ra, 0($sp) 
    jal get_user_input # Use the existing get_user_input function 
    
    # Restore return address 
    lw $ra, 0($sp) 
    addi $sp, $sp, 4

    addi $t2, $t2, 1 # increment the number of mistakes by 1
    sw $t2, mistakes # save the number of mistakes to the 'mistakes' variable

    li $t8, 'F' # load the character 'F' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'F' to get unstuck
    
    li $t8, 'f' # load the character 'f' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'f' to get unstuck
    
    la $a0, stuck_msg
    li $v0, 4
    syscall

    j invalid_move_backwards # if 'F' or 'f' is not entered run invalid_move_backwards again

invalid_move_left:
    li $v0, 4 # initialise the programme to print a string
    la $a0, move_error_msg # load error message into $a0
    syscall # execute the string being printed

    # Save return address before calling get_user_input 
    addi $sp, $sp, -4 
    sw $ra, 0($sp) 
    jal get_user_input # Use the existing get_user_input function 
    
    # Restore return address 
    lw $ra, 0($sp) 
    addi $sp, $sp, 4

    addi $t2, $t2, 1 # increment the number of mistakes by 1
    sw $t2, mistakes # save the number of mistakes to the 'mistakes' variable

    li $t8, 'R' # load the character 'R' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'R' to get unstuck

    li $t8, 'r' # load the character 'r' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'r' to get unstuck

    la $a0, stuck_msg
    li $v0, 4
    syscall
    
    j invalid_move_left # if 'R' or 'r' is not entered run invalid_move_left again

invalid_move_right:
    li $v0, 4 # initialise the programme to print a string
    la $a0, move_error_msg # load error message into $a0
    syscall # execute the string being printed

    # Save return address before calling get_user_input 
    addi $sp, $sp, -4 
    sw $ra, 0($sp) 
    jal get_user_input # Use the existing get_user_input function 
    
    # Restore return address 
    lw $ra, 0($sp) 
    addi $sp, $sp, 4

    addi $t2, $t2, 1 # increment the number of mistakes by 1
    sw $t2, mistakes # save the number of mistakes to the 'mistakes' variable

    li $t8, 'L' # load the character 'L' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'L' to get unstuck

    li $t8, 'l' # load the character 'l' into register $t8
    beq $v1, $t8, count_unstuck_move # check if character inputed by the user is equal to 'l' to get unstuck
       
    la $a0, stuck_msg
    li $v0, 4
    syscall

    j invalid_move_right # if 'L' or 'l' is not entered run invalid_move_right again

load_cell_address:
    addi $sp, $sp, -8      # Adjust stack pointer
    sw $ra, 4($sp) 	
    # Load cell beginning address into $t5
    mul $t5, $t1, $s1  # Multiply y-coordinate by width of maze, save the result in $t5
    add $t5, $t5, $t0  # Add the result by x-coordinate, and get the index of the target cell on the 1-D arrary, save the result back to $t5
    mul $t5, $t5, 6  # Since each cell contains 6 digits (4 number, a ",", and a " "), multiply the index by 6 to get the actual memory address offset, and save the offset value into $t5
    add $t5, $s0, $t5  # Based on the address of the maze array $s0, jump to the address of the target cell with offset value, save the address of the cell into $t5
    
    lw $ra, 4($sp)         # Restore return address
    addi $sp, $sp, 8       # Adjust stack pointer back
    jr $ra
  
count_unstuck_move:
    addi $t3, $t3, 1 # increment for unstuck move
    sw $t3, total_moves
    j main_loop

check_exit:
    # This part is used to print out coordinates for each step for debugging
    #la $a0, arrow  
    #li $v0, 4       
    #syscall
    #move $a0,$t1
    #li  $v0, 1 
    #syscall
    #move $a0,$t0
    #li  $v0, 1 
    #syscall
    
    # Check if the robot reach to the exit, if so return 1 (exit condition)
    bne $t0, $s2, not_exit    # If x != exit xcord, not exit
    bne $t1, $s3, not_exit  # If y != exit ycord, not exit
    j exit
    
not_exit:
    jr $ra

exit:
    # Print congratulations and mistakes
    li $v0, 4                 # print string
    la $a0, exit_msg
    syscall

    li $v0, 1                 # print integer
    lw $a0, mistakes         # load mistakes count
    syscall

    # Print total moves
    li $v0, 4                 # print string
    la $a0, total_moves_msg
    syscall

    li $v0, 1                 # print integer
    lw $a0, total_moves      # load total moves
    syscall

    # End program
    li $v0, 10               # exit program
    syscall
    

empty_abort:        # If user entered an empty value by press "enter", will end program
    la $a0, empty_msg
    li $v0, 4 
    syscall
    
     # End program
    li $v0, 10               # exit program
    syscall
    
