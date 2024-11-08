.data
myarray: .word 9999,9999,9999,9999,9999,9999,9999,9119,1999,1119,1999,9111,9911,9999,1199,9999.......
mazewidth: .word 6
ycord: .word 1          # Can be changed (y-coordinate)
xcord: .word 2          # Can be changed (x-coordinate)
mistakes: .word 0     # Number of mistakes
total_moves: .word 0  # Total number of moves

.text
.globl main
main:
    la $s0, myarray       # Load the base address of the maze
    lw $s1, mazewidth     # Load maze width into $s1
    lw $t0, xcord         # Load x-coordinate into $t0
    lw $t1, ycord         # Load y-coordinate into $t1
    
    # To do: Print welcome message: 
    # Welcome to the MiPS maze solver!
    # Enter a direction: R for right, L for left, F for forward, and B for backward:

main_loop:
    # Get user input (direction)
    jal get_user_input
    move $s2, $v0            # Store the user input (R, L, F, B) in $s2
    
    # Update the robot's position based on the user input
    jal update_position
    
    # Validate the move
    jal validate_move
    beq $v0, $zero, invalid_move  # If invalid move, go to invalid_move
    
    # Check if the robot has reached the exit
    jal check_exit
    beq $v0, 1, exit           # If reached exit, go to exit
    
    j main_loop                # Otherwise, continue with the main loop
    
get_user_input:
    # To do: Read user input (F, B, L, R)
    li $v0, 12
    syscall
    jr $ra
    
update_position:
    # Update the robot's position based on the user input
    beq $s2, 'F', move_forward
    beq $s2, 'B', move_backward
    beq $s2, 'L', move_left
    beq $s2, 'R', move_right

    # To do: Increment the total moves counter

    jr $ra

move_forward:
    # To do: 
    jr $ra

move_backward:
    # To do: 
    jr $ra

move_left:
    # To do: 
    jr $ra

move_right:
    # To do: 
    jr $ra
    
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
error_msg:
    .asciiz "Invalid move! Try again...\n"
exit_msg:
    .asciiz "Congratulations! You reached the exit.\nNumber of mistakes: "
total_moves_msg:
    .asciiz "\nTotal number of moves: "



    


