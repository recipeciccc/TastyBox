//
//  FetchData_recipe.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-03-07.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FetchRecipeData{
    var delegate : ReloadDataDelegate?
    let db = Firestore.firestore()
    
    var instructions : [Instruction] = []
    var comments : [Comment] = []
    var ingredients : [Ingredient] = []
    
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
                        
                        
                        let image = self.getImage(uid: userId!, rid: recipeId!)
                        
                        self.getInstructions(userId: userId!, recipeId: recipeId!)
                        self.getIngredients(userId: userId!, recipeId: recipeId!)
                        self.getComments(userId: userId!, recipeId: recipeId!)
                        
                        let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image, like: like!, serving: serving ?? 0, userID: userId!, instructions: self.instructions, ingredients: self.ingredients, comment: self.comments)

                        recipeList.append(recipe)
                        print(time?.dateValue())
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

    
    func getInstructions(userId: String, recipeId: String) {
        db.collection("recipe").document(recipeId).collection("instruction").addSnapshotListener{
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                for document in querysnapshot!.documents {
                    let data = document.data()
                    
                    let index = data["index"] as! Int
                    let image = data["image"] as! String
                    let text = data["text"] as! String
                    
                    self.instructions.append(Instruction(index: index, imageUrl: image, text: text))
                    
                }
            }
        }
    }
    
    
    
    func getImageInstruction(userId: String, rid: String, index: Int) -> UIImage {
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
                for document in querysnapshot!.documents {
                    let data = document.data()
                    
                    let ingredient = data["ingredient"] as! String
                    let amount = data["amount"] as! String
                    
                    self.ingredients.append(Ingredient(name: ingredient, amount: amount))
                    
                }
            }
        }
    }
    
    func getComments(userId: String, recipeId: String) {
        
        db.collection("recipe").document("\(recipeId)").collection("comment").addSnapshotListener{
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                for document in querysnapshot!.documents {
                    let data = document.data()
                    
                    let text = data["text"] as! String
                    let user = data["user"] as! String
                    let time = data["time"] as! Timestamp
                  
                    
                    self.comments.append(Comment(userId: user, text: text, time: time))
                    
                }
            }
        }
    }
    
    func getImage( uid:String, rid: String) -> UIImage {
        
        var image = UIImage()
        
        let storageRef = Storage.storage().reference().child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data{
                    image = UIImage(data: imgData)!
                }
            }
        }
        
        return image
        
        
    }
    
    func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
        if exist{
            delegate?.reloadData(data:data)
        }
    }
    
    
    
    
}


