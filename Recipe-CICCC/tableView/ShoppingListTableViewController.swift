//
//  ShoppingListTableViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class ShoppingListTableViewController: UITableViewController {
    
//    let shoppingList = ShoppingList()
    var shoppingList = [IngredientShopping]()
    
//    var item = IngredientShopping()
    weak var delegate: AddingShoppingListViewControllerDelegate?
    var database: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        database = Database.database().reference().child("item")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
       
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 2:
            return  shoppingList.count //shoppingList.list.count
        default:
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "searchBar", for: indexPath) as? SearchIngredientTableViewCell)!

            // Configure the cell...

            return cell
        case 1:
        let cell =  (tableView.dequeueReusableCell(withIdentifier: "searchStores", for: indexPath) as? searchButtonTableViewCell)!

            // Configure the cell...

            return cell
            
        case 2:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "IngredientsInShoppingList", for: indexPath) as? IngredietntShoppingListTableViewCell)!

            // Configure the cell...
//
//            cell.nameLabel.text = shoppingList.list[indexPath.row].name
//
//            cell.amountLabel.text = shoppingList.list[indexPath.row].amount
            
            
            cell.nameLabel.text = shoppingList[indexPath.row].name
            
            cell.amountLabel.text = shoppingList[indexPath.row].amount
            
            

            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editItemShopping" {
            if let addVC = segue.destination as? AddingShoppingListViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let item =  shoppingList[indexPath.row]//shoppingList.list[indexPath.row]
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

extension ShoppingListTableViewController: AddingShoppingListViewControllerDelegate {
    func editItemViewController(_ controller: AddingShoppingListViewController, addItemName name: String, addItemAmount amount: String, indexPath: IndexPath) {
        
        
        
        // 2
        
        let groceryItemRef = self.database.child(name.lowercased())
        
        var groceryItem = IngredientShopping(name: name, amount: amount, ref: groceryItemRef, isBought: false)
        
        // 4
        groceryItemRef.setValue(groceryItem.toAnyObject())
        
        shoppingList.append(groceryItem)
        
        self.tableView.reloadData()
    }
    
   
    
    func editItemViewController(_ controller: AddingShoppingListViewController, didFinishEditting item: IngredientShopping, indexPath: IndexPath) {
        //
        //        shoppingList.list.remove(at: indexPath.row)
        //        shoppingList.list.insert(item, at: indexPath.row)
        
//        let name = item.name, amount = item.amount
//        let shoppingData = ["name": name, "amount": amount]
//        database.childByAutoId().setValue(shoppingData)
//
//        // 2
//
//        let groceryItemRef = self.database.child(item.name.lowercased())
//
//        var groceryItem = IngredientShopping(name: item.name, amount: item.amount, ref: groceryItemRef, isBought: false)
//        // 3
//        let groceryItemRef = self.ref.child(item.name.lowercased())
//
//        // 4
//        groceryItemRef.setValue(groceryItem.toAnyObject())
//
        
        
        self.tableView.reloadData()
    }

    
    func editItemViewController(_ controller: AddingShoppingListViewController, addItem item: IngredientShopping, indexPath: IndexPath){
//        shoppingList.list.append(item)
        let name = item.name, amount = item.amount
        let shoppingData = ["name": name, "amount": amount]
        database.childByAutoId().setValue(shoppingData)
        
        // 2
        
        let groceryItemRef = self.database.child(item.name.lowercased())
        
        var groceryItem = IngredientShopping(name: item.name, amount: item.amount, ref: groceryItemRef, isBought: false)
        
        // 4
        groceryItemRef.setValue(groceryItem.toAnyObject())
        
        shoppingList.append(groceryItem)
        
        self.tableView.reloadData()
    }
    
   
}
