//
//  SudokuPuzzle.swift
//  SudokuPuzzle
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

/// A sudoku puzzle is just a 2-d array of integers where 0 is a unsolved cell and the solved
/// cells contain one number between 1 and the puzzle size (usually 9).
typealias Sudoku = [[Int]]

/**
 *  A simple struct for holding a row and column index of a cell.
 */
struct SudokuCell {
    let row: Int
    let col: Int
}

/// The number of cells wide and high the puzzle is. i.e. 9x9
let kPuzzleSize = 9

/// The number of cells wide and high the boxes in the puzzle are. i.e. 3x3
let kBoxSize = 3

/// The key for the info.plist file property so puzzles can be loaded at launch via a string.
let puzzleInfoKey = "PreloadedPuzzle"

/**
 Returns the default puzzle presented in the assignment
 
 - returns: A sudoku puzzle that is shown in the assignment UI mock-up.
 */
func constructPuzzle() -> Sudoku {
    return [
        [8, 5, 6,  0, 1, 4,  7, 3, 0],
        [0, 9, 0,  0, 0, 0,  0, 0, 0],
        [2, 4, 0,  0, 0, 0,  1, 6, 0],
        
        [0, 6, 2,  0, 5, 9,  3, 0, 0],
        [0, 3, 1,  8, 0, 2,  4, 5, 0],
        [0, 0, 5,  3, 4, 0,  9, 2, 0],
        
        [0, 2, 4,  0, 0, 0,  0, 7, 3],
        [0, 0, 0,  0, 0, 0,  0, 1, 0],
        [0, 1, 8,  6, 3, 0,  2, 9, 4]
    ]
}

/**
 Returns a difficult puzzle taken from websudoku.com
 
 - returns: A sudoku puzzle that is a high difficulty level to solve.
 */
func constructHardPuzzle() -> Sudoku {
    return [
        [5, 0, 0,  0, 0, 1,  0, 4, 0],
        [0, 0, 0,  0, 2, 0,  0, 3, 0],
        [9, 0, 6,  0, 3, 0,  0, 0, 0],
        
        [8, 0, 0,  6, 0, 0,  0, 0, 9],
        [0, 6, 0,  0, 1, 0,  0, 5, 0],
        [3, 0, 0,  0, 0, 7,  0, 0, 2],
        
        [0, 0, 0,  0, 4, 0,  6, 0, 7],
        [0, 8, 0,  0, 6, 0,  0, 0, 0],
        [0, 5, 0,  2, 0, 0,  0, 0, 8]
    ]
}

/**
 Returns a easy puzzle taken from websukodu.com
 
 - returns: A sudoku puzzle that is a low difficulty level to solve.
 */
func constructEasyPuzzle() -> Sudoku {
    return [
        [0, 3, 0,  0, 1, 6,  4, 0, 2],
        [5, 0, 1,  0, 2, 0,  6, 0, 8],
        [0, 6, 0,  0, 0, 0,  0, 0, 0],
        
        [3, 0, 2,  1, 0, 0,  0, 0, 0],
        [4, 8, 5,  6, 0, 7,  1, 2, 3],
        [0, 0, 0,  0, 0, 2,  7, 0, 5],
        
        [0, 0, 0,  0, 0, 0,  0, 5, 0],
        [6, 0, 9,  0, 3, 0,  2, 0, 7],
        [1, 0, 8,  9, 7, 0,  0, 4, 0]
    ]
}