//
//  SudokuPuzzle.swift
//  SudokuPuzzle
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

typealias Sudoku = [[Int]]

struct SudokuCell {
    let row: Int
    let col: Int
}

let kPuzzleSize = 9
let kBoxSize = 3

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
