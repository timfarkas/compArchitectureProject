import random

class Cell: ####### Generates the size of the maze 
    def __init__(self, row, col): 
        self.row = row
        self.col = col
        self.walls = {"top": True, "right": True, "bottom": True, "left": True} # Assigning the edges of the maze to have string values
        self.visited = False

    def remove_wall(self, neighbor, direction):
        self.walls[direction] = False
        neighbor.walls[opposite_direction(direction)] = False

def opposite_direction(direction): 
    opposites = {"top": "bottom", "bottom": "top", "left": "right", "right": "left"}
    return opposites[direction]


class Maze:
    def __init__(self, size):
        self.size = size
        self.grid = [[Cell(row, col) for col in range(size)] for row in range(size)]

    def generate_maze(self): ####### Recursive Algo so maze covers the full cell size.
        start_cell = self.grid[0][0]
        self._carve_path(start_cell)

    def _carve_path(self, current_cell):
        current_cell.visited = True
        neighbors = self.get_unvisited_neighbors(current_cell)
        random.shuffle(neighbors)

        for neighbor, direction in neighbors:
            if not neighbor.visited: # Removes wall so that corridor can be made.
                current_cell.remove_wall(neighbor, direction)
                self._carve_path(neighbor)

    def get_unvisited_neighbors(self, cell): # Builds on corridor functionality through recursion
        neighbors = []
        directions = {
            "top": (-1, 0),
            "right": (0, 1),
            "bottom": (1, 0),
            "left": (0, -1)
        }
        for direction, (dr, dc) in directions.items():
            r, c = cell.row + dr, cell.col + dc
            if 0 <= r < self.size and 0 <= c < self.size:
                neighbor = self.grid[r][c]
                if not neighbor.visited:
                    neighbors.append((neighbor, direction))
        return neighbors
    
    def create_openings(self): ######## Entrance on the left wall - Entrance will always be on the left edge.
        entrance_row = random.randint(0, self.size - 1)
        entrance = self.grid[entrance_row][0]
        entrance.walls["left"] = False # Creates gap for entrance on left edge
        # Player must go forward to enter the maze
        print(f"Entrance at: (col 0, row {entrance_row}). Move 'forward' to start!")

        # Exit gap is in the top only
        exit_col = random.randint(0, self.size - 1)
        exit_cell = self.grid[0][exit_col]
        exit_cell.walls["top"] = False # Creates gap for exit on top edge
        print(f"Exit at: (col {exit_col}, row 0)")

    def print_maze(self): 
        for row_index, row in enumerate(self.grid):
            # Print the top walls
            print("".join("+" + ("---" if cell.walls["top"] else "   ") for cell in row) + "+")
            # Print the side walls
            print("".join(("|" if cell.walls["left"] else " ") + "   " for cell in row) +
                ("|" if row[-1].walls["right"] else " "))
        # Print the bottom edge walls
        print("".join("+" + ("---" if cell.walls["bottom"] else "   ") for cell in self.grid[-1]) + "+")
        print("You must move forward to begin.")

# def first_Move_Forward_Only(self):
    # Robot can only move forward to begin the maze and counter. Once it has taken that first step forward it cannot move out of the entrance. 



maze = Maze(6)
maze.generate_maze()
maze.create_openings()  # Add entrance and exit
maze.print_maze()