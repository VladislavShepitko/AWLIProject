//
//  CircleView.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 10/2/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class CirclesView: UIView {
    
    private (set) var packer = CirclePacker<Circle>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        packer.setNewBounds(self.bounds)
        
    }
    
    func setCircles(templates:[UIView], minR:CGFloat, maxR:CGFloat){
        
        for t in templates {
            let radius = CGFloat.random(minR, upper: maxR)
            let pos = CGPointZero
            
            let circle = Circle(pos: pos, radius: radius)
            t.frame = circle.bounds
            circle.addSubview(t)
            
            packer.addCircle(Circle(pos: pos, radius: radius))
        }
    }
}

class Circle: UIView, CircleItem {
    var targetPos:CGPoint = CGPointZero
    var pos:CGPoint = CGPointZero
    var prevPos:CGPoint = CGPointZero
    
    var radius:Radius = Radius()
    
    var posWithOffset:CGPoint = CGPointZero
    var prevPosWithOffset:CGPoint = CGPointZero
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    convenience required init(pos:CGPoint, radius:CGFloat){
        self.init(frame:CGRectZero)
        //update view's frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


func ==(l: Circle, r: Circle) -> Bool {
    return l.targetPos == r.targetPos && l.pos == r.pos && l.radius.current == r.radius.current
}