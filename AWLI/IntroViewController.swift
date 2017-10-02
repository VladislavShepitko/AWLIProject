//
//  IntroViewController.swift
//  AWLI
//
//  Created by Vladyslav Shepitko on 9/22/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBAction func finishIntro(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
}
