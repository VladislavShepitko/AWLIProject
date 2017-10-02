//
//  PhotosView.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 10/1/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class PhotosView: UIView {
 
    private (set) var photosPacker = CirclePacker<CircleView>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPan:"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generateViews(circles:[UIView]){
        //let cnt = self.convertPoint(self.center, fromView: superview)
        photosPacker.generateCircles(bounds, count:circles.count, packingCenter: self.frame.origin, minRadius: 30, maxRadius: 50) { [unowned self] circle in
            circle.backgroundColor = UIColor.Random()
            circle.userInteractionEnabled = true
            circle.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "onPan:"))
            self.addSubview(circle)
        }
        _ = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "updateFrame", userInfo: nil, repeats: true)
        
    }
    func updateFrame(){
        photosPacker.onFrameMove(1)
    }
    func onPan(sender: UIPanGestureRecognizer) {
        //swit
        print("updating")
        switch sender.state {
        case .Began :
            //let pos = sender.locationInView(self.superview)
            //photosPacker.selectCircle(pos)
            break
        case .Changed:
            if photosPacker.dragginCircle != nil {
               photosPacker.dragginCircle?.center = sender.locationInView(self.superview)
            }
        case .Ended:
            photosPacker.dragginCircle = nil
        default:
            break
        }
    } 
}

class CircleView:UIView, PackedView {
    /*
    override var frame:CGRect {
        willSet{
            let newX = newValue.origin.x + newValue.size.width / 2
            let newY = newValue.origin.y + newValue.size.height / 2
            
            self.frame = CGRect(x: newX, y: newY, width: newValue.size.width, height: newValue.size.height)
            self.content.frame = self.bounds
        }
    }*/
    override var center: CGPoint {
        didSet{
            //let newX = center.x - radius
            //let newY = center.y - radius
            //self.frame.origin = CGPoint(x: newX, y: newY)
        }
    }
    
    var radius: CGFloat = 0 {
        didSet{
            self.frame.size = CGSize(width: radius * 2, height: radius * 2)
            self.layer.cornerRadius = (radius * 2) / 2
        }
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    convenience required init(center:CGPoint, radius:CGFloat) {
        self.init(frame:CGRect(x: center.x - radius,
                                y: center.y - radius,
                            width: radius * 2,
                           height: radius * 2))

        self.layer.cornerRadius = (radius * 2) / 2
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.Random()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func ==(x: CircleView, y: CircleView) -> Bool {
    if x.center.x == y.center.x && x.center.y == y.center.y{
        return true
    }else {
        return false
    }
}
func !=(x: CircleView, y: CircleView) -> Bool {
    return !(x == y)
}

func <(x: CircleView, y: CircleView) -> Bool {
    return false
}
