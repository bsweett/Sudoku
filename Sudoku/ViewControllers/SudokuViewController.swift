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
    
    /// A message that is shown to the user when no solution for the puzzle is found
    private let kNoSolutionMessage = NSLocalizedString("No solution was found for this puzzle.", comment: "")
    
    /// The title of this view controller
    private let kViewTitle = NSLocalizedString("Sudoku", comment: "")
    
    /// The spacing between each cell on the puzzle board
    private let kCellSpacing: CGFloat = 2.0
    
    
    //  MARK: - Variables
    
    /// A collection view which is used to model the puzzle board
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// A button that is used to solve and reset the puzzle board
    @IBOutlet weak var solveButton: UIButton!
    
    /// A label that is used to tell the user if the puzzle has no solution
    @IBOutlet weak var errorLabel: UILabel!
    
    /// The puzzle being displayed on the board. This begins unsolved but is set to solved once the solve button is pressed.
    private var puzzle: Sudoku = SudokuType.Default.constructPuzzle()
    
    /// A custom string provided from the constructor for building puzzles. Nil if the default puzzle should be used.
    private var customPuzzleString: String?
    
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
            self.customPuzzleString = sudokuString
            self.puzzle = SudokuType.Custom(sudokuString).constructPuzzle()
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

    /**
     A event action sent by the solve button when the user touches up inside it. Handles two different functions.
     Clears the puzzle if a solution is visible on the screen and solves the puzzle if it is not solved yet.
     
     - parameter sender: The UIButton instance that the event was fired for.
     */
    @IBAction func didTouchUpInsideSolveButton(sender: UIButton) {
        
        //  If a solution is being displayed this action will reset the
        //  data in the puzzle
        if (isFinishedSolutionAttempt) {
            
            self.resetPuzzle()
            
        } else {
            
            self.solvePuzzle()
        }
    }
    
    //  MARK: - Instance Methods
    
    /**
     Updates the view to clear a solved soduko puzzle.
     */
    private func resetPuzzle() {
        
        errorLabel.text = ""
        
        //  Reset the puzzle
        if let customInput = self.customPuzzleString {
            puzzle = SudokuType.Custom(customInput).constructPuzzle()
        } else {
            puzzle = SudokuType.Default.constructPuzzle()
        }
        
        collectionView.reloadData()
        isFinishedSolutionAttempt = false
        solveButton.setTitle(kSolveButtonTitle, forState: .Normal)
    }
    
    /**
     Updates the view to solve an unsolved soduko puzzle.
     */
    private func solvePuzzle() {
        
        solveButton.enabled = false
        solveButton.setTitle(kClearButtonTitle, forState: .Normal)
        
        let algorithm = SudokuSolver()
        if let solution = algorithm.solve(puzzle) {
            puzzle = solution
            collectionView.reloadData()
        } else {
            errorLabel.text = kNoSolutionMessage
        }
        
        solveButton.enabled = true
        isFinishedSolutionAttempt = true
    }
    

    //  MARK: - UICollectionViewDataSource
    
    /**
     Asks your data source object for the number of sections in the collection view.
     
     - parameter collectionView: The collection view requesting this information.
     
     - returns: The number of sections in collectionView.
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return puzzle.count
    }
    
    /**
     Asks your data source object for the number of items in the specified section.
     
     - parameter collectionView: The collection view requesting this information.
     - parameter section:        An index number identifying a section in collectionView. This index value is 0-based.
     
     - returns: The number of rows in section.
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return puzzle[section].count
    }
    
    /**
     Asks your data source object for the cell that corresponds to the specified item in the collection view.
     
     - parameter collectionView: The collection view requesting this information.
     - parameter indexPath:      The index path that specifies the location of the item.
     
     - returns: A configured cell object.
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        if let customCell = cell as? SudokuCollectionViewCell {
            customCell.setCellText(puzzle[indexPath.section][indexPath.row])
            return customCell
        }
        
        return cell
    }
    
    
    //  MARK: - UICollectionViewDelegateFlowLayout
    
    /**
     Asks the delegate for the size of the specified item’s cell.
     
     - parameter collectionView:       The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter indexPath:            The index path of the item.
     
     - returns: The width and height of the specified item.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfColumns: CGFloat = CGFloat(kPuzzleSize)
        let width = CGRectGetWidth(collectionView.frame) - (numberOfColumns + 1) * kCellSpacing
        let itemWidth = width / numberOfColumns
        return CGSizeMake(itemWidth, itemWidth)
    }
    
    /**
     Asks the delegate for the spacing between successive rows or columns of a section.
     
     - parameter collectionView:       The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter section:              The index number of the section whose line spacing is needed.
     
     - returns: The minimum space (measured in points) to apply between successive lines in a section.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kCellSpacing
    }
    
    /**
     Asks the delegate for the spacing between successive items in the rows or columns of a section.
     
     - parameter collectionView:       The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter section:              The index number of the section whose inter-item spacing is needed.
     
     - returns: The minimum space (measured in points) to apply between successive items in the lines of a section.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kCellSpacing
    }
    
    /**
     Asks the delegate for the margins to apply to content in the specified section.
     The margins to apply to items in the section.
     
     - parameter collectionView:       The collection view object displaying the flow layout.
     - parameter collectionViewLayout: The layout object requesting the information.
     - parameter section:              The index number of the section whose insets are needed.
     
     - returns: The margins to apply to items in the section.
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kCellSpacing, left: kCellSpacing, bottom: 0.0, right: kCellSpacing)
    }
}
