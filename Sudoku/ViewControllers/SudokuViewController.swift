//
//  SudokuViewController.swift
//  Sudoku
//
//  Created by Ben Sweett on 2016-03-16.
//  Copyright © 2016 Ben Sweett. All rights reserved.
//

import UIKit

class SudokuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let kClearButtonTitle = NSLocalizedString("Clear", comment: "")
    private let kSolveButtonTitle = NSLocalizedString("Solve", comment: "")
    private let kViewTitle = NSLocalizedString("Sudoku", comment: "")
    private let kCellSpacing: CGFloat = 2.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var solveButton: UIButton!
    
    private var puzzle: Sudoku = constructPuzzle()
    private var isFinishedSolutionAttempt: Bool = false
    
    convenience init() {
        self.init(nibName: "SudokuViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
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
