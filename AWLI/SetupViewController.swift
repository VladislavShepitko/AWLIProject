//
//  SetupViewController.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 9/22/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class SetupViewController: UINavigationController {

    let atFirstTime = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if atFirstTime {
            performSegueWithIdentifier("introScreen", sender: self)
        }
    }
}
