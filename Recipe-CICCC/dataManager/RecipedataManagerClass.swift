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

class RecipedataManagerClass {
    
    let db = Firestore.firestore()
    var delegate: getDataFromFirebaseDelegate?
    
    var recipes:[RecipeDetail] = []
    
    func getReipeDetail() {
        
        
        db.collection("recipe").addSnapshotListener {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                self.recipes.removeAll()
                
                //For-loop
                for documents in querysnapshot!.documents
                {
                    
                    let data = documents.data()
                    
                    print("data count: \(data.count)")
                    
                    let reipeId = data["recipeID"] as? String
                    
                    let title = data["title"] as? String
                    let cookingTime = data["cookingTime"] as? Int
                    let like = data["like"] as? Int
                    let serving = data["serving"] as? Int
                    let image = data["image"] as? String
                    let userID = data["userID"] as? String
//                     let instructions = data["instruction"] as? [Instruction]
//                     let ingredients = data["ingredient"] as? [Ingredient]
//                     let comments = data["comment"] as? [Comment]
                    
                    
//                    let recipe = RecipeDetail(recipeID: reipeId!, title: title!, instructions: instructions!, cookingTime: cookingTime!, image: image!, like: like!, serving: serving!, userID: userID!, ingredients: ingredients!, comment: comments!)
                    
                    let recipe = RecipeDetail(recipeID: reipeId!, title: title!, cookingTime: cookingTime!, image: image!, like: like!, serving: serving!, userID: userID!)
                    
                    self.recipes.append(recipe)
                }
                self.delegate?.gotData(recipes: self.recipes)
            }
        }
    }
    
    func getImage(imageString: String, imageView: UIImageView) {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
    
        let imagesRef = storageRef.child("recipeImages/\(imageString)")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)!
                self.delegate?.assignImage(image: image, reference: imageView)
            }
        }
    }
}
