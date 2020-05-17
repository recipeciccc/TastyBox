//
//  AddingIngredientRefrigeratorViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

protocol AddingIngredientRefrigeratorViewControllerDelegate: class {
    func editIngredient(controller: AddingIngredientRefrigeratorViewController, name: String, amount: String)
    
    func addIngredient(controller: AddingIngredientRefrigeratorViewController, name: String, amount: String)
}

class AddingIngredientRefrigeratorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var name: String?
    var amount: String?
    
    var indexPath: IndexPath?
    weak var delegate: AddingIngredientRefrigeratorViewControllerDelegate?
    var itemIsEmpty: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        nameTextField.delegate = self
        amountTextField.delegate = self
        
        if name != nil, amount != nil {
            nameTextField.text = name
            amountTextField.text = amount
        }
    }
    
    
    @IBAction func done(_ sender: Any) {
        
        if itemIsEmpty! {
            self.delegate?.addIngredient(controller: self, name: nameTextField.text ?? "NONE", amount: amountTextField.text ?? "NONE")
        } else {
            self.delegate?.editIngredient(controller: self,  name: nameTextField.text ?? "NONE", amount: amountTextField.text ?? "NONE")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension AddingIngredientRefrigeratorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            nameTextField.resignFirstResponder()
            amountTextField.becomeFirstResponder()
        case 1:
            amountTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
