//
//  RefrigeratorViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class RefrigeratorViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var ingredients: [IngredientRefrigerator] = []
//    var searchResult:[IngredientRefrigerator] = []
    
    let db = Firestore.firestore()
    let dataManager = IngredientRefrigeratorDataManager()
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
        dataManager.getRefrigeratorDetail(userID: uid)
        dataManager.delegate = self //as getIngredientRefrigeratorDataDelegate
        searchBar.enablesReturnKeyAutomatically = false
        
       
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editItemRefrigerator" {
            if let addVC = segue.destination as? AddingIngredientRefrigeratorViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    //                    let item = ingredients[indexPath.row]//shoppingList.list[indexPath.row]
                    //                                        addVC.item = item
                    addVC.indexPath = indexPath
                    addVC.delegate = self as AddingIngredientRefrigeratorViewControllerDelegate
                    addVC.itemIsEmpty = false
                    addVC.name = ingredients[indexPath.row].name
                    addVC.amount = ingredients[indexPath.row].amount
                }
            }
        }
        if segue.identifier == "addIItemRefrigerator" {
            if let addVC = segue.destination as? AddingIngredientRefrigeratorViewController {
                addVC.delegate = self as AddingIngredientRefrigeratorViewControllerDelegate
                addVC.itemIsEmpty = true
            }
        }
    }

}

extension RefrigeratorViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "search stores", for: indexPath) as? searchStoresTableViewCell)!
            
            // Configure the cell...
            
            return cell
        }
        else if indexPath.section == 1 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ingredient", for: indexPath) as? IngredientsTableViewCell)!
            
            // Configure the cell...
            cell.ingredientsNameLabel.text = ingredients[indexPath.row].name
            cell.amountIngredientsLabel.text = ingredients[indexPath.row].amount
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

extension RefrigeratorViewController: UITableViewDelegate {
    
}



extension RefrigeratorViewController: getIngredientRefrigeratorDataDelegate {
    func gotData(ingredients: [IngredientRefrigerator]) {
        self.ingredients = ingredients
        tableView.reloadData()
    }
    
   
}

extension RefrigeratorViewController: AddingIngredientRefrigeratorViewControllerDelegate {
    func editIngredient(controller: AddingIngredientRefrigeratorViewController, name: String, amount: String) {
         guard let uid = Auth.auth().currentUser?.uid else { return }
        dataManager.addIngredient(name: name, amount: amount, userID: uid)
        dataManager.getRefrigeratorDetail(userID: uid)
        tableView.reloadData()
    }
    
    func addIngredient(controller: AddingIngredientRefrigeratorViewController, name: String, amount: String) {
         guard let uid = Auth.auth().currentUser?.uid else { return }
        dataManager.editIngredient(name: name, amount: amount, userID: uid)
        print(ingredients)
        dataManager.getRefrigeratorDetail(userID: uid)
        tableView.reloadData()
    }
    
}

extension RefrigeratorViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if searchBar.text != "" {
            ingredients.removeAll()
            dataManager.searchIngredients(text: searchBar.text!, tableView: self.tableView)
        } else {
            dataManager.getRefrigeratorDetail(userID: uid)
        }
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

