//
//  FollowingViewControllerDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-28.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol FollowingViewControllerDataManagerDelegate: class {
    func deleteFollowings(user:User)
}

class FollowingViewControllerDataManager {
    
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    weak var delegate: FollowingViewControllerDataManager?
    
    
    func unfollowing(user: User) {
        
        db.collection("user").document(uid!).collection("following").document(user.userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                
            }
        }
    }
}
