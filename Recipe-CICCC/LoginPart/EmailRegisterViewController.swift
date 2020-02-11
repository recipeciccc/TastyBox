//
//  EmailRegisterViewController.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2019-12-10.
//  Copyright © 2019 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class EmailRegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
//    @IBAction func pressBackToLoginMainButton(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "backToLoginMainSegue", sender: nil)
//    }
    
    @IBAction func pressBackToLoginMainSegue(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "backToLoginMainSegue", sender: nil)
    }
    
    
    @IBAction func createAccountAction(_ sender: Any) {
        if emailTextField.text == nil || passwordTextField.text == nil || confirmPasswordTextField.text == nil {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
                
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Error", message: "Two passwords are not the same.", preferredStyle: .alert)
                
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
                
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main Page")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    
}

