//
//  SettingManager.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-26.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class SettingManager{
    
    let ref = Firestore.firestore().collection("user")
    weak var delegate: getAllergicFoodDelegate?
    var allFood = [AllergicFoodData]()
    
    func addCheckedAllergicFood(userID: String,allergicFood : String){
        
        ref.document(userID).collection("allergicFood").document(allergicFood).setData([
            "food": allergicFood,
            "check": true,
            "uid":userID
        ], merge: true ){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("check data:\(allergicFood)")
            }
        }
       
    }
    
     func addAllFood(userID: String,allergicFood : String){
           ref.document(userID).collection("allergicFood").document(allergicFood).setData([
               "food": allergicFood,
               "check": false,
               "uid":userID
           ], merge: true) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
       }
    
    func removeCheckedFood(userID: String ,allergicFood : String) {
        
        ref.document(userID).collection("allergicFood").document(allergicFood).setData([
            "food": allergicFood,
            "check": false,
            "uid":userID], merge: true){ err in
                
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("remove data: \(allergicFood)")
                
            }
        }
        
    }
    
    func getAllFood(userID: String, index: Int){
        var food = [String]()
        ref.document(userID).collection("allergicFood").getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                 for document in querySnapshot!.documents {
                    let data  = document.data()
                    if let foodName = data["food"]{
                        food.append(foodName as! String)
                        print("all: \(foodName)")
                        let check = data["check"]
                        self.allFood.append(AllergicFoodData(allergicFood: foodName as! String, checkedFood: check as? Bool))
                    }
                 }
                self.delegate?.getFoodData(foodList:self.allFood,index:index)
             }
         }
    }
    
    func getCheckedItemInAllFood(userID:String,index:Int) -> [String] {
        var food = [String]()
        ref.document(userID).collection("allergicFood").whereField("check", isEqualTo: true).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                   let data  = document.data()
                   if let foodName = data["food"]{
                       food.append(foodName as! String)
                       print("checked: \(foodName)")
                   }
                }
                self.delegate?.getCheckedData(foodList:food, index:index)
            }
        }
        return food
    }
    
    
}
