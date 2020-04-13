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
import GoogleSignIn

class LoginMainpageViewController: UIViewController, UITextFieldDelegate {
    
    var userImage: UIImage = #imageLiteral(resourceName: "imageFile")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.navigationItem.hidesBackButton = true;
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
      
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        
    
    
    @IBAction func unwindtoLoginMain(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBOutlet weak var login: UIButton!
    @IBAction func loginAction(_ sender: Any) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //mention that they didn't insert the text field
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) {
                (user, error) in
                
                if let error = error {
                    let alertController = UIAlertController(title: "Login Error", message:error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                guard let currentUser = Auth.auth().currentUser, currentUser.isEmailVerified else {
                    let alertController = UIAlertController(title: "Login Error", message:"You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verification link in that email. If you need us to send the confirmation email again, please tap Resend Email.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Resend email", style: .default,handler: { (action) in
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                self.view.endEditing(true)
                self.passwordTextField.text = ""
         
                    let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
                    self.navigationController?.pushViewController(vc, animated: true)
//
//                if error == nil {
//                    // means no error, login successfully
//                    self.login.isEnabled = false
//                    let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
//                    self.navigationController?.pushViewController(vc, animated: true)
//                   // self.present(vc, animated: true, completion: nil)
//
//                } else {
//                    // mention there's some error
//                    let alertController = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
                //LoginProperties.user = AppUser(authData: user!)
            }
        }
    }
    
// Facebook Login
    @IBAction func facebookLogin(_ sender: UIButton) {
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
            Auth.auth().signIn(with: credential, completion: { user, error in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                // present the main View
                if error == nil {
                    let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
//                LoginProperties.user = AppUser(authData: user!)
            })
        }
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        emailTextField.resignFirstResponder()
//        let nextTag = emailTextField.tag + 1
//        if let}nextTextField = self.view.viewWithTag(nextTag) {
//            nextTextField.becomeFirstResponder()
//            return true
//        }
//        passwordTextField.resignFirstResponder()
//        return true

        switch textField.tag {
        case 1:
            // they work
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case 2:
            // not close the keyboard
            textField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 100
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
  
    @IBAction func googleLogin(sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
}

extension LoginMainpageViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            // present the main view
            if error == nil {
                
                //MARK: uncomment out and you don't need to edit info every time
                if (user?.additionalUserInfo!.isNewUser)! {
                    let Storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "FirstTimeProfile")
                    self.navigationController?.pushViewController(vc, animated: true)
                //MARK: uncomment out and you don't need to edit info every time
                } else {
                    let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

        })
     
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
    
