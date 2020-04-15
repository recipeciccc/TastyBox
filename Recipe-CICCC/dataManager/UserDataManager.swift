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
import FirebaseAuth

class UserdataManager {
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var delegate: getUserDataDelegate?
    var delegateFollowerFollowing :FolllowingFollowerDelegate?
    
    
    var users: [User] = []
    var user: User?
    var followersIDs: [String] = []
    var followingsIDs: [String] = []
    var followers: [User] = []
    var followings: [User] = []
    
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
            }
            else {
               
                if let data = querysnapshot!.data() {
                
                    print("data count: \(data.count)")
                
                
                    let userID = data["id"] as? String
                    let name = data["userName"] as? String
                    let familySize = data["familySize"] as? Int
                    let cuisineType = data["cuisineType"] as? String
                
                
                self.user = User(userID: userID!, name: name!, cuisineType: cuisineType!, familySize: familySize)
                self.delegate?.gotUserData(user: self.user!)

                }
            }
            
            
        }
    }
    
    
    
    func increaseFollower(userID: String, followerID: String) {
        db.collection("user").document(userID).collection("follower").document(followerID).setData([
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
                        
                        if let documents = querysnapshot?.documents {
                            for document in documents {
                                
                                let data = document.data()
                                self.followersIDs.append(data["id"] as! String)
                                
                            }
                            
                            self.delegateFollowerFollowing?.passFollowerFollowing(followingsIDs: self.followingsIDs, followersIDs: self.followersIDs)
                        }
                        
                    }
                }
            }
        }
    }
    
    func userRegister(userName: String, eMailAddress: String, familySize: Int, cuisineType: String, accountImage: UIImage) {
        
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
        
        guard let imgData = accountImage.jpegData(compressionQuality: 0.75) else{ return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.child("user/\(uid)/userAccountImage").putData(imgData, metadata: metaData){ (metaData, error) in
            if error == nil, metaData != nil{
                print("success")
                
            }else{
                print("error in save image")
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
    
    func getUserImage(uid: String) {
        let imageRef = storageRef.child("user/\(uid)/userAccountImage")
        var image: UIImage?
        // Fetch the download URL
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data {
                    
                    print("imageRef: \(imageRef)")
                    
                    image = UIImage(data: imgData)!
                    self.delegate?.assignUserImage(image: image!)
                }
            }
        }
    }
    
    func getUserImageInFirst() {
        
        let uid = Auth.auth().currentUser?.uid
        let imageRef = storageRef.child("user/\(String(describing: uid!))/userAccountImage")
        var image: UIImage?
        // Fetch the download URL
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                image = #imageLiteral(resourceName: "Mask Group")
                self.delegate?.assignUserImage(image: image!)
                
                print(error?.localizedDescription as Any)
            }
            else {
                
                if let imgData = data {
                    image = UIImage(data: imgData)!
                    self.delegate?.assignUserImage(image: image!)
                }
            }
        }
        
    }
}
