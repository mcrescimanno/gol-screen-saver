//
//  Board.swift
//  GameOfLife
//
//  Created by Matthew Crescimanno on 2/23/21.
//

import Foundation

class Board {
    private var frameSize: NSSize;
    public var rows: [[Cell]] = [];
    public var numRows: Int = 0;
    public var numCols: Int = 0;
    
    init(sizeOfFrame: NSSize) {
        frameSize = sizeOfFrame;
        
        self.numRows =  Int(ceilf(Float(frameSize.height / Cell.CELL_SIZE.height)))
        self.numCols =  Int(ceilf(Float(frameSize.width / Cell.CELL_SIZE.height)))
        
        for j in 0..<numRows {
            var cols: [Cell] = [];
            
            for i in 0..<numCols {
                let c = Cell(gridX: i, gridY: j, isAlive: false);
                cols.append(c)
            }
            
            rows.append(cols)
        }
    }
    
    public func getCellAt(x:Int, y:Int) -> Cell {
        return rows[y][x];
    }
    
    private func getCellStateAt(x:Int, y:Int) -> Bool {
        if self.isCellOutOfBounds(x:x, y:y) {
            return false;
        }
        
        return self.getCellAt(x: x, y: y).isAlive;
    }
    
    public func getNeighborStates(cell: Cell) -> [Bool] {
        var ret : [Bool] = [];
        //up
        ret.append(getCellStateAt(x: cell.x, y: cell.y + 1));

        // left
        ret.append(getCellStateAt(x:cell.x - 1, y:cell.y));

        // down
        ret.append(getCellStateAt(x:cell.x, y: cell.y - 1));

        // right
        ret.append(getCellStateAt(x: cell.x + 1, y: cell.y));

        // up-left
        ret.append(getCellStateAt(x:cell.x - 1, y:cell.y + 1));

        // down-left
        ret.append(getCellStateAt(x:cell.x - 1, y:cell.y - 1));

        // up-right
        ret.append(getCellStateAt(x:cell.x + 1, y:cell.y + 1));

        // down-right
        ret.append(getCellStateAt(x:cell.x + 1, y:cell.y - 1));
        return ret;
    }
    
    public func isCellOutOfBounds(x:Int, y:Int) -> Bool {
        return (y < 0 || y >= self.numRows) || (x < 0 || x >= self.numCols);
    }
    
    func draw() {
        for row in self.rows {
            for cell in row {
                cell.draw()
            }
        }
    }
}
