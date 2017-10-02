//
//  CirclePacker.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 10/2/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

protocol PackedView : Comparable, Equatable {
    var center: CGPoint {get set}
    var radius: CGFloat {get set}
    
    init(center:CGPoint, radius:CGFloat)
}

class CirclePacker<T where T:PackedView>: NSObject {
    
    var minSeparation:CGFloat = 10.0
    
    private (set) var circles:[T] = []
    private (set) var center:CGPoint = CGPointZero
    
    var dragginCircle:T? = nil {
        didSet{
            
        }
    }
    var bounds:CGRect = CGRectZero
    private var circleQueue = dispatch_queue_create("com.awli.packerqueue", DISPATCH_QUEUE_SERIAL)
    
    override init(){
        super.init()
    }
    
    convenience init(bounds:CGRect,count:Int, packingCenter:CGPoint, minRadius:CGFloat, maxRadius:CGFloat, factory:((circle:T) -> Void)){
        self.init()
        self.generateCircles(bounds, count:count, packingCenter: packingCenter, minRadius: minRadius, maxRadius: maxRadius, factory: factory)
    }
    
    func generateCircles(bounds:CGRect,count:Int, packingCenter:CGPoint, minRadius:CGFloat, maxRadius:CGFloat, factory:((circle:T) -> Void)){
        self.bounds = bounds
        circles.removeAll()
        center = packingCenter
        for _ in 0..<count {
            let newCenter = CGPoint(x: packingCenter.x + CGFloat(Double.random) * minRadius,
                y: packingCenter.y + CGFloat(Double.random) * minRadius)
            let radius = minRadius + CGFloat(Double.random) * (maxRadius - minRadius)
            
            let circle = T(center: newCenter, radius: radius)
            self.circles.append(circle)
            factory(circle: circle)
        }
        dragginCircle = circles.first
    }
    
    func map(closure:(item:T)->Void) {
        _ = self.circles.map { item in
            dispatch_barrier_sync(circleQueue) { _ in
                closure(item: item)
            }
        }
        
    }
    private func distanceToCenter(circle:T) -> CGFloat{
        return  CGPoint.distance(circle.center, end: self.center)
    }
    private func sortFunc(f:T, s:T) -> Bool {
        return distanceToCenter(f) < distanceToCenter(s)
    }
    
    func onFrameMove(iterationCounter:CGFloat){
        //self.circles.sortInPlace(sortFunc)
        
        let minSeparationSq = minSeparation * minSeparation
        
        for i in 0...self.circles.count - 1  {
            for j in i + 1..<self.circles.count {
                if i == j {
                    continue
                }
                
                var AB = circles[j].center - circles[i].center
                let r = circles[i].radius - circles[j].radius
                
                var d = AB.distanceSquared() - minSeparationSq
                let minSepSq = min(d, minSeparationSq)
                d -= minSepSq
                
                if d < (r * r) - 0.01 {
                    AB.normalize()
                    AB = AB * ((r - sqrt(d)) * 0.5)
                    if circles[j] != dragginCircle {
                        circles[j].center = circles[j].center + AB
                    }
                    if circles[i] != dragginCircle {
                        circles[i].center = circles[j].center - AB
                    }
                }
                
            }
        }
        let damping:CGFloat = 0.1 / CGFloat(iterationCounter)
        _ = circles.map { [unowned self] (var item) in
            //if self.inBoundsRect(item) {
                if item != self.dragginCircle {
                    var v = item.center - self.center
                    v = v * damping
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        item.center = item.center - v
                    })
                    //print("center: \(item.center) v:\(v) d:\(damping)")
                }
            //}
        }
    }
    func inBoundsRect(item:T) -> Bool {
        if item.center.x < bounds.width  && item.center.x > 0 &&
           item.center.y < bounds.height && item.center.y > 0
            {
            return true
        }else {
            return false
        }
    }
    
    func selectCircle(location:CGPoint) {
        self.dragginCircle = nil
        for circle in circles {
            let dist = (circle.center - self.center).distanceSquared()
            if dist < circle.radius * circle.radius {
                self.dragginCircle = circle
                return
            }
        }
    }
    
}
