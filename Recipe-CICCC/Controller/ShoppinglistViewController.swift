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
    let dataManager = IngredientShoppingDataManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = true
        
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
                    addVC.name = ingredients[indexPath.row].name
                    addVC.amount = ingredients[indexPath.row].amount
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
            cell.accessoryType = .none
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.isEditing {
            performSegue(withIdentifier: "editItemShopping", sender: nil)
        }
        else {
            ingredients[indexPath.row].isBought = true
            dataManager.deleteData(name: ingredients[indexPath.row].name, indexPath: indexPath)
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
         let cell = (tableView.dequeueReusableCell(withIdentifier: "ingredientShopping", for: indexPath) as? IngredientShoppingTableViewCell)!
        
        if editingStyle == .delete {
            dataManager.deleteData(name: ingredients[indexPath.row].name, indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
       
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !tableView.isEditing, identifier == "editItemShopping" {
            return false
        }
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(tableView.isEditing, animated: true)
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

extension ShoppinglistViewController: getIngredientShoppingDataDelegate {
    
    func gotData(ingredients: [IngredientShopping]) {
        
        self.ingredients = ingredients
      
        tableView.reloadData()
    
    }
}

extension ShoppinglistViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if searchBar.text != "" {
            ingredients.removeAll()
            dataManager.searchIngredients(text: searchBar.text!, tableView: self.tableView)
        } else {
            dataManager.getShoppingListDetail(userID: uid)
        }
        
    }
    
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
}


