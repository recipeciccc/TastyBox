//
//  CreatorProfileDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class CreatorProfileDataManager {
      
    func unfollowing(userID: String) {
          
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("user").document(uid!).collection("following").document(userID).delete() { err in
              if let err = err {
                  print("Error removing document: \(err)")
              } else {
                
                  print("Document successfully removed!")
                  
              }
          }
        
        Firestore.firestore().collection("user").document(userID).collection("follower").document(uid!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
              
                print("Document successfully removed!")
                
            }
        }
      }
}
