# Assembly Programming Group Project


# Task allocations:
1. Demo program in Python (James)
    - Realize all functions in Python
    - Design methods to encode the maze
2.General Code structure in MIPS (Jasmine)
    - Lay out the structure and key components required for the program in MIPS, define key variables
    - Make sure all parts of the code are aligned and work well together
3.Encode the maze and load value (Bruce)
    - Store the maze in MIPS as an 1-D array data
    - Provide method to retrieve cell values based on X-Y coordinates
4.Take input and move the robot (Clara)
    - Record the robot position in MIPS 
    - Provide instructions for user input
    - Transfer user input like “F”, “B”, “L”, “R” into MIPS order and change relevant variables accordingly
5. Movement feasibility check (Tim)
    - Check whether a movement is valid or not
    - Provide movement feedback as print output
6. Exit check and result output (Peace)
    - Once the robot reaches destination, need to know and stop the program
    - Once reaching destination, print out the number of steps taken and mistakes made
7. Robustness test with different mazes (Todd)
    - Changes the maze into new ones (Manually or with algorithm)
    - Test the program in different maze







# Assembly Programming Group Project
Group project involving development of a simple MIPS assembly language program, part of MSc Computer Science course at UCL.


## Here is some pseudocode for the 'take left path' algorithm incase we have enough time to implement that I made:

Start at the maze entrance

While not at the exit:
    Move forward until a wall is hit
    When a wall is hit:
        Rotate anti-clockwise 90 degrees (left)
        Move forward
        If another wall is hit immediately:
            Rotate clockwise 90 degrees (right) twice (to turn around)
            Move forward
        Else:
            Keep moving forward along the new direction

End (when the exit is reached)

## About the `maze0.asm` file:

This is a draft outline of our maze solver in MIPS, based on James and Bruce's contributions. It's still a work-in-progress, but I thought having this as a reference will make our discussion easier during our next meeting. Feel free to review and make changes to the code!

Right now, there are three main parts (functions) that still need to be completed:

- `get_user_input`
- `update_position` (which includes the movement functions: `move_forward`, `move_backward`, `move_left`, `move_right`)
- `validate_move` (including `valid_move` and `invalid_move`)
- `check_exit` (including `exit_found` and `exit`)

