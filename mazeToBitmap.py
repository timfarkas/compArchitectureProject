def convert_maze_to_bitmaps(maze):
    """
    Convert a larger maze into a 2D list of bitmaps.
    Each cell is represented by a 4-bit integer where:
    - Bit 0 (1): North (↑)
    - Bit 1 (2): East (→)
    - Bit 2 (4): South (↓)
    - Bit 3 (8): West (←)
    """
    rows = len(maze)
    cols = len(maze[0])
    bitmaps = [[0 for _ in range(cols)] for _ in range(rows)]
    
    # function to check if a cell is open
    def is_open(r, c):
        if 0 <= r < rows and 0 <= c < cols:
            return maze[r][c] == '.'
        return False

    # convert each cell based on surroundings
    for r in range(rows):
        for c in range(cols):
            bitmap = 0
            if is_open(r - 1, c):  # North
                bitmap |= 1
            if is_open(r, c + 1):  # East
                bitmap |= 2
            if is_open(r + 1, c):  # South
                bitmap |= 4
            if is_open(r, c - 1):  # West
                bitmap |= 8
            bitmaps[r][c] = bitmap
    
    return bitmaps

# Example usage
maze = [
    ['X', '.', '.', 'X'],
    ['.', 'X', '.', '.'],
    ['.', '.', 'X', 'X'],
    ['X', '.', '.', 'X']
]

bitmaps = convert_maze_to_bitmaps(maze)

for row in bitmaps:
    print(' '.join(format(cell, '04b') for cell in row))