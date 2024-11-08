<img width="1639" alt="image" src="https://github.com/user-attachments/assets/00216784-cac9-42d8-86cb-e240d81c5ae8"># Assembly Programming Group Project
Group project involving development of a simple MIPS assembly language program, part of MSc Computer Science course at UCL.

I. Task Breakdown:
  1. Encoding the maze and robot position: 
    - Store the maze in MIPS (what data structure should we use, and how to record wall and path in the data, given that MIPS does not have complicated default data structure such as list, dictionary)
    - Record the robot position in MIPS (Maybe need to use several variables to record its coordinate)
  2. Taking input and move the robot:
    - Provide instructions for user input
    - Transfer user input like “F”, “B”, “L”, “R” into MIPS order and change relevant variables accordingly
  3. Feasibility check:
    - Check a movement is valid or not
    - Provide feedback as a print output
  4. Exit check:
    - Once the robot reaches destination, need to know and stop the program
  5. Step and mistake count:
    - Once reaching destination, print out the number of steps taken and mistakes made


II. Progress update on Nov 8, 2024:
  1. A demo project with same function in Python has been made
  2. Figured out pne possible solution to encode the maze in MIPS
    - Following the python project, we tried to encode the maze by encoding 4 directions of each cell.
    - The 2-D maze is encoded in a list of 1-D 4digits numbers, and use y and x coordinates to locate the number
    - In each cell the 4digits number represent “F, R, B, L” respectively, where “1” stands for a feasible path and ”9” stands for a wall

    

III. Potential To-Dos:
  1. Other parts of the task remaining unfinished in MIPS:
    - Taking user input and move the robot
    - Feasibility check for each step
    - Exit check
    - Step and mistake count
    - Debugging
  2. There might be some other ways of encoding the Maze (e.g., to do it in a 2-D manner?)
  3. Optional: figure out an algorithm to generate new maze


