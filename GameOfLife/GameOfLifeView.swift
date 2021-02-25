//
//  GameOfLifeView.swift
//  GameOfLife
//
//  Created by Matthew Crescimanno on 2/22/21.
//

import Foundation
import ScreenSaver

class GameOfLiveView : ScreenSaverView {
    private var board: Board;
    private var firstGenerationInitialized : Bool = false;
    private var liveCells : [Cell] = [];
    override init?(frame: NSRect, isPreview: Bool) {
        self.board = Board(sizeOfFrame: frame.size)
        super.init(frame: frame, isPreview: isPreview);
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.");
    }
    
    override func draw(_ rect: NSRect) {
        /* Note: If we do not draw during the draw cycle, the default will be a blank (black) screen. */
        
        // By default we paint the entire screen white (ie. all cells are dead)
        let bg = NSBezierPath(rect: bounds)
        NSColor.white.setFill()
        bg.fill()
        
        if !self.firstGenerationInitialized {
            self.initializeGame()
            
            self.firstGenerationInitialized = true;
        }
        
        // draw all live cells (at this point liveCells should be set properly)
        for lc in self.liveCells {
            lc.draw()
        }
    }
    
    override func animateOneFrame() {
        self.computeNextGeneration()
        
        // animate next frame every .5 seconds
        do {
            usleep(100000)
        }
        
        setNeedsDisplay(bounds);
    }
    
    private func initializeGame() {
        //self.drawSunPattern()
        //self.drawGosperGunPattern()
        self.drawRandomPattern()
    }
    
    private func computeNextGenCellState(cell: Cell, neighborState: [Bool] ) -> Bool {
        /* Rules:
            true, if live cell with 2 or 3 live neighbors.
            true, if dead cell with 3 live neighbors
            else false
        */
        
        var numAliveNeighbors = 0
        for ns in neighborState {
            if ns { numAliveNeighbors += 1 }
        }
        
        let staysAlive = cell.isAlive && (numAliveNeighbors == 2 || numAliveNeighbors == 3)
        let born = !cell.isAlive && (numAliveNeighbors == 3)
        return staysAlive || born;
    }
    
    private func computeNextGeneration() {
        var cellsToUpdate: [Cell] = [];
        for row in self.board.rows {
            for cell in row {
                let nState = self.board.getNeighborStates(cell: cell)
                let aliveNextRound = self.computeNextGenCellState(cell: cell, neighborState: nState)
                
                if cell.isAlive && !aliveNextRound {
                    cellsToUpdate.append(cell)
                    
                    // remove cell from live cells
                    guard let inx = self.liveCells.firstIndex(where: { (c) -> Bool in return c.x == cell.x && c.y == cell.y }) else {
                        continue;
                    }
                    self.liveCells.remove(at: inx)
                }

                if !cell.isAlive && aliveNextRound {
                    // add cell to live cells
                    self.liveCells.append(cell)
                    cellsToUpdate.append(cell)
                }
            }
        }
        
        // Flip all cells that changed state.
        for c in cellsToUpdate {
            c.setIsAlive(isAlive: !c.isAlive)
        }
    }
    
    private func drawRandomPattern() {
        let liveThreshold = 80;
        for row in self.board.rows {
            for cell in row {
                if Int.random(in: 0..<100) > liveThreshold {
                    cell.setIsAlive(isAlive: true)
                    self.liveCells.append(cell)
                }
            }
        }
    }
    
    private func drawGosperGunPattern() {
        let squareX = 2
        let squareY = (self.board.numRows / 2);
        self.drawSquareAt(startX: squareX, startY: squareY)
        
        let leftGosperStartX = squareX + 10
        let leftGosperStartY = squareY - 3
        self.drawLeftGosperSpaceShip(startX: leftGosperStartX, startY: leftGosperStartY)
        
        let rightGosperStartX = squareX + 20
        let rightGosperStartY = squareY - 1;
        self.drawRigthGosperSpaceShip(startX: rightGosperStartX, startY: rightGosperStartY)
        
        let rightSquareX = squareX + 34
        let rightSquareY = squareY + 2
        self.drawSquareAt(startX: rightSquareX, startY: rightSquareY)
    }
    
    private func drawSquareAt(startX: Int, startY: Int){
        // Draws a square of four cells on the GOL board, starting at bottom left cell.
        var cell = self.board.getCellAt(x: startX, y: startY)
        cell.setIsAlive(isAlive: true)
        self.liveCells.append(cell)
        
        cell = self.board.getCellAt(x: startX + 1, y: startY)
        cell.setIsAlive(isAlive: true)
        self.liveCells.append(cell)
        
        cell = self.board.getCellAt(x: startX + 1, y: startY + 1)
        cell.setIsAlive(isAlive: true)
        self.liveCells.append(cell)
        
        cell = self.board.getCellAt(x: startX, y: startY + 1)
        cell.setIsAlive(isAlive: true)
        self.liveCells.append(cell)
    }
    
    private func drawLeftGosperSpaceShip(startX: Int, startY: Int) {
        // Draws a Left Gosper SpaceShip (7 x 8)
        for yAdd in 0...6 {
            for xAdd in 0...7 {
                if yAdd == 0 && [2,3].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if yAdd == 1 && [1,5].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if (yAdd == 2 || yAdd == 4) && [0,6].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if yAdd == 3 && [0,4,6,7].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if yAdd == 5 && [1,5].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if yAdd == 6 && [2,3].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
            }
        }
    }
    
    private func drawRigthGosperSpaceShip(startX: Int, startY: Int) {
        for yAdd in 0...6 {
            for xAdd in 0...4 {
                if (yAdd == 0 || yAdd == 6) && xAdd == 4 {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if (yAdd == 1 || yAdd == 5) && [2,4].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
                else if [2,3,4].contains(yAdd) && [0,1].contains(xAdd) {
                    self.setCellAlive(cellX: startX + xAdd, cellY: startY + yAdd)
                }
            }
        }
    }
    
    private func drawSunPattern() {
        let startX = (self.board.numCols / 2) - 2;
        let startY = (self.board.numRows / 2) - 2;
        
        self.drawDonut(startX: startX, startY: startY )
        self.drawDonut(startX: startX, startY: startY + 4)
    }
    
    private func drawDonut(startX: Int, startY: Int) {
        let topRow = startY + 1
        let bottomRow = startY - 1;
        
        self.setCellAlive(cellX: startX, cellY: startY)
        self.setCellAlive(cellX: startX + 1, cellY: topRow)
        self.setCellAlive(cellX: startX + 2, cellY: topRow)
        self.setCellAlive(cellX: startX + 3, cellY: topRow)
        self.setCellAlive(cellX: startX + 1, cellY: bottomRow)
        self.setCellAlive(cellX: startX + 2, cellY: bottomRow)
        self.setCellAlive(cellX: startX + 3, cellY: bottomRow)
        self.setCellAlive(cellX: startX + 4, cellY: startY)
    }
    
    private func setCellAlive(cellX: Int, cellY: Int) {
        let cell = self.board.getCellAt(x: cellX, y: cellY)
        cell.setIsAlive(isAlive: true)
        self.liveCells.append(cell)
    }
}
