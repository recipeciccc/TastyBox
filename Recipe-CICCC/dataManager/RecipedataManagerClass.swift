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
        
        // this cant be executed before put value to cell.textlabel
        //        db.collection("recipe").document("OfcILMhCh3LVMNhE60I7").getDocument(source: .cache) {
        //            (document, error) in
        //            if let document = document {
        //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        //                print("Cached document data: \(dataDescription)")
        //
        //                let data = document.data()
        //                 self.initRecipeDetail(data: data)
        //            } else {
        //                print("Document does not exist in cache")
        //              }
        //        }
        
        db.collection("recipe").getDocuments {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                //For-loop
                for documents in querysnapshot!.documents
                {
                    self.recipes.removeAll()
                    let document = querysnapshot!.documents
                    
                    for (index, element) in document.enumerated() {
                        print("document count：\(document.count)")
                        let data = element.data()
                        
                        print("data count: \(data.count)")
                        
                        
                        let reipeId = data["recipeID"] as? String
                        let title = data["title"] as? String
                        let cookingTime = data["cookingTime"] as? Int
                        let like = data["like"] as? Int
                        let serving = data["serving"] as? Int
                        let image = data["image"] as? String
                        let userID = data["userID"] as? String
                        
                        
                        let recipe = RecipeDetail(recipeID: reipeId!, title: title!, cookingTime: cookingTime!, image: image!, like: like!, serving: serving!, userID: userID!)
                        
                        self.recipes.append(recipe)
                    }
                }
            }
            
            self.delegate?.gotData(recipes: self.recipes)
            
        }
    }
    
    func getImage(imageString: String, imageView: UIImageView) {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        
        // Create a child reference
        // imagesRef now points to "images"
        //        let imagesRef = storageRef.child("recipeImages")
        
        // Child references can also take paths delimited by '/'
        // spaceRef now points to "images/space.jpg"
        // imagesRef still points to "images"
        let imagesRef = storageRef.child("recipeImages/\(imageString)")
        
        // This is equivalent to creating the full reference
        //        let storagePath = "\(your_firebase_storage_bucket)/images/space.jpg"
        //        spaceRef = storage.reference(forURL: storagePath)
        
        
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
