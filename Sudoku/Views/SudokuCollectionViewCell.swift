//
//  SudokuCollectionViewCell.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

class SudokuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.eggWhite()
        valueLabel.textColor = UIColor.emperorGray()
    }
    
    func setCellText(sudokuNumber: Int, animate: Bool) {
        
        //  Make it fade colors
        if(animate) {
            UIView.animateWithDuration(0.2, animations: {
                self.backgroundColor = UIColor.aquaBlue()
            }, completion: { (finished) in
                self.backgroundColor = UIColor.eggWhite()
            })
        }
        
        if sudokuNumber != 0 {
            valueLabel.text = String(sudokuNumber)
        } else {
            valueLabel.text = ""
        }
    }
}
