//
//  FollowingViewControllerDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-28.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol FollowingFollowerManagerDelegate: class {
    //    func deleteFollowings(user:User)
    func assignFollowersFollowings(users: [User])
    func assginFollowersFollowingsImages(image: UIImage, index: Int)
}

class FollowingFollowerDataManager {
    
    let uid = Auth.auth().currentUser?.uid
    var user: User?
    var followings:[User] = []
    var followers: [User] = []
    let db = Firestore.firestore()
    weak var delegate: FollowingFollowerManagerDelegate?
    
    
    func unfollowing(user: User) {
        
        db.collection("user").document(uid!).collection("following").document(user.userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                
            }
        }
    }
    
    func getFollowersFollowings(IDs: [String], followerOrFollowing: String) {
        
        for ID in IDs {
            
            db.collection("user").document(ID).addSnapshotListener {
                (querysnapshot, error) in
                if error != nil {
                    print("Error getting documents: \(String(describing: error))")
                } else {
                    
                    if let data = querysnapshot!.data() {
                        
                        print("data count: \(data.count)")
                        
                        
                        guard let userID = data["id"] as? String else { return }
                        guard let name = data["userName"] as? String else { return }
                        guard let familySize = data["familySize"] as? Int else { return }
                        guard let cuisineType = data["cuisineType"] as? String else { return }
                        
                        
                        self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize)
                        
                        if followerOrFollowing == "following" {
                            self.followings.append(self.user!)
                            if ID == IDs.last! {
                                self.delegate?.assignFollowersFollowings(users: self.followings)
                            }
                        }
                        else if followerOrFollowing == "follower" {
                            self.followers.append(self.user!)
                            if ID == IDs.last! {
                                self.delegate?.assignFollowersFollowings(users: self.followers)
                            }
                        }
                        
                    }
                    
                }
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
