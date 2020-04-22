//
//  ResultRecipesDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-21.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol ResultRecipesDataManagerDelegate: class {
    func reloadImg(img: UIImage, index: Int)
    func reloadIngredients(recipes: [RecipeDetail])
}

class ResultRecipesDataManager {
    
    weak var delegate: ResultRecipesDataManagerDelegate?
    let db = Firestore.firestore()
    var searchingIngredient = ""
    var searchedRecipes:[RecipeDetail] = []
    
    func getAllRecipes(searchingWord: String) {
           self.searchingIngredient = searchingWord
           let query = db.collection("recipe").order(by: "like", descending: true)
           Data(queryRef: query)
       }
       
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
                           
                           if let gotData = genresData {
                               for genre in gotData {
                                   genresArr.append(genre.key)
                               }
                           }
                           
                           
                           
                           let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr)
                           
                           recipeList.append(recipe)
                           
                       }
                    exist = true
                     self.isDataExist(exist,recipeList)
                   }
                   
               } else {
                   print(err?.localizedDescription as Any)
                   print("Document does not exist")
                   exist = false
               }
               
//               self.isDataExist(exist,recipeList)
           }
           
       }
       
       func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
           if exist{
               
               searchingRecipes(recipes: data)
               
           }
       }
       
       
       func searchingRecipes(recipes: [RecipeDetail]) {
           
           var isFinished = false
           for (index, recipe) in recipes.enumerated() {
               db.collection("recipe").document("\(recipe.recipeID)").collection("ingredient").addSnapshotListener{
                   (querysnapshot, error) in
                   if error != nil {
                       print("Error getting documents: \(String(describing: error))")
                   } else {
                       
                    for document in querysnapshot!.documents {
                           let data = document.data()
                           
                           let ingredient = data["ingredient"] as! String
                        if  self.searchingIngredient.capitalized == ingredient.capitalized {
                               self.searchedRecipes.append(recipe)
                               break
                           }
                           if index == recipes.count - 1{
                               isFinished = true
                            self.passRecipes()
                           }
                       }
                    
                    
                    
                   }
                   
               }
               
           }
          
       }
       
       
       func passRecipes() {
        delegate?.reloadIngredients(recipes: self.searchedRecipes)
       }
    
    func getImage(uid:String?, rid: String, index: Int){
        var image = UIImage()
       
        let storageRef = Storage.storage().reference()
        //            var imageList: [UIImage] = []
        //            var imageRefs: [StorageReference] = []
        
        
        guard let uid = uid else {
            return
        }
        
        //            for index in 0..<rid.count{
        
        //                print("\(index): \(rid[index])")
        //            let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid[index])/\(rid[index])")
        //                imageRefs.append(imagesRef)
        //            }
        
        //        print(imageRefs)
        //            imageList = Array(repeating: UIImage(), count: imageRefs.count)
        
        //            for (index, imageRef) in imageRefs.enumerated() {
        
        let imageRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
        print(imageRef)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data{
                    
                    print("imageRef: \(imageRef)")
                    
                    image = UIImage(data: imgData)!
                    //                        print(index)
                    //                            imageList.remove(at: index)
                    //                            imageList.insert(image, at: index)
                    self.delegate?.reloadImg(img: image, index: index)
                    //                            self.delegate?.reloadImg(img: imageList)
                }
            }
            //            }
            
        }
        
    }
    
}
