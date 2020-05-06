//
//  AboutViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-29.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class AboutViewController: UIViewController {

    
    @IBOutlet weak var firstPart: UITextView!
    @IBOutlet weak var secondPart: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var isFirst: Bool?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFirst == true {
            firstPart.isHidden = true
            secondPart.isHidden = false
            
            let agreeButton = UIBarButtonItem(title: "Agree", style: .plain, target: self, action: #selector(agreeTermsAndConditions))
            self.navigationItem.rightBarButtonItem = agreeButton
        
        } else {
        
            firstPart.isHidden = false
            secondPart.isHidden = true
        }
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
    }
    
    @objc func agreeTermsAndConditions() {
        
        let alert = UIAlertController(title: "Thank you", message: "You can check this terms and conditions and privacy policy in about page in menu bar anytime.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            let Storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "FirstTimeProfile")
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
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



