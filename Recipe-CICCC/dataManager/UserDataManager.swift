//
//  UserDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class UserdataManager {
    
    let db = Firestore.firestore()
    var delegate: getUserDataDelegate?
    
    var users: [User] = []
    var user: User?
    var followers: [String] = []
    var following: [String] = []
    
//    func getUsersDetail() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        db.collection("user").addSnapshotListener {
//            (querysnapshot, error) in
//            if error != nil {
//                print("Error getting documents: \(String(describing: error))")
//            } else {
//                
//                //For-loop
//                for documents in querysnapshot!.documents
//                {
//                    
//                    let data = documents.data()
//                    
//                    print("data count: \(data.count)")
//                    
//                    let name = data["name"] as? String
//                    let userID = data["userID"] as? String
//                    
//                    self.findFollowerFollowing(id: uid, collection: "followers")
//                    self.findFollowerFollowing(id: uid, collection: "followers")
//                    
//                    let followersID = self.followers
//                    let followingID = self.following
//                    
//                    let user = User(userID: userID!, name: name!, followersID: followersID, followingID: followingID)
//                    
//                    self.users.append(user)
//                }
//            }
//            
//            self.delegate?.gotUsersData(users: self.users)
//            
//        }
//    }
    

    func getUserDetail(id: String?) {
        
        var uid: String = ""
        
        if id == nil {
            uid = Auth.auth().currentUser!.uid
        } else {
            uid = id!
        }
        
        db.collection("user").document(uid).addSnapshotListener {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                let data = querysnapshot!.data()
                
                print("data count: \(data!.count)")
                
                let name = data!["name"] as? String
                let userID = data!["userID"] as? String
                
                self.findFollowerFollowing(id: uid, collection: "followers")
                self.findFollowerFollowing(id: uid, collection: "followers")
                
                let followersID = self.followers
                let followingID = self.following
                
                self.user = User(userID: userID!, name: name!, followersID: followersID, followingID: followingID)
            }
            
            self.delegate?.gotUserData(user: self.user!)
            
        }
    }
    

    
    func increaseFollower(userID: String, followerID: String) {
        db.collection("user").document(userID).collection("followers").document(followerID).setData([
            "id": followerID
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        db.collection("user").document(followerID).collection("following").document(userID).setData([
            "id": userID
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func findFollowerFollowing(id: String, collection: String) {
        let uid = (Auth.auth().currentUser?.uid)!
        
        db.collection("user").document(uid).collection("\(collection)").addSnapshotListener {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                for documents in querysnapshot!.documents {
                    let data = documents.data()
                    
                    if collection == "following" {
                        self.following.append(data["id"] as! String)
                    } else {
                        self.followers.append(data["id"] as! String)
                    }
                }
            }
    }
}
    
    func userRegister(userName: String, eMailAddress: String, familySize: Int, cuisineType: String) {
        
        let uid = (Auth.auth().currentUser?.uid)!
        db.collection("user").document(uid).collection("profile").document().setData([
            "id": uid,
            "userName": userName,
            "eMailAddress": eMailAddress,
            "familySize": familySize
            
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

