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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        dataManager.getShoppingListDetail(userID: uid)
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
                    //                    let item = ingredients[indexPath.row]//shoppingList.list[indexPath.row]
                    //                                        addVC.item = item
                    addVC.indexPath = indexPath
                    addVC.delegate = self as AddingShoppingListViewControllerDelegate
                    addVC.itemIsEmpty = false
                    addVC.isBought = ingredients[indexPath.row].isBought
                }
            }
        }
        if segue.identifier == "addShoppingIItem" {
            if let addVC = segue.destination as? AddingShoppingListViewController {
                addVC.delegate = self as AddingShoppingListViewControllerDelegate
                addVC.itemIsEmpty = true
            }
        }
    }
    
    
}


extension ShoppinglistViewController: UITableViewDelegate {
    
}

extension ShoppinglistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { return 1 }
        
        return ingredients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "findStores", for: indexPath) as? searchButtonTableViewCell)!
            
            return cell
        }
        else {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ingredientShopping", for: indexPath) as? IngredientShoppingTableViewCell)!
            
            cell.nameLabel.text = ingredients[indexPath.row].name
            cell.amountLabel.text = ingredients[indexPath.row].amount
            
            return cell
        }
    }
    
    
}

extension ShoppinglistViewController: AddingShoppingListViewControllerDelegate {
    func addIngredient(controller: AddingShoppingListViewController, name: String, amount: String, isBought: Bool) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        dataManager.addIngredient(name: name, amount: amount, isBought: isBought, userID: uid)
        print(ingredients)
        tableView.reloadData()
    }
    
    func editIngredient(controller: AddingShoppingListViewController, name: String, amount: String, isBought: Bool) {
        
       guard let uid = Auth.auth().currentUser?.uid else { return }
        dataManager.editIngredient(name: name, amount: amount, isBought: isBought, userID: uid)
        print(ingredients)
        dataManager.getShoppingListDetail(userID: uid)
        
        tableView.reloadData()
    }
    
}

extension ShoppinglistViewController: getIngredientDataDelegate {
    func gotData(ingredients: [IngredientShopping]) {
        
        self.ingredients = ingredients
        tableView.reloadData()
    }
}
