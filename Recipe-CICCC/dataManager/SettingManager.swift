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
    
    func addAllergicFood(userID: String,allergicFood : String){
        ref.document(userID).collection("allergicFood").document(allergicFood).setData([
            "food": allergicFood,
            "uid":userID
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func deleteFood(userID: String ,allergicFood : String) {
        ref.document(userID).collection("allergicFood").document(allergicFood).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed")
            }
        }
    }
    
    func getAllergicFood(userID: String) -> [String]{
        var currentfoodsName = [String]()
        ref.document(userID).collection("allergicFood").getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
             } else {
                 for document in querySnapshot!.documents {
                    let data  = document.data()
                    if let foodName = data["food"]{
                        currentfoodsName.append(foodName as! String)
                        print("\(foodName)")
                    }
                 }
             }
         }
        return currentfoodsName
    }
}
