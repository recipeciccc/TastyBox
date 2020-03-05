//
//  ShoppinglistViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase


class ShoppinglistViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients:[IngredientShopping] = []
    let db = Firestore.firestore()
    let dataManager = IngredientDataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        dataManager.getReipeDetail()
        dataManager.delegate = self
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editItemShopping" {
            if let addVC = segue.destination as? AddingShoppingListViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let item = ingredients[indexPath.row]//shoppingList.list[indexPath.row]
                    //                    addVC.item = item
                    addVC.indexPath = indexPath
                    addVC.delegate = self as! AddingShoppingListViewControllerDelegate
                    addVC.itemIsEmpty = false
                }
            }
        }
        if segue.identifier == "addShoppingIItem" {
            if let addVC = segue.destination as? AddingShoppingListViewController {
                addVC.delegate = self as! AddingShoppingListViewControllerDelegate
                addVC.itemIsEmpty = true
            }
        }
    }
    
    
}


extension ShoppinglistViewController: UITableViewDelegate {
    
}

extension ShoppinglistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.cellForRow(at: indexPath) as? IngredietntShoppingListTableViewCell)!
        
        cell.nameLabel.text = ingredients[indexPath.row].name
        cell.amountLabel.text = ingredients[indexPath.row].amount
        
        return cell
        
    }
    
    
}

extension ShoppinglistViewController: AddingShoppingListViewControllerDelegate {
    func addIngredient(controller: AddingShoppingListViewController, name: String, amount: String, isBought: Bool) {
        
        dataManager.addIngredient(name: name, amount: amount, isBought: isBought)
        
    }
    
    func editIngredient(controller: AddingShoppingListViewController, name: String, amount: String, isBought: Bool) {
        
        dataManager.editIngredient(name: name, amount: amount, isBought: isBought)
    
    }

}

extension ShoppinglistViewController: getIngredientDataDelegate {
    func gotData(ingredients: [IngredientShopping]) {
        
        self.ingredients = ingredients
    
    }
}
