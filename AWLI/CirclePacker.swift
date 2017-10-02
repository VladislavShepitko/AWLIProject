//
//  CirclePacker.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 10/2/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
struct BoundsRule : OptionSetType {
    let rawValue: Int
    
    static let WrapX        = BoundsRule(rawValue: 0)
    static let WrapY        = BoundsRule(rawValue: 1 << 0)
    static let ConstraintX  = BoundsRule(rawValue: 1 << 1)
    static let ConstraintY  = BoundsRule(rawValue: 1 << 2)
}

class CirclePacker<T where T:CircleItem> : NSObject {
    
    private (set) var circles:[T] = []
    var bounds:CGRect = CGRectZero
    var desiredTarget:CGPoint = CGPointZero
    var draggedCircle:T?
    
    let numOfCertainPass = 1
    let numOfCollisionPass = 3
    
    override init(){
        super.init()
        
    }
    
    func setNewBounds(newBounds:CGRect){
        bounds = newBounds
        //desiredTarget = CGPoint(x: newBounds.midX, y: newBounds.midY)
    }
    
    func addCircle(newCircle:T){
        var circle = newCircle
        circles.append(circle)
        circle.targetPos = desiredTarget
    }
    func randomizePositions(){
        _ = circles.map({ (var circle:T) in
            
            var newPos = CGPointZero
            
            newPos.x = CGFloat.random(bounds.minX, upper: bounds.maxX)
            newPos.y = CGFloat.random(bounds.minY, upper: bounds.maxY)
            
            circle.setPos(CGPointZero)
        })
    }
    
    func updateForTarget(target:CGPoint){
        var v = CGPointZero
        for _ in 0..<numOfCertainPass {
            let damping:CGFloat = 0.025
            for var circle in circles {
                if circle == draggedCircle {
                    continue
                }
                v.x = circle.pos.x - target.x
                v.y = circle.pos.y - target.y
                v = v * damping
                circle.pos.x -= v.x
                circle.pos.y -= v.y
            }
        }
    }
    /**
    * Packs the circles towards the center of the bounds.
    * Each circle will have it's own 'targetPosition' later on
    */
    func handleCollisions(){
        var v = CGPointZero
        for _ in 0..<numOfCollisionPass {
            for i in 0..<circles.count {
                var ci = circles[i]
                for j in i + 1..<circles.count {
                    var cj = circles[j]
                    if cj == ci {continue}
                    
                    let dx = cj.pos.x - ci.pos.x
                    let dy = cj.pos.y - ci.pos.y
                    //The distance between the two circles radii,
                    let r = (ci.radius.current + cj.radius.current) * 1.08
                    let d = ci.pos.distanceSquared(cj.pos)
                    
                    if d < (r * r) - 0.02 {
                        v.x = dx
                        v.y = dy
                        v.normalize()
                        
                        let inverseForce:CGFloat  = (r - sqrt(d)) * 0.5
                        v = v * inverseForce
                        if cj != draggedCircle {
                            if ci == draggedCircle {
                                v = v * 2.2
                            }
                            cj.pos.x = cj.pos.x + v.x
                            cj.pos.y = cj.pos.y + v.y
                        }
                        if ci != draggedCircle {
                            if cj == draggedCircle {
                                //Double inverse force to make up for the fact that the other object is fixed
                                v = v * 2.2
                            }
                            ci.pos.x = ci.pos.x + v.x
                            ci.pos.y = ci.pos.y + v.y
                        }
                    }
                }
            }
        }
    }
    
    func handleBoundaryForCircle(inout circle:T, boundsRule:BoundsRule){
        let r = circle.radius.current
        let d = r * 2
        //wrap x
        if boundsRule.contains(BoundsRule.WrapX) && circle.pos.x - d > bounds.maxX {
            circle.pos.x = bounds.minX + r
        }else if boundsRule.contains(BoundsRule.WrapX) && circle.pos.x < bounds.minX {
            circle.pos.x = bounds.maxX - r
        }
        //wrap y
        if boundsRule.contains(BoundsRule.WrapY) && circle.pos.y - d > bounds.maxY {
            circle.pos.y = bounds.minY + r
        }else if boundsRule.contains(BoundsRule.WrapY) && circle.pos.y < bounds.minY {
            circle.pos.y = bounds.maxY - r
        }
        //Constraint x
        if boundsRule.contains(BoundsRule.ConstraintX) && circle.pos.x + r > bounds.maxX {
            circle.pos.x = bounds.maxX - r
        }else if boundsRule.contains(BoundsRule.ConstraintX) && circle.pos.x - r < bounds.minX{
            circle.pos.x = bounds.minX + r
        }
        //Constraint y
        if boundsRule.contains(BoundsRule.ConstraintY) && circle.pos.y + r > bounds.maxY {
            circle.pos.y = bounds.maxY - r
        }else if boundsRule.contains(BoundsRule.ConstraintY) && circle.pos.y - r < bounds.minY{
            circle.pos.y = bounds.minY + r
        }
    }
    
    func setTarget(target:CGPoint){
        desiredTarget = target
    }
    
    func setDraggedCircle(circle:T?){
        if draggedCircle != nil && draggedCircle != circle {
            draggedCircle!.radius.current = draggedCircle!.radius.original
        }
        draggedCircle = circle
    }
    
    func grabCircle(at point: CGPoint) -> T? {
        var value:T? = nil
        var closestDist = CGFloat.max
        for circle in circles {
            let distSq = circle.pos.distanceSquared(point)
            if distSq < closestDist && distSq < circle.radius.sq {
                closestDist = distSq
                value = circle
            }
        }
        if value != nil {
            setDraggedCircle(value)
            draggedCircle!.radius.current = draggedCircle!.radius.original * 2.5
        }
        return value
    }
    
    
}
