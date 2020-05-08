//
//  IngredientDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class IngredientShoppingDataManager {
    
    let db = Firestore.firestore()
    
    var delegate: getIngredientShoppingDataDelegate?
    
    var ingredients:[IngredientShopping] = []
    
    
    func editIngredient(name: String, amount: String, isBought: Bool, userID: String) {
        
        db.collection("user").document(userID).collection("shoppingList").document(name).setData(
            [ "name": name,
              "amount": amount,
              "isBought": isBought], merge: true)
    }
    
    func addIngredient(name: String, amount: String, isBought: Bool, userID: String) {
        
        db.collection("user").document(userID).collection("shoppingList").document(name).setData([
            "name": name,
            "amount": amount,
            "isBought": isBought
        ],merge: true)
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func getShoppingListDetail(userID: String) {
        
        db.collection("user").document(userID).collection("shoppingList").addSnapshotListener { querySnapshot, error in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                self.ingredients.removeAll()
                //For-loop
                for documents in querySnapshot!.documents
                {
                    
                    
                    let data = documents.data()
                    
                    print("data count: \(data.count)")
                    
                    let name = data["name"] as? String
                    let amount = data["amount"] as? String
                    let isBought = data["isBought"] as? Bool
                    
                    let ingredient = IngredientShopping(name: name!, amount: amount!, isBought: isBought!)
                    
                    self.ingredients.append(ingredient)
                    
                }
            }
            
            self.delegate?.gotData(ingredients: self.ingredients)
            
        }
        
    }
    
    func deleteData(name: String, indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("user").document(uid).collection("shoppingList").document(name).delete()
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
        
    }
    
    func searchIngredients(text: String, tableView: UITableView) {
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        db.collection("user").document(uid).collection("shoppingList").whereField("name", arrayContains: text).getDocuments{ (querySnapshot, err) in
            //the data has returned from firebase and is valid
            
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                
                self.ingredients.removeAll()
                
                if (querySnapshot!.isEmpty == false){
                    
                    for documents in querySnapshot!.documents {
                        
                        let data = documents.data()
                        
                        print("data count: \(data.count)")
                        
                        let name = data["name"] as? String
                        let amount = data["amount"] as? String
                        let isBought = data["isBought"] as? Bool
                        
                        let ingredient = IngredientShopping(name: name!, amount: amount!, isBought: isBought!)
                        
                        self.ingredients.append(ingredient)
                        
                    }
                    
                } else {
                    print("No Ingredients found")
                }
                
                
                tableView.reloadData()
                
                
            }
        }
        //the code below here will execute *before* the code in the above closure
        self.delegate?.gotData(ingredients: self.ingredients)
    }
    
    
}


