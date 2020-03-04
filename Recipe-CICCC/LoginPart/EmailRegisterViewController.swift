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
    
//    @IBAction func pressBackToLoginMainSegue(_ sender: UIBarButtonItem) {
//        self.performSegue(withIdentifier: "LoginMain", sender: nil)
//    }
//
//
    
    @IBAction func pressBackToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginMainPage", sender: nil)
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
                
                if let error = error {
                    let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
//                if error == nil {
//                    print("You have successfully signed up")
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main Page")
//                    self.present(vc!, animated: true, completion: nil)
//                } else {
//                    let alertController = UIAlertController(title: "Registration Error", message: error?.localizedDescription, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
                
                if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                    changeRequest.commitChanges(completion: { (error) in
                        if let error = error {
                            print("Failed to change the display name: \(error.localizedDescription)")
                        }
                    })
                }
                
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                
                let alertController = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check yourinbox and click the verification link in that email to complete the sign up.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.view.endEditing(true)
                    
                })
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
}

