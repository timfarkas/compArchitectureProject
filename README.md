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
