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
    func reloadRecipes(data:[RecipeDetail])
    func reloadImages(data: [Int: UIImage])
}

class VIPDataManager {
    
    let db = Firestore.firestore()
    var followingsIDs:[String] = []
    var VIPRecipesIDs: [String] = []
    var recipeList:[RecipeDetail] = []
    var recipeImages: [Int: UIImage] = [:]
    weak var delegate: VIPDataManagerDelegate?
    
    func findFollowing(id: String?) {
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
                        if let gotVIPRecipesIDs = data["VIP"] as? [String: Bool] {
                            
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
                        
                        
                        
                        let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr)
                        
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
                        if index == self.recipeList.count - 1 {
                            self.delegate?.reloadImages(data: self.recipeImages)
                        }
                    }
                }
            }
        
        }
        
        
      
        
        
    }
}


