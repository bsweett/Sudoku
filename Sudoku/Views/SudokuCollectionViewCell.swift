//
//  SudokuCollectionViewCell.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

/// A custom cell for our sudoku collection view
class SudokuCollectionViewCell: UICollectionViewCell {

    /// The label for holding the number in the cell
    @IBOutlet weak var valueLabel: UILabel!
    
    /**
     Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
     The nib-loading infrastructure sends an awakeFromNib message to each object recreated from a nib archive, but only after 
     all the objects in the archive have been loaded and initialized. When an object receives an awakeFromNib message, it is 
     guaranteed to have all its outlet and action connections already established.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.eggWhite()
        valueLabel.textColor = UIColor.emperorGray()
    }
    
    /**
     Sets the text of the cell to a given sudoku number. If 0 is given the cell will show nothing.
     
     - parameter sudokuNumber: A number between 0 and 9.
     */
    func setCellText(sudokuNumber: Int) {
        if sudokuNumber != 0 {
            valueLabel.text = String(sudokuNumber)
        } else {
            valueLabel.text = ""
        }
    }
}
