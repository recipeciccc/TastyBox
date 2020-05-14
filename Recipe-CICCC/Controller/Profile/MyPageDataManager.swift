//
//  MyPageDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-25.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol MyPageDataManagerDelegate: class {
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String])
    func gotUserData(user: User)
    func reloadData(data:[RecipeDetail])
    func reloadImg(images: [UIImage])
    func assignUserImage(image: UIImage)
    func passSaveingRecipesNumber(number: Int)
}

class MyPageDataManager {
    
    let db = Firestore.firestore()
    var followingsIDs:[String] = []
    var followersIDs:[String] = []
    var savedRecipesIDs:[String] = []
    var user: User?
    let uid = (Auth.auth().currentUser?.uid)!
    weak var delegate: MyPageDataManagerDelegate?
    
    func findFollowerFollowing(id: String?) {
        var uid = (Auth.auth().currentUser?.uid)!
        followingsIDs.removeAll()
        followersIDs.removeAll()
        
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
                            
                            self.delegate?.passFollowerFollowing(followingsIDs: self.followingsIDs, followersIDs: self.followersIDs)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func getSavedRecipes() {
        savedRecipesIDs.removeAll()
              db.collection("user").document(uid).collection("savedRecipes").order(by: "savedTime", descending: true).addSnapshotListener {
                  querySnapshot, error in
                  if error != nil {
                      print("Error getting documents: \(String(describing: error))")
                  } else {
                      if let documents = querySnapshot?.documents {
                          for document in documents {
                              let data = document.data()
                              if let id = data["id"] as? String {
                                  self.savedRecipesIDs.append(id)

                                  if document == documents.last! {
                                    self.delegate?.passSaveingRecipesNumber(number: self.savedRecipesIDs.count)
      //                                self.Data(recipeID: self.savedRecipesID)
                                  }
                              }

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
    
    func Data(queryRef:Query) -> [RecipeDetail]{
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
                        
                    }
                }
                exist = true
            } else {
                print(err?.localizedDescription as Any)
                print("Document does not exist")
                exist = false
            }
            
            self.isDataExist(exist,recipeList)
        }
        return recipeList
    }
    
    func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
           if exist{
               delegate?.reloadData(data:data)
           }
       }
       
    func getUserImage(uid: String) {
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
                    self.delegate?.assignUserImage(image: image!)
                }
            }
        }
    }
    
    func getImage( uid:String?, rid: [String]){
            var image = UIImage()
            let storage = Storage.storage()
            let storageRef = storage.reference()
            var imageList: [UIImage] = []
            var imageRefs: [StorageReference] = []
            
            
            guard let uid = uid else {
                return
            }
            
            for index in 0..<rid.count{
                       
                print("\(index): \(rid[index])")
            let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid[index])/\(rid[index])")
                imageRefs.append(imagesRef)
            }
            
    //        print(imageRefs)
            imageList = Array(repeating: UIImage(), count: imageRefs.count)
            
            for (index, imageRef) in imageRefs.enumerated() {
                
               
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    } else {
                        if let imgData = data{
                            
                            print("imageRef: \(imageRef)")
                            
                            image = UIImage(data: imgData)!
    //                        print(index)
                            imageList.remove(at: index)
                            imageList.insert(image, at: index)
                            
                            self.delegate?.reloadImg(images: imageList)
                        }
                    }
            }
            
            }
           
        }
}
