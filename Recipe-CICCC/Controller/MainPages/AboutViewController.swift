//
//  AboutViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-29.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    
    @IBOutlet weak var firstPart: UITextView!
    @IBOutlet weak var secondPart: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPart.isHidden = false
        secondPart.isHidden = true
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
    }
    @IBAction func choiceAction(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            firstPart.isHidden = false
            secondPart.isHidden = true
        case 1:
            firstPart.isHidden = true
            secondPart.isHidden = false
        default:
            print("none")
        }
     
        
    }
    
}



