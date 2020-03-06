//
//  UserDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class UserdataManagerClass {
    
    let db = Firestore.firestore()
    var delegate: getUserDataDelegate?
    
    var user:User?
    
    
    func getUserDetail() {
        
        db.collection("user").getDocuments {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                //For-loop
                for documents in querysnapshot!.documents
                {
                   
                    let data = documents.data()
                    
                    print("data count: \(data.count)")
                    
                    let name = data["name"] as? String
                    let userID = data["userID"] as? String
                    
                    self.user = User(userID: userID!, name: name!)
                    
                }
            }
            
            self.delegate?.gotData(user: self.user!)
            
        }
    }
}

