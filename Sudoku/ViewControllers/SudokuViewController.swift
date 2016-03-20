//
//  SudokuViewController.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

/// A basic view controller used to control the sudoku puzzle view and the solution algorithm.
class SudokuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    //  MARK: - Constants
    
    /// The title of the clear button
    private let kClearButtonTitle = NSLocalizedString("Clear", comment: "")
    
    /// The title of the solve button
    private let kSolveButtonTitle = NSLocalizedString("Solve", comment: "")
    
    /// The title of this view controller
    private let kViewTitle = NSLocalizedString("Sudoku", comment: "")
    
    /// The spacing between each cell on the puzzle board
    private let kCellSpacing: CGFloat = 2.0
    
    
    //  MARK: - Variables
    
    /// A collection view which is used to model the puzzle board
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// A button that is used to solve and reset the puzzle board
    @IBOutlet weak var solveButton: UIButton!
    
    /// The puzzle being displayed on the board. This begins unsolved but is set to solved once the solve button is pressed.
    private var puzzle: Sudoku = constructPuzzle()
    
    /// A flag for toggling the state of the solve button to clear the puzzle.
    private var isFinishedSolutionAttempt: Bool = false
    
    
    //  MARK: - Constructors
    
    /**
     Returns a newly initialized sudoku view controller loaded from the default nib.
     
     - returns: self, initalized using a constant nib file in the default bundle.
     */
    convenience init(puzzleString: String?) {
        self.init(nibName: "SudokuViewController", bundle: nil)
        
        //  If we were given a valid sudoku string
        if let sudokuString = puzzleString {
            
        }
    }
    
    /**
     Returns an sudoku view controller initialized from data in a given unarchiver.
     self, initialized using the data in decoder.
     
     - parameter aDecoder: An unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Returns a newly initialized sudoku view controller with the nib file in the specified bundle.
     
     - parameter nibNameOrNil:   The name of the nib file to associate with the view controller. 
     The nib file name should not contain any leading path information. If you specify nil, the nibName property is set to nil.
     
     - parameter nibBundleOrNil: The bundle in which to search for the nib file. This method looks for the nib file in the bundle's 
     language-specific project directories first, followed by the Resources directory. If this parameter is nil, the method uses the 
     heuristics described below to locate the nib file.
     
     - returns: A newly initialized SudokuViewController object.
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    //  MARK: - View Lifecycle
    
    /**
     Called after the controller's view is loaded into memory.
     This method is called after the view controller has loaded its view hierarchy into memory. 
     This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView method. 
     You usually override this method to perform additional initialization on views that were loaded from nib files.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = kViewTitle
        self.navigationController?.navigationBar.backgroundColor = UIColor.chillBlue()
        
        solveButton.backgroundColor = UIColor.bittersweetRed()
        solveButton.setTitleColor(UIColor.eggWhite(), forState: .Normal)
        solveButton.setTitleColor(UIColor.emperorGray(), forState: .Highlighted)
        solveButton.layer.cornerRadius = 4.0
        
        //  TODO: We can assert the size here so that the collection view doesn't render if the
        //  the puzzle isn't the right size (i.e. 9x9)
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.registerNib(UINib(nibName: "SudokuCollectionViewCell", bundle: nil),
                                   forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollEnabled = false
        collectionView.backgroundColor = UIColor.emperorGray()
        collectionView.userInteractionEnabled = false
    }

    /**
     Sent to the view controller when the app receives a memory warning.
     Your app never calls this method directly. Instead, this method is called when the system determines that the amount of available memory is low.
     You can override this method to release any additional memory used by your view controller. 
     If you do, your implementation of this method must call the super implementation at some point.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //  MARK: - Actions

    @IBAction func didTouchUpInsideSolveButton(sender: UIButton) {
        
        //  If a solution is being displayed this action will reset the
        //  data in the puzzle
        if isFinishedSolutionAttempt {
            puzzle = constructPuzzle()
            collectionView.reloadData()
            isFinishedSolutionAttempt = false
            solveButton.setTitle(kSolveButtonTitle, forState: .Normal)
            
        } else {
            solveButton.enabled = false
            solveButton.setTitle(kClearButtonTitle, forState: .Normal)
            
            let algorithm = SudokuSolver()
            if let solution = algorithm.solve(puzzle) {
                puzzle = solution
                collectionView.reloadData()
            } else {
                //TODO:  Show error for no solution
            }
            
            solveButton.enabled = true
            isFinishedSolutionAttempt = true
        }
    }
    

    //  MARK: - UICollectionViewDataSource
    
    //  TODO: Try without using sections
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return puzzle.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return puzzle[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        if let customCell = cell as? SudokuCollectionViewCell {
            customCell.setCellText(puzzle[indexPath.section][indexPath.row], animate: false)
            customCell.layer.borderWidth = 0.0
            return customCell
        }
        
        return cell
    }

    
    //  MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = CGFloat(kPuzzleSize)
        let width = CGRectGetWidth(collectionView.frame) - (numberOfColumns + 1) * kCellSpacing
        let itemWidth = width / numberOfColumns
        return CGSizeMake(itemWidth, itemWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kCellSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kCellSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kCellSpacing, left: kCellSpacing, bottom: 0.0, right: kCellSpacing)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
}
