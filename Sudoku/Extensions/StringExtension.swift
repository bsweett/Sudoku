//
//  StringExtension.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-19.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

extension String {
    
    /// Uses a regex pattern to determine if the given string is in a format that is accepted for a sudoku puzzle.
    /// This does not determine if the puzzle entered is solvable rather only checks the characters and length.
    var isValidSudokuPuzzle: Bool {
        do {
            let expectedLength = String(kPuzzleSize * kPuzzleSize)
            let regex = try NSRegularExpression(pattern: "[0-9]{" + expectedLength + "}", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
}
