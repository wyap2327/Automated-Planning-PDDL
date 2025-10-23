import tkinter as tk
from tkinter import messagebox, filedialog
import time



steps = 0  # global counter for number of steps


#Check if putting k at (r, c) is valid 
def validity(grid, r, c, k):
    not_in_row = k not in grid[r]
    not_in_column = k not in [grid[i][c] for i in range(9)]
    not_in_box = k not in [grid[i][j] for i in range(r // 3 * 3, r // 3 * 3 + 3)
                           for j in range(c // 3 * 3, c // 3 * 3 + 3)]
    return not_in_row and not_in_column and not_in_box


#Find the cell with the fewest possible valid numbers
def find_unassigned(grid):
    best_cell = None
    min_poss = 10  # higher than 9
    for r in range(9):
        for c in range(9):
            if grid[r][c] == 0:
                poss = [k for k in range(1, 10) if validity(grid, r, c, k)]
                if len(poss) < min_poss:
                    min_poss = len(poss)
                    best_cell = (r, c, poss)
    return best_cell

 #Solve Sudoku using backtracking
def solve(grid):
    global steps
    steps += 1

    cell = find_unassigned(grid)
    if not cell:
        return True  # returns true when solved

    r, c, possibilities = cell
    for k in possibilities:
        if validity(grid, r, c, k):
            grid[r][c] = k
            if solve(grid):
                return True
            grid[r][c] = 0  # backtracks until
    return False


#Reading from the .txt file
def read_txt(path): 
    grid = []
    with open(path, "r") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.replace(",", " ").split()
            row = []
            for p in parts:
                if p in ("0", ".", ""):
                    row.append(0)
                else:
                    row.append(int(p))
            grid.append(row)
    return grid


#Solving the test sudoku file
def solve_file(path):
    global steps
    steps = 0
    grid = read_txt(path)
    start = time.time()
    solved = solve(grid)
    end = time.time()
    if solved:
        print("Sudoku Solved Successfully!")
        for row in grid:
            print(row)
        print(f"\nSteps taken: {steps}")
        print(f"Time taken: {end - start:.4f} seconds")
    else:
        print("No solution found!")


class SudokuGUI:
    def _init_(self, root):
        self.root = root
        self.root.title("Sudoku     CSP")
        self.entries = [[tk.Entry(root, width=2, font=("Times", 20), justify="center") for x in range(9)] for x in range(9)]

        for i in range(9):
            for j in range(9):
                e = self.entries[i][j]
                e.grid(row=i, column=j, padx=2, pady=2)
                if (j + 1) % 3 == 0 and j != 8:
                    e.grid(padx=(2, 8))
                if (i + 1) % 3 == 0 and i != 8:
                    e.grid(pady=(2, 8))

        tk.Button(root, text="Solve", command=self.solve, bg="lightgreen", font=("Arial", 14)).grid(
            row=9, column=0, columnspan=3, sticky="we", pady=5)
        tk.Button(root, text="Clear", command=self.clear, bg="lightcoral", font=("Arial", 14)).grid(
            row=9, column=3, columnspan=3, sticky="we", pady=5)
        tk.Button(root, text="Input File", command=self.input_file, bg="lightblue", font=("Arial", 14)).grid(
            row=9, column=6, columnspan=3, sticky="we", pady=5)
        


    #Getting the grid elements
    def get_grid(self):
        grid = []
        for i in range(9):
            row = []
            for j in range(9):
                val = self.entries[i][j].get()
                row.append(int(val) if val.isdigit() else 0)
            grid.append(row)
        return grid


    #Displaying grid on GUI
    def show_grid(self, grid):
        for i in range(9):
            for j in range(9):
                self.entries[i][j].delete(0, tk.END)
                if grid[i][j] != 0:
                    self.entries[i][j].insert(0, str(grid[i][j]))

    def solve(self):
        """Solve Sudoku from GUI."""
        global steps
        steps = 0
        grid = self.get_grid()
        start = time.time()
        solved = solve(grid)
        end = time.time()
        if solved:
            self.show_grid(grid)
            messagebox.showinfo("Sudoku Solver",
                                f"Solved!\nSteps: {steps}\nTime: {end - start:.4f} seconds")
        else:
            messagebox.showinfo("Sudoku Solver", "No solution")

    #Remove all elements in the grid
    def clear(self):
        for i in range(9):
            for j in range(9):
                self.entries[i][j].delete(0, tk.END)

    #Load Sudoku test file from a .txt
    def input_file(self):
        path = filedialog.askopenfilename(title="Select File", filetypes=[("Text files", "*.txt")])
        if not path:
            return
        grid = read_txt(path)
        self.show_grid(grid)
        messagebox.showinfo("Sudoku Solver", f"Loaded from:\n{path}")


if _name_ == "_main_":
    import sys
    if len(sys.argv) == 2:  # run in file mode
        solve_file(sys.argv[1])
    else:  # run GUI mode
        root = tk.Tk()
        SudokuGUI(root)
        root.mainloop()
