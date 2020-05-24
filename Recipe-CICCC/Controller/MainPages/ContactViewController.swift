//
//  ContactViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-28.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import MessageUI
import Crashlytics

class ContactViewController: UIViewController {

   
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBAction func emailSend(_ sender: Any) {
        //This need to be run at the device.
        emailComposer()
        scrollView.delegate = self
        
    }
    
    override func viewDidLoad() {
        roundCorners(view: sendBtn, cornerRadius: 25.0)
        
//        scrollView.contentSize.height = self.view.frame.height
        self.scrollView.contentSize = self.view.frame.size
    }
    func emailComposer(){
        if MFMailComposeViewController.canSendMail() == true {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["recipeciccc@gmail.com"])
            composer.setSubject("User Feedback")
            composer.setMessageBody("Hello! Please type your feedback, we are glad to hear from you!", isHTML: false)
            present(composer,animated:true)
        }else{
            return
        }
        
    }
    func roundCorners(view: UIView, cornerRadius: Double) {
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
    }
}

extension ContactViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        @unknown default:
            print("default")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ContactViewController:UIScrollViewDelegate {
    
}
