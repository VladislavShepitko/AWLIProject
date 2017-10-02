//
//  Extensions.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 10/1/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

 
/**
Arc Random for Double and Float
*/
public func arc4random <T: IntegerLiteralConvertible> (type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, sizeof(T))
    return r
}
public extension Int {
    /**
    Create a random num Int
    :param: lower number Int
    :param: upper number Int
    :return: random number Int
    By DaRkDOG
    */
    public static func random (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
}
public extension Double {
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By DaRkDOG
    */
    public static func random(lower: Double, upper: Double) -> Double {
        let r = Double(arc4random(UInt64)) / Double(UInt64.max)
        return (r * (upper - lower)) + lower
    }
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
}
public extension Float {
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    By DaRkDOG
    */
    public static func random(lower: Float, upper: Float) -> Float {
        let r = Float(arc4random(UInt32)) / Float(UInt32.max)
        return (r * (upper - lower)) + lower
    }
}

public extension CGFloat {
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    By DaRkDOG
    */
    public static func random(lower: CGFloat, upper: CGFloat) -> CGFloat {
        let r = CGFloat(arc4random(UInt32)) / CGFloat(UInt32.max)
        return (r * (upper - lower)) + lower
    }
    
}
public extension CGPoint {
    public static func distance(start:CGPoint, end:CGPoint) -> CGFloat {
        let xDist = end.x - start.x
        let yDist = end.y - start.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    public func distanceSquared() -> CGFloat {
        return x * x + y * y
    }
    public mutating func normalize() {
        let dist = sqrt(distanceSquared())
        self.x = x / dist
        self.y = y / dist
    }
}
public func +(f:CGPoint, s:CGPoint) -> CGPoint {
    return CGPoint(x: f.x + s.x, y: f.y + s.y)
}
public func -(f:CGPoint, s:CGPoint) -> CGPoint {
    return CGPoint(x: f.x - s.x, y: f.y - s.y)
}
public func *(v:CGPoint, m:CGFloat) -> CGPoint {
    return CGPoint(x: v.x * m, y: v.y * m)
}





extension UIView {
    func getConstraint(with name:String) -> NSLayoutConstraint?
    {
        var constraint:NSLayoutConstraint?
        if self.constraints.count > 0 {
            for c in self.constraints {
                if (c.identifier?.containsString(name) != nil){
                    constraint = c
                    break
                }
            }
        }
        return constraint
    }
    func addConstraintsWithFormat(format:String, views:UIView...) {
        var viewsDict:[String:UIView] = [:]
        
        for (index,view) in views.enumerate() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict[key] = view
        }
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
}
extension UIColor {
    class func Random() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}