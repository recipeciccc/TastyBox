//
//  FollowingRecipeDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-18.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class FollowingRecipeDataManager {
      
    weak var delegate: FollowingRecipeDataManagerDelegate?
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    var user: User?
    var followings: [User] = []
    
    var followingsIDs:[String] = []
    
    
    
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
                self.followingsIDs.removeAll()
                   for document in querysnapshot!.documents {
                       let data = document.data()
                       self.followingsIDs.append(data["id"] as! String)
                   }
                self.delegate?.passFollowing(followingsIDs: self.followingsIDs)
                self.getUserImage(IDs: self.followingsIDs)
                }
               }
           }
       
    
    func Data(queryRef:Query, index: Int) {
        var recipeList = [RecipeDetail]()
        var exist = Bool()
        queryRef.getDocuments { (snapshot, err) in
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
                        let genres = data["genres"] as? [String:Bool]
                        
                        var genresArr: [String] = []
                        if let gotGenresData = genres {
                            for genre in gotGenresData {
                                genresArr.append(genre.key)
                            }
                        }
                        
                        
                        let image = data["image"] as? String
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
            
            self.isDataExist(exist,recipeList, index: index)
        }
       
    }
    
    func isDataExist(_ exist:Bool, _ data: [RecipeDetail], index: Int){
          if exist{
            delegate?.reloadData(data:data, index: index)
          }
      }
    
    func getFollowings(IDs: [String]) {
          
          for ID in IDs {
              
              db.collection("user").document(ID).addSnapshotListener {
                  (querysnapshot, error) in
                  if error != nil {
                      print("Error getting documents: \(String(describing: error))")
                  } else {
                      
                    guard let data = querysnapshot?.data() else { return }
                      
                      print("data count: \(data.count)")
                      
                      
                      guard let userID = data["id"] as? String else { return }
                      guard let name = data["userName"] as? String else { return }
                      guard let familySize = data["familySize"] as? Int else { return }
                      guard let cuisineType = data["cuisineType"] as? String else { return }
                      
                      
                      self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize)
                      
                    
                    self.followings.append(self.user!)
                    self.delegate?.assignFollowings(users: self.followings)
                    
                  }
                  
              }
              
          }
      }
    
        func getUserImage(IDs: [String]) {
        
            for (index, id) in IDs.enumerated() {
                let imageRef = storageRef.child("user/\(id)/userAccountImage")
                var image: UIImage?
                // Fetch the download URL
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    } else {
                        if let imgData = data {
                            
                            print("imageRef: \(imageRef)")
                            
                            image = UIImage(data: imgData)!
                            self.delegate?.assignUserImage(image: image!, index: index)
                        }
                    }
                }
            }
           
       }
   

    func getImageOfRecipesFollowing(uid: String, rid: String, indexOfImage: Int, orderFollowing: Int) {
        
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imageRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
        
        
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                image = UIImage(data: data!)!
                self.delegate?.appendRecipeImage(imgs: image, indexOfImage: indexOfImage, orderFollowing: orderFollowing)
            }
            
        }
        
        
        
    }
      
}

protocol FollowingRecipeDataManagerDelegate: class {
    func reloadData(data:[RecipeDetail], index: Int)
    func passFollowing(followingsIDs: [String])
    func assignUserImage(image: UIImage, index: Int)
    func appendRecipeImage(imgs: UIImage, indexOfImage: Int, orderFollowing: Int)
    func assignFollowings(users: [User])
}
