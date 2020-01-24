//
//  EmailLoginViewController.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2020-01-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class LoginMainpageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //mention that they didn't insert the text field
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
                (user, error) in
                if error == nil {
                    // means no error, login successfully
                    let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
                    self.navigationController?.pushViewController(vc, animated: true)
                   // self.present(vc, animated: true, completion: nil)
                    
                } else {
                    // mention there's some error
                    let alertController = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
//    @IBAction func otherWayToLogin(_ sender: Any) {
//        if Auth.auth().currentUser != nil {
//            do {
//                try Auth.auth().signOut()
//                let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
//                present(vc, animated: true, completion: nil)
//
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) {(
            Result, Error) in
            if let error = Error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current
                else {
                    print("Failed to get access token")
                    return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // call Firebase API to signin
            Auth.auth().signIn(with: credential, completion: {(user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // show the main View
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}
