//
//  RecipeViewControllerDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-19.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class RecipeViewControllerDataManager {
    
    let db = Firestore.firestore()
    weak var delegate: RecipeViewControllerDelegate?
    
    var user: User?
    var creators:[User] = []
    
    func Data(queryRef:Query) {
        var recipeList = [RecipeDetail]()
        var exist = Bool()
        
        
        queryRef.addSnapshotListener { (snapshot, err) in
            if err == nil {
                if let snap = snapshot?.documents {
                    for document in snap{
                        let data = document.data()
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
                        
                        if let gotGenresData = genresData {
                            for genre in gotGenresData {
                                genresArr.append(genre.key)
                            }
                        }
                         let isVIPRecipe = data["VIP"] as? Bool ?? false
                                                                                              
                        let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr, isVIPRecipe: isVIPRecipe)
                        recipeList.append(recipe)
                        
                    }
                }
                exist = true
            } else {
                print(err?.localizedDescription as Any)
                print("Document does not exist")
                exist = false
            }
            
            self.isRecipeExist(exist,recipeList)
        }
        
    }
    
    func isRecipeExist(_ exist:Bool, _ data: [RecipeDetail]){
//        if exist{
            
            delegate?.reloadRecipe(data:data)
//        }
    }
    
    
    func getImage( uid:String?, rid: String, index: Int){
        
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        guard let uid = uid else {
            return
        }
        
        
        let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
        
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data{
                    
                    print("imagesRef: \(imagesRef)")
                    
                    image = UIImage(data: imgData)!
                    
                    self.delegate?.reloadImg(image: image, index: index)
                }
            }
            
        }
        
    }
    
    func getUserDetail(id: String?, isLast: Bool) {
        
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
                    
                    
                    guard let userID = data["id"] as? String else { return }
                    guard let name = data["userName"] as? String else { return }
                    guard let familySize = data["familySize"] as? Int else { return }
                    guard let cuisineType = data["cuisineType"] as? String else { return }
                    guard let isVIP = data["isVIP"] as? Bool else { return }
                                       
                    self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                    self.creators.append(self.user!)
                    
                    if isLast {
                        self.delegate?.gotUserData(users: self.creators)
                    }
                    
                }
            }
            
        }
    }
}

protocol RecipeViewControllerDelegate: class {
    func reloadRecipe(data:[RecipeDetail])
    //    func reloadGenres(data: [String], recipeID: String)
    func reloadImg(image: UIImage, index: Int)
    func gotUserData(users: [User])
}
