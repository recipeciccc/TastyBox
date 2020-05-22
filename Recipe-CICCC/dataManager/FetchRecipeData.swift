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
    weak var delegate : ReloadDataDelegate?
    var commentDelegate: GetCommentsDelegate?
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    var instructions : [Instruction] = []
    var comments : [Comment] = []
    var ingredients : [Ingredient] = []
    var users : [User] = []
    var user:User?
    
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
    
    // get images of users who commented and assign image to imageView
    
//    func getCommenterImages(imageView: UIImageView, users: [User]) {
//        for user in users {
//            let imageRef = storageRef.child("user/\(user.userID)/userAccountImage")
//            var image: UIImage?
//            // Fetch the download URL
//            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                if error != nil {
//                    print(error?.localizedDescription as Any)
//                } else {
//                    if let imgData = data {
//                        
//                        print("imageRef: \(imageRef)")
//                        
//                        image = UIImage(data: imgData)!
//                        self.commentDelegate?.assignImageCommentUser(imageView: imageView, image: image!)
//                    }
//                }
//            }
//        }
//    }
    
    func getComments(queryRef: Query) {
        
        
        // get comments
        queryRef.addSnapshotListener{
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
                self.commentDelegate?.gotData(comments: self.comments)
                // get users who commented
                
                for comment in self.comments {
                    self.db.collection("user").document(comment.userId).addSnapshotListener { querySnapshot, error in
                        if error != nil {
                            print("Error getting documents: \(String(describing: error))")
                        } else {
                           if let data = querySnapshot!.data() {
                            
                            print("data count: \(data.count)")
                            
                            
                            guard let userID = data["id"] as? String else { return }
                            guard let name = data["userName"] as? String else { return }
                            guard let familySize = data["familySize"] as? Int else { return }
                            guard let cuisineType = data["cuisineType"] as? String else { return }
                            guard let isVIP = data["isVIP"] as? Bool else { return }
                                                 
                            self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                            
                            self.users.append(self.user!)
                            self.commentDelegate?.getCommentUser(user: self.users, comments: self.comments)
                            
                            }
                        }
                    }
                }
                
                
                
            }
        }
        
        
        
        
        
    }
    
    func getImage(url: StorageReference) -> UIImage {
        
        var image = UIImage()
        
        url.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
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


