//
//  IngredientShopping.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class IngredientShopping: NSObject {
//    let ref: DatabaseReference?
    let key: String
    var name = ""
    var amount = ""
    var isBought: Bool?
    
    
    init(name: String, amount: String, isBought: Bool, key: String = "") {
       
        self.key = key
        self.name = name
        self.amount = amount
        self.isBought = isBought
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let amount = value["amount"] as? String,
            let isBought  = value["isBought"] as? Bool
            else {
                return nil
        }
        
        self.key = snapshot.key
        self.name = name
        self.amount = amount
        self.isBought = isBought
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "amount": amount,
            "isBought": isBought
        ]
    }
}
