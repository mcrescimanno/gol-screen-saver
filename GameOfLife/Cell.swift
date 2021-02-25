//
//  Cell.swift
//  GameOfLife
//
//  Created by Matthew Crescimanno on 2/22/21.
//

import Foundation
import AppKit.NSBezierPath

class Cell {
    public static let CELL_SIZE: CGSize  = CGSize(width: 30, height: 30)
    public let x: Int;
    public let y: Int;
    public let xRelativeToScreen: CGFloat;
    public let yRelativeToScreen: CGFloat;
    public var isAlive: Bool;
    private let path: NSBezierPath;
    
    init(gridX: Int, gridY: Int, isAlive: Bool) {
        self.x = gridX;
        self.y = gridY;
        self.xRelativeToScreen = CGFloat(gridX) * Cell.CELL_SIZE.width
        self.yRelativeToScreen = CGFloat(gridY) * Cell.CELL_SIZE.height
        self.isAlive = isAlive;
        let cellRect = NSRect(x: xRelativeToScreen, y: yRelativeToScreen, width: Cell.CELL_SIZE.width, height: Cell.CELL_SIZE.height);
        self.path =  NSBezierPath(rect: cellRect);
    }
    
    public func draw() {
        if self.isAlive {
            NSColor.black.setFill()
        }
        else {
            NSColor.white.setFill()
        }
        path.fill()
    }
    
    public func setIsAlive(isAlive: Bool) {
        self.isAlive = isAlive;
    }
}
