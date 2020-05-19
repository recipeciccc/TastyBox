//
//  IngredientRefrigerator.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class IngredientRefrigeratorDataManager {
    
    let db = Firestore.firestore()
    
    var delegate: getIngredientRefrigeratorDataDelegate?
    
    var ingredients:[IngredientRefrigerator] = []
    
    func editIngredient(name: String, amount: String, userID: String) {
        
        db.collection("user").document(userID).collection("refrigerator").document(name).setData(
            [ "name": name,
              "amount": amount,], merge: true)
    }
    
    func addIngredient(name: String, amount: String, userID: String) {
        
        db.collection("user").document(userID).collection("refrigerator").document(name).setData([
            "name": name,
            "amount": amount,
            
        ],merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func getRefrigeratorDetail(userID: String) {
        
        db.collection("user").document(userID).collection("refrigerator").addSnapshotListener { querySnapshot, error in
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
                    
                    let ingredient = IngredientRefrigerator(name: name!, amount: amount!)
                    
                    self.ingredients.append(ingredient)
                    
                }
                
                if querySnapshot?.documents.count == 0 {
                    self.delegate?.gotData(ingredients: self.ingredients)
                }
                
            }
            
            self.delegate?.gotData(ingredients: self.ingredients)
            
        }
        
    }
    
    func deleteData(name: String, indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("user").document(uid).collection("refrigerator").document(name).delete()
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
        
        db.collection("user").document(uid).collection("refrigerator").whereField("name", isEqualTo: text).getDocuments{ (querySnapshot, err) in
            //the data has returned from firebase and is valid
            
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                
                self.ingredients.removeAll()
                
                if !querySnapshot!.isEmpty {
                    
                    for documents in querySnapshot!.documents {
                        
                        let data = documents.data()
                        
                        print("data count: \(data.count)")
                        
                        let name = data["name"] as? String
                        let amount = data["amount"] as? String
                        
                        let ingredient = IngredientRefrigerator(name: name!, amount: amount!)
                        
                        self.ingredients.append(ingredient)
                        
                    }
                    
                } else {
                    print("No Ingredients found")
                }
                
            }
        }
        
    }
    
}


