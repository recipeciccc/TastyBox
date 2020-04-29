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
    func assginFollowersFollowingsImages(image: UIImage, index: Int)
}

class FollowingViewControllerDataManager {
    
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    weak var delegate: FollowingViewControllerDataManagerDelegate?
    
    
    func unfollowing(user: User) {
        
        db.collection("user").document(uid!).collection("following").document(user.userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                
            }
        }
    }
    
    func getFollwersFollowingsImage(uid: String, index: Int) {
        let imageRef = Storage.storage().reference().child("user/\(uid)/userAccountImage")
        var image: UIImage?
        // Fetch the download URL
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data {
                    
                    print("imageRef: \(imageRef)")
                    
                    image = UIImage(data: imgData)!
                    self.delegate?.assginFollowersFollowingsImages(image: image!, index: index)
                }
            }
        }
    }
}
