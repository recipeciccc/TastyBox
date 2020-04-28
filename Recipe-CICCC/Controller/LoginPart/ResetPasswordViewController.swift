//
//  ResetPasswordViewController.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2019-12-10.
//  Copyright © 2019 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class ResetPasswordViewController: UIViewController {
    override func viewDidLoad() {
        roundCorners(view: submitBtn, cornerRadius: 5.0)
    }
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func submitAction(_ sender: Any) {
        
        if self.emailTextField.text == "" {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            
            } else {
                Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                    
                var title = ""
                var message = ""
                    
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
    

extension ResetPasswordViewController{
    func roundCorners(view: UIView, cornerRadius: Double) {
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
    }
}
