### Credits to James Simpson for authoring this script

print("Welcome to the MIPS maze solver!")

moves_x = {
        "F" : 0,
        "B" : 0,
        "L" : -1,
        "R" : 1
}

moves_y = {
        "F" : 1,
        "B" : -1,
        "L" : 0,
        "R" : 0
}

maze = [
    [[], [], [], [], [], []],
    [[], ["F"], ["B","R"], ["F"], ["B", "R", "F"], ["B", "L"]],
    [[], ["R", "F"], ["B", "L", "R", "F"], ["B"], ["L", "R"], ["R"]],
    [[], ["L"], ["L", "F"], ["B", "R", "F"], ["B", "L"], ["L"]],
    [[], ["R", "F"], ["B", "R", "F"], ["B", "L", "R"], ["F"], ["B", "L", "R"]],
    [[], ["L"], ["L", "R"], ["L", "F"], ["B", "R", "F"], ["B", "L"]],
    [["F"], ["F"], ["B", "L", "F"], ["B"], ["L", "F"], ["B"]]
]

x_position = 6
y_position = 0

count = 0
mistakes = 0


print("Enter a direction: R for right, L for left, F for forward, and B for backwards: ")

while (x_position, y_position) != (0,5):
    user_input = input("")
    if user_input in maze[x_position][y_position]:
        x_position += moves_x[user_input]
        y_position += moves_y[user_input]
        count += 1
    else:
        print("Invalid move! Try again...")
        count += 1
        mistakes += 1

print("Congratulation! You reached the exit.")
print("Number of mistakes: ", mistakes)
print("Total number of moves: ", count)

