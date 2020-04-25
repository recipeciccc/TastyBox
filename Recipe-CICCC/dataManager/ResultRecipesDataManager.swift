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
    func passRecipesData(recipes: [RecipeDetail])
}

class ResultRecipesDataManager {
    
    weak var delegate: ResultRecipesDataManagerDelegate?
    let db = Firestore.firestore()
    var searchingIngredient = ""
    var searchedRecipes:[RecipeDetail] = []
     var genreOrNot = Bool()
    
    func getAllRecipes(searchingWord: String) {
        genreOrNot = false
           self.searchingIngredient = searchingWord
           let query = db.collection("recipe").order(by: "like", descending: true)
           Data(queryRef: query)
       }
    
    
    func searchingGenreRecipe(searchingWord word: String) {
        
        genreOrNot = true
        let query = db.collection("recipe").whereField("genres.\(word)", isEqualTo: true)
          
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
                           
                           
                           
                         let isVIPRecipe = data["VIP"] as? Bool ?? false
                                                                                              
                        let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr, isVIPRecipe: isVIPRecipe)
                        
                           
                           recipeList.append(recipe)
                           
                       }
                    exist = true
                    
                    if self.genreOrNot {
                        self.isSearchingGenreDataExist(exist, recipeList)
                    } else {
                        self.isIngredientData(exist,recipeList)
                    }
                   }
                   
               } else {
                   print(err?.localizedDescription as Any)
                   print("Document does not exist")
                   exist = false
               }
               
           }
           
       }

       func isIngredientData(_ exist:Bool, _ data: [RecipeDetail]){
           if exist{

               searchingIngredientRecipes(recipes: data)

           }
       }
    
    func isSearchingGenreDataExist(_ exist: Bool, _ data: [RecipeDetail]) {
           
           if exist {
               delegate?.passRecipesData(recipes: data)
               
               for (index, recipe) in data.enumerated() {
                   getImage(uid: recipe.userID, rid: recipe.recipeID, index: index)
               }
           }
           
       }


       func searchingIngredientRecipes(recipes: [RecipeDetail]) {

//           var isFinished = false
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
//                               isFinished = true
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
        
        guard let uid = uid else {
            return
        }
        
        
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
