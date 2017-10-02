//
//  ViewController.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 9/22/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift

class AWLIViewController: UIViewController {

    //private (set) var photosView:ZLSwipeableView!
    //private (set) var photosView:PhotosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.setupPhotosView()
        setupView()
        //photosView.generateViews([UIView(),UIView(),UIView(),UIView()])
        //customize UI
        if revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    private func setupView(){
        /*photosView = PhotosView(frame: CGRectZero)
        view.addSubview(photosView)
        photosView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraintsWithFormat("V:|-100-[v0]-50-|", views: photosView)
        view.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: photosView)
        */
    }
    /*
    private func setupPhotosView(){
        if photosView != nil {
            photosView.removeFromSuperview()
            photosView = nil
        }
        photosView = ZLSwipeableView(frame: CGRectZero)
        photosView.allowedDirection = .Left
        photosView.numberOfHistoryItem = UInt.max
        photosView.numberOfActiveView = 1
        
        
        view.addSubview(photosView)
        photosView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraintsWithFormat("V:|-100-[v0]-50-|", views: photosView)
        view.addConstraintsWithFormat("H:|-50-[v0]-50-|", views: photosView)
        
        photosView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        photosView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        photosView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        photosView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        photosView.didCancel = {view in
            print("Did cancel swiping view")
        }
        photosView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        photosView.didDisappear = { view in
            print("Did disappear swiping view")
        }
        
    }
    */
    @IBAction func showMenu(sender: AnyObject) {
        if self.revealViewController() != nil {
            self.revealViewController().revealToggle(true)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*self.photosView.nextView = {
            print("next")
            return self.nextPhotosView()
        }
        self.photosView.previousView = {
            print("prev")
            return self.prevPhotoView()
        }*/
    }
    @IBAction func undo(sender: AnyObject){
        ///self.photosView.rewind()
    }
    /*
    func nextPhotosView() -> UIView{ 
        
        let photoView = PhotosView(frame: self.view.bounds.insetBy(dx: 20, dy: 50))
        photoView.generateViews([UIView(),UIView(),UIView(),UIView()])
        photoView.backgroundColor = UIColor.clearColor()
        return photoView
    }*/
    private func prevPhotoView() -> UIView{
        let photoView = UIView(frame: self.view.bounds.insetBy(dx: 20, dy: 50))
        photoView.backgroundColor = UIColor.Random()
        return photoView
    }
}

