.data 
myarray: .ascii "0000,0000,0000,0000,0000,0000,0000,1000,0110,1000,1110,0011,0000,1100,1111,0010,0101,0100,0000,0001,1001,1110,0011,0001,0000,1100,1110,0111,1000,0111,0000,0001,0101,1001,1110,0011,1000,1000,1011,0010,1001,0010"
# Each cell contains 4 digits of data. The 4 digits stand for 4 directions, which are "Forward,Right,Back,Left" respectively, where "0" stands for wall, "1" stands for valid path#
# All cells in the first row and first column are considered outside the maze, and are filled with data "0000", except for the starting point.

ycord: .word 1 #can be changed (ranges from 0-6)
xcord: .word 2 #can be changed (ranges from 0-5)
mazewidth: .word 6
.text

main:
    la $s0, myarray       # Load the base address of the maze
    lw $s1, mazewidth     # Load maze width into $s1
    lw $t0, xcord         # Load x-coordinate into $t0
    lw $t1, ycord         # Load y-coordinate into $t1
    
Load_cell_values:
    mul $t5, $t1, $s1  # Multiply y-coordinate by width of maze, save the result in $t5
    add $t5, $t5, $t0  # Add the result by x-coordinate, and get the index of the target cell on the 1-D arrary, save the result back to $t5
    mul $t5, $t5, 5  # Since each cell contains 5 digits (4 number and a ","), multiply the index by 5 to get the actual memory address offset, and save the offset value into $t5
    add $t5, $s0, $t5  # Jump to the address of the target cell with offset value, save the address of the cell into $t5

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
