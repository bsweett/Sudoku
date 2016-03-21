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
let kPuzzleInfoKey = "PreloadedPuzzle"

/**
 A enum that represents the type of sudoku puzzle to solve. Use constructPuzzle() to
 get a prebuilt puzzle.
 
 - Default: The puzzle provided in the assignment.
 - Easy:    An easy puzzle from websudoku.com.
 - Hard:    A hard puzzle from websudoku.com.
 - Custom:  A custom puzzle built from string input.
 */
enum SudokuType {
    case Default, Easy, Hard, Custom(String)
    
    /**
     Builds a Sudoku Puzzle 2-d array for this type. A custom puzzle type requires an input string
     of kPuzzleSize * kPuzzleSize size on a single line with 0's for empty spaces.
     
     - returns: A Sudoku puzzle
     */
    func constructPuzzle() -> Sudoku {
        switch(self) {
        case .Default:
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
        case .Easy:
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
        case .Hard:
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
        case .Custom(let input):
            return constructCustomPuzzle(input)
        }
    }
    
    /**
     Builds a custom puzzle from the given input string. The string cannot be longer or shorter than
     kPuzzleSize * kPuzzleSize and must be on a single line with only numbers.
     
     - parameter inputString: A string that matches the regex defined in isValidSudokuPuzzle
     
     - returns: A 2-d array Sudoku puzzle.
     */
    private func constructCustomPuzzle(inputString: String) -> Sudoku {
        
        assert(inputString.characters.count == kPuzzleSize * kPuzzleSize && inputString.isValidSudokuPuzzle)
        
        var outputPuzzle: Sudoku = []
        var currentRow: [Int] = []
        
        //  We need to loop through every character in the string
        for (index, char) in inputString.characters.enumerate() {
            
            //  Make sure we can convert the character to an integer.
            //  Swift doesn't really have a better way of moving from a character to an integer :/
            if let currentNumber = Int(String(char)) {
                
                //  If we are at the end of a row then start a new row (i.e. array)
                if (index >= kPuzzleSize && index % kPuzzleSize == 0) {
                    outputPuzzle.append(currentRow)
                    currentRow = Array([currentNumber])
                } else {
                    currentRow.append(currentNumber)
                }
            }
        }
        
        // When we are finished make sure we add the last row
        outputPuzzle.append(currentRow)
        return outputPuzzle
    }
}