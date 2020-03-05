//
//  AddingShoppingListViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit


protocol AddingShoppingListViewControllerDelegate: class {
    
    func editItemViewController(_ controller: AddingShoppingListViewController, didFinishEditting item: IngredientShopping, indexPath: IndexPath)
    
    func editItemViewController(_ controller: AddingShoppingListViewController, addItem item: IngredientShopping, indexPath: IndexPath)
    
    func editItemViewController(_ controller: AddingShoppingListViewController, addItemName name: String, addItemAmount amount: String, indexPath: IndexPath)
    
}

class AddingShoppingListViewController: UIViewController {
   
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
//    var item = IngredientShopping()
    var itemIsEmpty:Bool?
    var indexPath = IndexPath()
    var shoppingList = ShoppingList()
    weak var delegate:AddingShoppingListViewControllerDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
//        ingredientNameTextField.text = item.name
//        amountTextField.text = item.amount
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        ingredientNameTextField.delegate = self
        amountTextField.delegate = self
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        
//
//        self.item.name = ingredientNameTextField.text ?? ""
//        self.item.amount = amountTextField.text ?? ""
//
        if itemIsEmpty == false {
           // delegate?.editItemViewController(self, didFinishEditting: self.item, indexPath: indexPath)
        } else {
            delegate?.editItemViewController(self, addItemName: ingredientNameTextField.text ?? "", addItemAmount: amountLabel.text ?? "", indexPath: indexPath)
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

extension AddingShoppingListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            ingredientNameTextField.resignFirstResponder()
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
