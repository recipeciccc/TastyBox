//
//  IngredientRefrigerator.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//


import Foundation
import Firebase

class IngredientRefrigerator: NSObject {
//    let ref: DatabaseReference?
    let key: String
    var name = ""
    var amount = ""
  
    
    
    init(name: String, amount: String, key: String = "") {
       
        self.key = key
        self.name = name
        self.amount = amount
        
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let amount = value["amount"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.name = name
        self.amount = amount
     
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "amount": amount,
           
        ]
    }
}
