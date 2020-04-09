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
    var delegateFollowerFollowing :FolllowingFollowerDelegate?
    
    
    var users: [User] = []
    var user: User?
    var followersIDs: [String] = []
    var followingsIDs: [String] = []
    var followers: [User] = []
    var followings: [User] = []
    
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
                
                
                let userID = data!["id"] as? String
                let name = data!["userName"] as? String
                let familySize = data!["familySize"] as? Int
                let cuisineType = data!["cuisineType"] as? String
                
                
                self.user = User(userID: userID!, name: name!, cuisineType: cuisineType!, familySize: familySize!)
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
    
    func getFollowersFollowings(IDs: [String], followerOrFollowing: String) {
    
        for ID in IDs {
            
            db.collection("user").document(ID).addSnapshotListener {
                (querysnapshot, error) in
                if error != nil {
                    print("Error getting documents: \(String(describing: error))")
                } else {
                    
                    let data = querysnapshot!.data()
                    
                    print("data count: \(data!.count)")
                    
                    
                    let userID = data!["id"] as? String
                    let name = data!["userName"] as? String
                    let familySize = data!["familySize"] as? Int
                    let cuisineType = data!["cuisineType"] as? String
                    
                    
                    self.user = User(userID: userID!, name: name!, cuisineType: cuisineType!, familySize: familySize!)
                    
                    if followerOrFollowing == "following" {
                        self.followings.append(self.user!)
                        self.delegateFollowerFollowing?.assignFollowersFollowings(users: self.followings)
                    }
                    if followerOrFollowing == "follower" {
                        self.followers.append(self.user!)
                        self.delegateFollowerFollowing?.assignFollowersFollowings(users: self.followers)
                    }
                    
                }
                
            }
            
        }
    }
        
        func findFollowerFollowing(id: String?, collection: String) {
            var uid = (Auth.auth().currentUser?.uid)!
            
            if id != nil {
                uid = id!
            }
            
            db.collection("user").document(uid).collection("following").addSnapshotListener {
                (querysnapshot, error) in
                if error != nil {
                    print("Error getting documents: \(String(describing: error))")
                } else {
                    for document in querysnapshot!.documents {
                        let data = document.data()
                        self.followingsIDs.append(data["id"] as! String)
                    }
                    
                    self.db.collection("user").document(uid).collection("follower").addSnapshotListener {
                        (querysnapshot, error) in
                        if error != nil {
                            print("Error getting documents: \(String(describing: error))")
                        } else {
                            for document in querysnapshot!.documents {
                                let data = document.data()
                                
                                self.followersIDs.append(data["followerID"] as! String)
                                
                            }
                            
                            self.delegateFollowerFollowing?.passFollowerFollowing(followingsIDs: self.followingsIDs, followersIDs: self.followersIDs)
                        }
                    }
                }
            }
        }
        
        func userRegister(userName: String, eMailAddress: String, familySize: Int, cuisineType: String) {
            
            let uid = (Auth.auth().currentUser?.uid)!
            
            //        db.collection("user").document(uid).collection("proifle").document("info").setData([
            db.collection("user").document(uid).setData([
                
                "id": uid,
                "userName": userName,
                "eMailAddress": eMailAddress,
                "familySize": familySize,
                "cuisineType": cuisineType
                
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        func saveRecipe(recipeID: String) {
            
            let uid = Auth.auth().currentUser?.uid
            db.collection("user").document(uid!).collection("savedRecipes").document(recipeID).setData([
                
                "id": recipeID,
                "savedTime": Timestamp(),
                
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
        func getSavedRecipesImage(recipeIDs: [String]) {
            
            for recipeID in recipeIDs {
                
            }
        }
    
}
