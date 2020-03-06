//
//  IngredientDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class IngredientDataManager {
    
    let db = Firestore.firestore()
    
    var delegate: getIngredientDataDelegate?
    
    var ingredients:[IngredientShopping] = []
    
    func editIngredient(name: String, amount: String, isBought: Bool, userID: String) {
        
        db.collection("user").document(userID).collection("ingredient").document(name).setData(
            [ "name": name,
              "amount": amount,
              "isBought": isBought], merge: true)
    }
    
    func addIngredient(name: String, amount: String, isBought: Bool, userID: String) {
        
        db.collection("user").document(userID).collection("shoppingList").document().setData([
              "name": name,
              "amount": amount,
              "isBought": isBought
          ]) { err in
              if let err = err {
                  print("Error writing document: \(err)")
              } else {
                  print("Document successfully written!")
              }
          }
       
      }
    
    func getShoppingListDetail(userID: String) {
        
        // this cant be executed before put value to cell.textlabel
        //        db.collection("recipe").document("OfcILMhCh3LVMNhE60I7").getDocument(source: .cache) {
        //            (document, error) in
        //            if let document = document {
        //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        //                print("Cached document data: \(dataDescription)")
        //
        //                let data = document.data()
        //                 self.initRecipeDetail(data: data)
        //            } else {
        //                print("Document does not exist in cache")
        //              }
        //        }
        
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
        
}

