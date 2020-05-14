//
//  savingRecipesDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-25.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol SavedRecipeDelegate: class {
    func reloadData(data: [RecipeDetail])
    func reloadImg(img: UIImage, index: Int)
    func gotUserData(user: User)
    
}

class savingRecipesDataManager {
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var savedRecipesID: [String] = []
    var user: User?
    weak var delegate: SavedRecipeDelegate?
    
    
    func saveRecipe(recipeID: String) {
        
        
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
    
   func getSavedRecipes() {
    db.collection("user").document(uid!).collection("savedRecipes").order(by: "savedTime", descending: true).addSnapshotListener {
               querySnapshot, error in
               if error != nil {
                   print("Error getting documents: \(String(describing: error))")
               } else {
                
                self.savedRecipesID.removeAll()
                   if let documents = querySnapshot?.documents {
                       for document in documents {
                           let data = document.data()
                           if let id = data["id"] as? String {
                               self.savedRecipesID.append(id)

                               if document == documents.last! {

                                self.Data(savedRecipesIDs: self.savedRecipesID)
                                    
                               }
                           }

                       }
                   }
               }
           }
       }
    
   
    func Data(savedRecipesIDs:[String]) {
        var recipeList = [RecipeDetail]()
        var exist = Bool()
        
         recipeList.removeAll()
        for (index, id) in savedRecipesIDs.enumerated() {
            db.collection("recipe").document(id).addSnapshotListener { (querySnapshot, err) in
                       if err == nil {
                        
                        if let data = querySnapshot?.data() {
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
                            
                            if index == self.savedRecipesID.count - 1  {
                                self.delegate?.reloadData(data:recipeList)
                                
                                for (index, recipe) in recipeList.enumerated() {
                                    self.getImage(uid: recipe.userID, rid: recipe.recipeID, index: index)
                                    self.getUserDetail(id: recipe.userID)
                                }
                            }
                        }
                           
                       } else {
                           print(err?.localizedDescription as Any)
                           print("Document does not exist")
                           exist = false
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
                   
                   
                       guard let userID = data["id"] as? String else { return }
                       guard let name = data["userName"] as? String else { return }
                       guard let familySize = data["familySize"] as? Int else { return }
                       guard let cuisineType = data["cuisineType"] as? String else { return }
                       guard let isVIP = data["isVIP"] as? Bool else { return }
    
                       self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                        
                    self.delegate?.gotUserData(user: self.user!)
                   }
               }
               
               
           }
       }
       
    
    func getImage(uid:String, rid: String, index: Int){
            var image = UIImage()
            let storage = Storage.storage()
            let storageRef = storage.reference()
        
                storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(rid)").getData(maxSize: 1 * 1024 * 1024) { data, error in   //
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    } else {
                        if let imgData = data{
                    
                            image = UIImage(data: imgData)!
                            
                            self.delegate?.reloadImg(img: image, index: index)
                        }
                    }
            }
           
        }
    
}
