# Sudoku
A simple sudoku solver written in Swift

![](https://travis-ci.org/venom889/Sudoku.svg?branch=master)

##Installation

1. Download and Install [Xcode 7.3 Beta 5](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_7.3_beta_5/Xcode_7.3_beta_5.dmg) from Apple's developer portal.

2. Clone this repo or download the zip and open ``Sudoku.xcodeproj``.

3. Press the "Play" Button in the top left corner of Xcode or use the hotkey "Command + R" to build and run the application in the default iOS simulator.

##Usage

The application will launch with a demo puzzle preloaded. Press the "Solve" button to start the algorithm. Once it is finished the puzzle will be updated to show the solution. If the puzzle cannot be solved an error will display. Press the "Clear" button to reset the puzzle. 

#### Custom Puzzles

If you would like to load a custom puzzle into the board complete the following steps:

1. Open ``/Sudoku/Sudoku/Info.plist`` or edit in Xcode (it's under the ``Supporting Files`` Group)

2. Change the value for the key ``PreloadedPuzzle`` to 81 character string of numbers. The string should be a valid sudoku puzzle read left to right across 9 rows. Example:
``003020600900305001001806400008102900700000008006708200002609500800203009005010300``

3. Save the changes to the file and run the application again. If the input is valid your puzzle should be displayed on the screen. If your input is invalid the application will default back to the demo board.
4. Alternatively you can change the ``puzzle`` property found in ``SudokuViewController`` to be any given 2D array of integers or use the ``constructPuzzle`` function for a given ``SudokuType``. 
Example:  
 
~~~swift
private var puzzle: Sudoku = SudokuType.Easy.constructPuzzle()
~~~

## Unit Tests

Unit tests and some simple preformance testing have been implemented for this assignment. To run them open the "Product" menu and select "Test" or use the hotkey "Command + U".

## License

Copyright 2016, Benjamin Sweett.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/).