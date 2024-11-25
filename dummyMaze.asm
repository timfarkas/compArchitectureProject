#### Input into maze0.asm
"
0000, 0000, 0000, 0000, 0001, 0000, 0000,
0000, 1000, 1010, 0110, 1001, 1010, 0110,
0000, 1100, 0110, 1001, 1010, 0110, 0101,
1000, 0011, 0101, 1100, 1010, 0011, 0101,
0000, 1100, 0011, 1001, 0110, 1100, 0011, 
0000, 0101, 1100, 1010, 0101, 1001, 0110,
0000, 1001, 0011, 1001, 1011, 1010, 0011, "

#### Input into Maze_encode.asm
"
9999, 9999, 9999, 9999, 9991, 9999, 9999,
9999, 1999, 1991, 9119, 1991, 1919, 9119,
9999, 1199, 9119, 1991, 1919, 9119, 9191,
9999, 9911, 9191, 1199, 1919, 9911, 9191,
9999, 1199, 9911, 1991, 9119, 1199, 9911,
9999, 9191, 1199, 1991, 9191, 1991, 9119,
9999, 1991, 9911, 1991, 1911, 1919, 9911, "

# Please keep in mind this maze is 6x6 when the original is 5x6
# Instructions needed to complete dummy maze:
# Forward, Left, Forward, Right, Right, Back, Right, Right, Forward, Left, Forward, Forward, Right, Forward, Forward, Left, Back, Left, Forward, Left, Left, Left, Back, Back, Left
