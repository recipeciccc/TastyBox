//
//  VIPDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-23.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol VIPDataManagerDelegate: class {
    //    func passFollowing(followingsIDs: [String])
    func isVIP(isVIP: Bool, isMessageWillShow: Bool)
    func reloadRecipes(data:[RecipeDetail])
    func reloadImages(data: [Int: UIImage])
    func reloadCreators(data: [User])
}

class VIPDataManager {
    
    let db = Firestore.firestore()
    var followingsIDs:[String] = []
    var VIPRecipesIDs: [String] = []
    var recipeList:[RecipeDetail] = []
    var recipeImages: [Int: UIImage] = [:]
    var user: User?
    var users:[User] = []
    let uid = (Auth.auth().currentUser?.uid)!
    weak var delegate: VIPDataManagerDelegate?
    
    
    func isVIP() {
        db.collection("user").document(uid).addSnapshotListener {
            (querysnapshot, error) in
            
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                if let data = querysnapshot?.data() {
                    if let isVIP = data["isVIP"] as? Bool {
                        
                        guard let isMessageWillShow = data["isMessageWillShow"] as? Bool else {
                            self.delegate?.isVIP(isVIP: isVIP, isMessageWillShow: false)
                            return
                        }
                        self.delegate?.isVIP(isVIP: isVIP, isMessageWillShow: isMessageWillShow)
                    }
                    
                }
                
            }
        }
    }
    
    
    func nolongerShowMessage() {
        db.collection("user").document(uid).setData([
            "isMessageWillShow" : true
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    func findFollowing() {
        
        db.collection("user").document(uid).collection("following").addSnapshotListener {
            (querysnapshot, error) in
            
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                for document in querysnapshot!.documents {
                    let data = document.data()
                    self.followingsIDs.append(data["id"] as! String)
                }
                //                self.childDelegate?.passFollowing(followingsIDs: self.followingsIDs)
                self.VIPGetRecipes()
            }
        }
    }
    
    
    
    func VIPGetRecipes() {
        for followingID in self.followingsIDs {
            db.collection("user").document(followingID).addSnapshotListener {  (querysnapshot, error) in
                if error != nil {
                    print("Error getting documents: \(String(describing: error))")
                } else {
                    
                    
                    if let data = querysnapshot!.data() {
                        if let gotVIPRecipesIDs = data["VIPRecipes"] as? [String: Bool] {
                            
                            for id in gotVIPRecipesIDs {
                                self.VIPRecipesIDs.append(id.key)
                            }
                            
                            self.Data()
                        }
                    }
                    
                    
                    
                    
                }
                
            }
        }
    }
    
    func Data() {
        //        var recipeList = [RecipeDetail]()
        var exist = Bool()
        
        for recipeID in self.VIPRecipesIDs {
            db.collection("recipe").document(recipeID).addSnapshotListener { (snapshot, err) in
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
                        
                        self.recipeList.append(recipe)
                        
                        exist = true
                        
                        if recipeId == self.VIPRecipesIDs.last! {
                            self.isDataExist(exist)
                        }
                    } else {
                        print(err?.localizedDescription as Any)
                        print("Document does not exist")
                        exist = false
                    }
                    
                    //                    self.isDataExist(exist)
                }
                
            }
            
        }
    }
    
    
    func isDataExist(_ exist:Bool){
        if exist{
            delegate?.reloadRecipes(data:self.recipeList)
            getImage()
            getUserDetail()
        }
    }
    
    func getUserDetail() {
        
        for (index, recipe) in self.recipeList.enumerated() {
            
            db.collection("user").document(recipe.userID).addSnapshotListener {
                (querysnapshot, error) in
                if error != nil {
                    print("Error getting documents: \(String(describing: error))")
                }
                else {
                    
                    if let data = querysnapshot!.data() {
                        
                        print("data count: \(data.count)")
                        
                        
                        guard let userID = data["id"] as? String else { return }
                        guard let name = data["userName"] as? String else { return }
                        guard let familySize = data["familySize"] as? Int else { return }
                        guard let cuisineType = data["cuisineType"] as? String else { return }
                        guard let isVIP = data["isVIP"] as? Bool else { return }
                        
                        self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                        self.users.append(self.user!)
                        if index == self.recipeList.count - 1 {
                            self.delegate?.reloadCreators(data: self.users)
                        }
                        
                    }
                }
                
                
            }
        }
        
    }
    
    
    func getImage() {
        
        for (index, recipe) in recipeList.enumerated() {
            var image = UIImage()
            
            Storage.storage().reference().child("user/\(recipe.userID)/RecipePhoto/\(recipe.recipeID)/\(recipe.recipeID)").getData(maxSize: 1 * 1024 * 1024) { data, error in   //
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    if let imgData = data{
                        image = UIImage(data: imgData)!
                        self.recipeImages[index] = image
                        if self.recipeList.count == self.recipeImages.count {
                            self.delegate?.reloadImages(data: self.recipeImages)
                        }
                    }
                }
            }
            
        }
        
        
        
        
        
    }
}


