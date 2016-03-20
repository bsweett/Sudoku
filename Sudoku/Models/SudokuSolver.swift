//
//  SudokuSolver.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

/// A class containing an algorithm for solving a sudoku puzzle.
final class SudokuSolver {
    
    /**
     Attempts to solve the given sudoko puzzle. This function recursively calls itself using the possible
     working solution as the next working copy of the puzzle until either a complete solution is found
     or the given suduko was deemed unsolveable having exhuasted all possible inputs.
     
     - parameter puzzle: A Sudoku Puzzle
     
     - returns: The complete solved puzzle or nil if no solution was found.
     */
    func solve(puzzle: Sudoku) -> Sudoku? {
        
        //  If we can find an empty cell lets try and fill it in
        if let emptyCell = getNextEmptyCellInPuzzle(puzzle) {
            
            //  Loop through all the possible numbers and check if they are valid for box, col, and row
            for number in 1...kPuzzleSize {
                if (isNumberValid(number, forCell: emptyCell, inPuzzle: puzzle)) {
                    
                    //  If the number is OK we have a possible solution recursively keep trying until we have no more
                    //  empty cells in the puzzle or exhuast all numbers
                    let possibleSolution = getWorkingCopyOfPuzzle(puzzle, forCell: emptyCell, withNumber: number)
                    if let finalSolution = solve(possibleSolution) {
                        return finalSolution
                    }
                }
            }
            
            //  No solution was found
            return nil
            
        } else {
            
            //  If the puzzle has no empty cell's then it's solved
            return puzzle
        }
    }
    
    /**
     Gets an updated working copy of the sudoku puzzle solution by setting the give number to
     the given cell in the given puzzle.
     
     - parameter puzzle: A Sudoku Puzzle to make a copy of
     - parameter cell:   A SudokuCell that needs to have it's number set or updated
     - parameter number: A number between 1 and 9 to set in the cell
     
     - returns: The puzzle given with the cell set with the number
     */
    func getWorkingCopyOfPuzzle(puzzle: Sudoku, forCell cell: SudokuCell, withNumber number: Int) -> Sudoku {
        var copy = Sudoku(puzzle)
        var updatedRow = Array(puzzle[cell.row])
        updatedRow[cell.col] = number
        copy[cell.row] = updatedRow
        return copy
    }
    
    /**
     Returns the first cell in the given puzzle that doesn't have cell set with a number.
     
     - parameter puzzle: A Sudoku Puzzle to check the cells of.
     
     - returns: A cell with a row and col and no number set or nil if the puzzle has no empty cells.
     */
    func getNextEmptyCellInPuzzle(puzzle: Sudoku) -> SudokuCell? {
        for row in 0..<kPuzzleSize {
            for col in 0..<kPuzzleSize {
                if puzzle[row][col] == 0 {
                    return SudokuCell(row: row, col: col)
                }
            }
        }
        
        return nil
    }
    
    /**
     Checks if the given input number is a valid input for the cell in the puzzle. Checks to make sure the 
     input is only used once per row, column, and box.
     
     - parameter number: A number between 1 and the puzzle size
     - parameter cell:   A cell that you want to put that number in
     - parameter puzzle: The puzzle that the cell belongs too.
     
     - returns: true if the number is allowed to be placed in the cell, false if the number isn't a valid input.
     */
    func isNumberValid(number: Int, forCell cell: SudokuCell, inPuzzle puzzle: Sudoku) -> Bool {
        return isNumberValidForRow(number, forCell: cell, inPuzzle: puzzle)
            && isNumberValidForColumn(number, forCell: cell, inPuzzle: puzzle)
            && isNumberValidForBox(number, forCell: cell, inPuzzle: puzzle)
    }
    
    /**
     Checks a 3x3 box that the cell belongs too to see if the number given is already
     in that box.
     
     - parameter number: A number between 1 and the puzzle size
     - parameter cell:   A cell that you want to put that number in
     - parameter puzzle: The puzzle that the cell belongs too.
     
     - returns: True if the box doesn't contain that number, otherwise returns false.
     */
    func isNumberValidForBox(number: Int, forCell cell: SudokuCell, inPuzzle puzzle: Sudoku) -> Bool {
        let boxMinRow = (cell.row / kBoxSize) * kBoxSize
        let boxMaxRow = boxMinRow + kBoxSize - 1
        let boxMinCol = (cell.col / kBoxSize) * kBoxSize
        let boxMaxCol =  boxMinCol + kBoxSize - 1
        
        for row in boxMinRow...boxMaxRow {
            for col in boxMinCol...boxMaxCol {
                if puzzle[row][col] == number {
                    return false
                }
            }
        }
        
        return true
    }
    
    /**
     Checks the horizontal row that the cell belongs too to see if the number given is already
     in that row.
     
     - parameter number: A number between 1 and the puzzle size
     - parameter cell:   A cell that you want to put that number in
     - parameter puzzle: The puzzle that the cell belongs too.
     
     - returns: True if the row doesn't contain that number, otherwise returns false.
     */
    func isNumberValidForRow(number: Int, forCell cell: SudokuCell, inPuzzle puzzle: Sudoku) -> Bool {
        for col in 0..<kPuzzleSize {
            if puzzle[cell.row][col] == number {
                return false
            }
        }

        return true
    }
    
    /**
     Checks the veritical column that the cell belongs too to see if the number given is already
     in that row.
     
     - parameter number: A number between 1 and the puzzle size
     - parameter cell:   A cell that you want to put that number in
     - parameter puzzle: The puzzle that the cell belongs too.
     
     - returns: True if the column doesn't contain that number, otherwise returns false.
     */
    func isNumberValidForColumn(number: Int, forCell cell: SudokuCell, inPuzzle puzzle: Sudoku) -> Bool {
        for row in 0..<kPuzzleSize {
            if puzzle[row][cell.col] == number {
                return false
            }
        }
        
        return true
    }
}
