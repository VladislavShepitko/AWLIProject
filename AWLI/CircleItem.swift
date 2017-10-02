//
//  CircleItem.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 10/2/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

struct Radius {
    var current:CGFloat = 0
    var sq:CGFloat = 0
    var original:CGFloat = 0
    
    init(){
        
    }
    
    mutating func setRadius(value: CGFloat){
        current = value
        sq = value * value
        original = value
    }
}

protocol CircleItem : Equatable {
    var targetPos:CGPoint {get set}
    var pos:CGPoint {get set}
    var prevPos:CGPoint {get set}
    
    var radius:Radius {get set}
    
    var posWithOffset:CGPoint {get set}
    var prevPosWithOffset:CGPoint {get set}
    
    init(pos:CGPoint, radius:CGFloat)
}

extension CircleItem {
    func containsPoint(circle:Self) -> Bool{
        let distanceSquared = self.pos.distanceSquared()
        return distanceSquared < radius.sq || distanceSquared < circle.radius.sq
    }
    
    func distanceSquaredFromTargetPos() -> Bool {
        let distanceSquared = pos.distanceSquared(targetPos)
        return distanceSquared < radius.sq
    }
    mutating func getPosWithOffset() -> CGPoint{
        prevPosWithOffset.x = posWithOffset.x
        prevPosWithOffset.y = posWithOffset.y
        
        posWithOffset.x = pos.x - radius.current
        posWithOffset.y = pos.y - radius.current
        
        return posWithOffset
    }
    mutating func setPos(newPos:CGPoint) {
        prevPos = pos
        pos = newPos
    }
}

