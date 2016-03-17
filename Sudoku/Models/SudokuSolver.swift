//
//  SudokuSolver.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

final class SudokuSolver {
    
    //  TODO: Add asserts to all the numbers passed to make sure they are always less than 10 and greater than 0
    
    /**
     Attempts to solve the given row and column in the working sudoku model. This function recursively
     calls itself using the next column or row until a either a solution is found or the suduko given was
     deemed unsolveable.
     
     - parameter row: The current row index of the cell we are trying to solve.
     - parameter col: The current column index of the cell we are trying to solve.
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
    private func getWorkingCopyOfPuzzle(puzzle: Sudoku, forCell cell: SudokuCell, withNumber number: Int) -> Sudoku {
        var copy = Sudoku(puzzle)
        var updatedRow = Array(puzzle[cell.row])
        updatedRow[cell.col] = number
        copy[cell.row] = updatedRow
        return copy
    }
    
    /**
     Returns the first cell in the given puzzle that doesn't have cell set with a number.
     
     - parameter puzzle: A Sudoku Puzzle to check the cells of.
     
     - returns: A cell with a row and col and no number set or nil if the puzzle has 
     no empty cells.
     */
    private func getNextEmptyCellInPuzzle(puzzle: Sudoku) -> SudokuCell? {
        for row in 0..<kPuzzleSize {
            for col in 0..<kPuzzleSize {
                if puzzle[row][col] == 0 {
                    return SudokuCell(row: row, col: col)
                }
            }
        }
        
        return nil
    }
    
    private func isNumberValid(number: Int, forCell cell: SudokuCell, inPuzzle puzzle: Sudoku) -> Bool {
        return checkRow(row: cell.row, inPuzzle: puzzle, number: number)
            && checkColumn(col: cell.col, inPuzzle: puzzle, number: number)
            && checkBox(withCell: cell, inPuzzle: puzzle, number: number)
    }
    
    /**
     Checks a 3x3 box that the cell belongs too to see if the number given is already
     in that box.
     

     - parameter number: The number we want to check as a valid input for this box.
     
     - returns: True if the box doesn't contain that number, otherwise returns false.
     */
    private func checkBox(withCell cell: SudokuCell, inPuzzle puzzle: Sudoku, number: Int) -> Bool {
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
    
    private func checkRow(row row: Int, inPuzzle puzzle: Sudoku, number: Int) -> Bool {
        for col in 0..<kPuzzleSize {
            if puzzle[row][col] == number {
                return false
            }
        }

        return true
    }
    
    private func checkColumn(col col: Int, inPuzzle puzzle: Sudoku, number: Int) -> Bool {
        for row in 0..<kPuzzleSize {
            if puzzle[row][col] == number {
                return false
            }
        }
        
        return true
    }
}
