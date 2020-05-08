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

protocol recipeDetailDelegate: class {
    func isVIP(isVIP: Bool)
}


class UserdataManager {
    
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    weak var delegate: getUserDataDelegate?
    weak var delegateFollowerFollowing :FolllowingFollowerDelegate?
    weak var savedRecipesDelegate: SavedRecipeDelegate?
    weak var recipeDetailDelegate: recipeDetailDelegate?
    
    var users: [User] = []
    var user: User?
    var followersIDs: [String] = []
    var followingsIDs: [String] = []
    var followers: [User] = []
    var followings: [User] = []
    var savedRecipesIDs:[String] = []
    let uid = Auth.auth().currentUser?.uid
    
    func checkVIP() {
        
        let uid: String = Auth.auth().currentUser!.uid
        
        db.collection("user").document(uid).addSnapshotListener {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            }
            else {
                
                if let data = querysnapshot!.data() {
                    
                    print("data count: \(data.count)")
                    
                    if let isVIP = data["isVIP"] as? Bool {
                        self.recipeDetailDelegate?.isVIP(isVIP: isVIP)
                    }
                    
                }
            }
            
            
        }
    }
    
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
                    
                    
                    let userID = data["id"] as? String ?? ""
                    let name = data["userName"] as? String ?? ""
                    let familySize = data["familySize"] as? Int ?? 1
                    let cuisineType = data["cuisineType"] as? String ?? ""
                    let isVIP = data["isVIP"] as? Bool ?? false
                    
                    self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                    self.delegate?.gotUserData(user: self.user!)
                    
                }
            }
            
            
        }
    }
    
    
    func checkFollowing(followingID: String) {
        db.collection("user").document(uid!).collection("following").document(followingID).addSnapshotListener { (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                
            }
            
        }
    }
        
    
    
    func increaseFollower(userID: String, followerID: String) {
        
        db.collection("user").document(userID).collection("follower").document(followerID).setData([
            "id": followerID
            ],merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
        }
        
        db.collection("user").document(followerID).collection("following").document(userID).setData([
            "id": userID
        ],merge: true) { err in
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
                        if ID == IDs.last! {
                        self.delegateFollowerFollowing?.assignFollowersFollowings(users: self.followings)
                        }
                    }
                    if followerOrFollowing == "follower" {
                        self.followers.append(self.user!)
                         if ID == IDs.last! {
                        self.delegateFollowerFollowing?.assignFollowersFollowings(users: self.followers)
                        }
                    }
                    
                }
                
            }
            
        }
    }
    
    func findFollowerFollowing(id: String?) {
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
    
    func userRegister(userName: String, eMailAddress: String, familySize: Int, cuisineType: String, accountImage: UIImage, isVIP: Bool) {
        
        let uid = (Auth.auth().currentUser?.uid)!
        
        //        db.collection("user").document(uid).collection("proifle").document("info").setData([
        db.collection("user").document(uid).setData([
            
            "id": uid,
            "userName": userName,
            "eMailAddress": eMailAddress,
            "familySize": familySize,
            "cuisineType": cuisineType,
            "isVIP": isVIP
            
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
    
    func blockCreators(userID: String) {
        
        db.collection("user").document(uid!).setData([
            "blokingID": [userID:true]
            
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        let numUserBlocked: Double = 1
        db.collection("blokedIDs").document(userID).setData([
            
            userID: FieldValue.increment(numUserBlocked)
            
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        db.collection("user").document(uid!).collection("following").document(userID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        db.collection("user").document(uid!).collection("follower").document(userID).delete() { err in
                   if let err = err {
                       print("Error removing document: \(err)")
                   } else {
                       print("Document successfully removed!")
                   }
               }

        
    }
    
    func getSavedRecipes() {
        
        db.collection("user").document(uid!).collection("savedRecipes").order(by: "savedTime", descending: true).addSnapshotListener {
        (querysnapshot, error) in
        
        if error != nil {
            print("Error getting documents: \(String(describing: error))")
        } else {
            if let documents = querysnapshot?.documents {
                
                for document in documents {
                    let data = document.data()
                    if let id = data["id"] as? String {
                        self.savedRecipesIDs.append(id)
                    }
                }
               
            }
            }
        }
    }
    
    func Data(id: String) {
        var recipeList = [RecipeDetail]()
        var exist = Bool()
        db.collection("recipe").document(id).addSnapshotListener { (snapshot, err) in
            if err == nil {
               
                
                        
                if let data = snapshot?.data() {
                        let recipeId = data["recipeID"] as? String
                        let title = data["title"] as? String
                        let cookingTime = data["cookingTime"] as? Int
                        let like = data["like"] as? Int
                        let serving = data["serving"] as? Int
                        
                        let userId = data["userID"] as? String
                        let time = data["time"] as? Timestamp
                        
                        let image = data["image"] as? String
                        let genresData = data["genres"] as? [String: Bool]
                        
                        var genresArr: [String] = []
                        
                        if let gotData = genresData {
                            for genre in gotData {
                                genresArr.append(genre.key)
                            }
                        }
                        
                        
                  let isVIPRecipe = data["VIP"] as? Bool ?? false
                                                                                              
                                               let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr, isVIPRecipe: isVIPRecipe)
                                             
                        recipeList.append(recipe)
                        exist = true
                }
            } else {
                print(err?.localizedDescription as Any)
                print("Document does not exist")
                exist = false
            }
            
            self.isDataExist(exist,recipeList)
        }
       
    }
    
       func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
           if exist{
               savedRecipesDelegate?.reloadData(data:data)
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
                    self.delegateFollowerFollowing?.assginFollowersFollowingsImages(image: image!, index: index)
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
    
    func updateUserImage(Img: UIImage){
        let uid = Auth.auth().currentUser?.uid
        let imageRef = storageRef.child("user/\(String(describing: uid!))/userAccountImage")
        if let uploadData = Img.jpegData(compressionQuality: 0.1){
            imageRef.putData(uploadData, metadata: nil) { (metaData, err) in
                 if err != nil {
                    print(err.debugDescription)
                }
                else {
                    print(metaData)
                }
            }
        }
        
    }
}
