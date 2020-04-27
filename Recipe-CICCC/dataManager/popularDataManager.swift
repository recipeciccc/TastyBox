//
//  dataManagerClass.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-03.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class popularDataManager {
    
    let db = Firestore.firestore()
    weak var delegate: getDataFromFirebaseDelegate?
    
    var recipes:[RecipeDetail] = []
    var instructions : [Instruction] = []
    var comments : [Comment] = []
    var ingredients : [Ingredient] = []
    var images:[UIImage] = []
    
    func getReipeDetail() {
        
        db.collection("recipe").order(by: "like", descending: true).limit(to: 10).addSnapshotListener {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                self.recipes.removeAll()
                
                if let documents = querysnapshot?.documents {
                    //For-loop
                    for documents in querysnapshot!.documents
                    {
                        
                        let data = documents.data()
                        
                        
                        let recipeId = data["recipeID"] as? String
                        let title = data["title"] as? String
                        let cookingTime = data["cookingTime"] as? Int
                        let like = data["like"] as? Int
                        let serving = data["serving"] as? Int
                        let userId = data["userID"] as? String
                        let time = data["time"] as? Timestamp
                        let isVIPRecipe = data["VIP"] as? Bool ?? false

                        let image = data["image"] as? String
                        
                        let genres = data["genres"] as? [String:Bool]
                        
                        var genresArr: [String] = []
                        if let gotGenresData = genres {
                            for genre in gotGenresData {
                                genresArr.append(genre.key)
                            }
                        }
                   
                        
                        //MARK: They dont get anything when recipe is append...
                        if userId != nil && recipeId != nil {
                            
                                                                                                                                               
                            let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr, isVIPRecipe: isVIPRecipe)
                                                  
                            
                            self.recipes.append(recipe)
                            
                            if documents == querysnapshot?.documents.last! {
                                self.delegate?.gotData(recipes: self.recipes)
                            }
                        }
                    }
                }
                
                
                
            }
        }
    }
    
    func getInstructions(userId: String, recipeId: String) {
        db.collection("recipe").document(recipeId).collection("instruction").addSnapshotListener{
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                if let documents = querysnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        
                        let index = data["index"] as! Int
                        //                    let image = self.getImageInstruction(userId: userId, rid: recipeId, index: index)
                        let image = data["image"] as! String
                        let text = data["text"] as! String
                        
                        self.instructions.append(Instruction(index: index, imageUrl: image, text: text))
                        
                    }
                }
            }
        }
    }
    
    
    
    func getImageInstruction(userId: String, rid: String, index: Int) -> UIImage? {
        let storageRef = Storage.storage().reference().child("user/\(userId)/RecipePhoto/\(rid)/\(index)")
        var image = UIImage()
        
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                
                image = UIImage(data: data!)!
            }
        }
        
        return image
    }
    
    func getIngredients(userId: String, recipeId: String) {
        db.collection("recipe").document("\(recipeId)").collection("ingredient").addSnapshotListener{
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                if let documents = querysnapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        
                        let ingredient = data["ingredient"] as! String
                        let amount = data["amount"] as! String
                        
                        self.ingredients.append(Ingredient(name: ingredient, amount: amount))
                        
                    }
                }
                
            }
        }
    }
    
    func getComments(userId: String, recipeId: String) {
        print("recipeId in getComments:  \(recipeId)")
        db.collection("recipe").document(recipeId).collection("comment").addSnapshotListener {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                if let documents = querysnapshot?.documents {
                    
                    for document in documents {
                        print("documentID : \(document.documentID)")
                        let data = document.data()
                        
                        let time = data["time"] as! Timestamp
                        let user = data["user"] as! String
                        let text = data["text"] as! String
                        
                        self.comments.append(Comment(userId: user, text: text, time: time))
                        
                    }
                }
            }
        }
    }
    
    
    
    func getImage(rid: String, uid: String, index: Int) {
        
        //        let uid =  Auth.auth().currentUser?.uid
        //        let storageRef =  Storage.storage().reference().child("user/\(uid!)/RecipePhoto/\(rid)/\(rid)")
        let storageRef =  Storage.storage().reference().child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
            
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    
                    self.delegate?.assignImage(image: image!, index: index)
                }
            }
        }
    }
}
