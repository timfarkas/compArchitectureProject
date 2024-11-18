.data
myarray: .ascii "0000,0000,0000,0000,0000,0000,0000,1000,0110,1000,1110,0011,0000,1100,1111,0010,0101,0100,0000,0001,1001,1110,0011,0001,0000,1100,1110,0111,1000,0111,0000,0001,0101,1001,1110,0011,1000,1000,1011,0010,1001,0010"
# Each cell contains 4 digits of number. The 4 digits stand for 4 directions, which are "Forward,Right,Back,Left" respectively, where "0" stands for wall, "1" stands for valid path#
# All cells in the first row and first column are considered outside the maze, and are filled with number "0000", except for the starting point.

mazewidth: .word 6
ycord: .word 1 # Can change this. Input ranges from 0-6 (7 rows in total).
xcord: .word 2 # Can change this. Input ranges from 0-5 (6 columns in total). Input above 5 will make the address jumping to next row and return wrong result.

mistakes: .word 0     # Number of mistakes
total_moves: .word 0  # Total number of moves
direction: .word 0 # Initial direction of the robot (0: East, 1: South, 2: West, 3: North)


.text
.globl main
main:
    la $s0, myarray       # Load the base address of the maze
    lw $s1, mazewidth     # Load maze width into $s1
    lw $t0, xcord         # Load x-coordinate into $t0
    lw $t1, ycord         # Load y-coordinate into $t1
    lw $s2, mistakes      # Load the number of mistakes into $s2
    lw $s3, total_moves   # Load the total number of moves into $s3

    la $a0, welcome_msg   # Load the address of the welcome message
    li $v0, 4             # Print the welcome message
    syscall

    j main_loop            # Jump to the main loop

main_loop:
    # Get user input (direction)
    jal get_user_input
    move $t2, $v0            # Store the user input (R, L, F, B) in $t2
    
    # Validate the move
    jal validate_move
    beq $v0, $zero, invalid_move  # If invalid move, go to invalid_move
    
    # Update the position, if the move is valid
    jal update_position

    # Check if the robot has reached the exit
    jal check_exit
    beq $v0, 1, exit           # If reached exit, go to exit
    
    j main_loop                # Otherwise, continue with the main loop
    
get_user_input:
    # To do: Read user input (F, B, L, R)
    li $v0, 12
    syscall
    move $v1, $v0

    # Check if the user input is valid (F, B, L, R)
    li $t4, 'F'
    beq $v1, $t4, valid_input
    li $t4, 'B'
    beq $v1, $t4, valid_input
    li $t4, 'L'
    beq $v1, $t4, valid_input
    li $t4, 'R'
    beq $v1, $t4, valid_input

    la $a0, input_error_msg
    li $v0, 4
    syscall
    j get_user_input

valid_input:
    move $v0, $v1
    jr $ra
    
update_position:
    # Update the robot's position based on the user input
    beq $t4, 'F', move_forward
    beq $t4, 'B', move_backward
    beq $t4, 'L', move_left
    beq $t4, 'R', move_right

    # Increment the total moves counter
    addi $s3, $s3, 1
    sw $s3, total_moves
    jr $ra

move_forward:
    # Increase the x-coordinate by one
    addi $t0, $t0, 1
    sw $t0, xcord
    jr $ra 

move_backward:
    # Decrease the x-coordinate by one
    addi $t0, $t0, -1  
    sw $t0, xcord
    jr $ra

move_left:
    # Increase the y-coordinate by one
    addi $t1, $t1, 1
    sw $t1, ycord
    jr $ra

move_right:
    # Decrease the y-coordinate by one
    addi $t1, $t1, -1 
    sw $t1, ycord
    jr $ra

load_cell_values:
    mul $t5, $t1, $s1  # Multiply y-coordinate by width of maze, save the result in $t5
    add $t5, $t5, $t0  # Add the result by x-coordinate, and get the index of the target cell on the 1-D arrary, save the result back to $t5
    mul $t5, $t5, 5  # Since each cell contains 5 digits (4 number and a ","), multiply the index by 5 to get the actual memory address offset, and save the offset value into $t5
    add $t5, $s0, $t5  # Based on the address of the maze array $s0, jump to the address of the target cell with offset value, save the address of the cell into $t5

    #Jump to the address of direction 0 with 0 offset (forward)
        lb $t6,0($t5) # Load a byte
        move $a0,$t6
        li $v0, 11 # Print a single character
        syscall 

    # Jump to the address of direction 1 with 1 offset (right)
        lb $t6,1($t5) # Load a byte
        move $a0,$t6
        li $v0, 11 # Print a single character
        syscall 

    #Jump to the address of direction 2 with 2 offset(back)
        lb $t6,2($t5) # Load a byte
        move $a0,$t6
        li $v0, 11 # Print a single character
        syscall 

    #Jump to the address of direction 3 with 3 offset (left)
        lb $t6,3($t5) # Load a byte
        move $a0,$t6
        li $v0, 11 # Print a single character
        syscall 

validate_move:
    # To do: Validate the move by comparing user input with the corresponding digit of the current cell in the maze (1 or 9)
    # Load the value of the current cell
    # Check if the move is valid
    beq ??, ??, valid_move
    li $v0, 0               # Return 0 for invalid move
    jr $ra

valid_move:
    li $v0, 1               # Return 1 for valid move
    jr $ra

invalid_move:
    # To do: Print error message
    
    j main_loop


check_exit:
    # To do: checks if the robot has reached the exit
    # Access the current cell value
    # Check if the robot reach to the exit, if so return 1 (exit condition)
    
    beq ??, ??, exit_found  # If value is 1, exit found    
    li $v0, 0                 # Return 0 if not exit
    jr $ra
    
exit_found:
    li $v0, 1                 # Return 1 if exit found
    jr $ra
    
exit:
    # To do: Print the final results
    # Congratulations! 
    # You reached the exitNumber of mistakes: ??
    # Total number of moves: ??
    


.data
welcome_msg:
    .asciiz "Welcome to the MiPS maze solver!\nEnter a direction: R for right, L for left, F for forward, and B for backward:\n"
move_error_msg:
    .asciiz "Invalid move! Try again...\n"
exit_msg:
    .asciiz "Congratulations! You reached the exit.\nNumber of mistakes: "
total_moves_msg:
    .asciiz "\nTotal number of moves: "
input_error_msg:
    .asciiz "Invalid input! Please enter R, L, F, or B.\n"