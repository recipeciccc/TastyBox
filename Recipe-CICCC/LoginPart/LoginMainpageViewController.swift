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

class LoginMainpageViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        emailTextField.resignFirstResponder()
//        let nextTag = emailTextField.tag + 1
//        if let nextTextField = self.view.viewWithTag(nextTag) {
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            emailTextField.contentInset = .zero
        } else {
            emailTextField.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        emailTextField.scrollIndicatorInsets = emailTextField.contentInset

        let selectedRange = emailTextField.selectedRange
        emailTextField.scrollRangeToVisible(selectedRange)
    }
}
