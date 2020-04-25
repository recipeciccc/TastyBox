//
//  ResultFetchRecipeData.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-21.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class ResultFetchRecipeData {
    
    var searchingIngredient: String?
    let db = Firestore.firestore()
    
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
        
    }
    
    func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
    }
    
    
}
