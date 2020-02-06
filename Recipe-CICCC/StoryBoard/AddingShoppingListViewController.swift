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
}

class AddingShoppingListViewController: UIViewController {
   
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    var item = IngredientShopping()
    var indexPath = IndexPath()
    var shoppingList = ShoppingList()
    weak var delegate:AddingShoppingListViewControllerDelegate?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ingredientNameTextField.text = item.name
        amountTextField.text = item.amount
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
            self.item.name = ingredientNameTextField.text ?? ""
            self.item.amount = amountTextField.text ?? ""
            delegate?.editItemViewController(self, didFinishEditting: self.item, indexPath: indexPath)
        
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
