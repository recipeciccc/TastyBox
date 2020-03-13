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
    
    func Data(queryRef:Query) -> [RecipeDetail]{
        var recipeList = [RecipeDetail]()
        var exist = Bool()
        queryRef.getDocuments { (snapshot, err) in
            if err == nil {
                if let snap = snapshot?.documents{
                    for document in snap{
                        let data = document.data()
                        let reipeId = data["recipeID"] as? String
                        let title = data["title"] as? String
                        let cookingTime = data["cookingTime"] as? Int
                        let like = data["like"] as? Int
                        let serving = data["serving"] as? Int
                        let image = data["image"] as? String
                        let userID = data["userID"] as? String
                        let time = data["time"] as? Timestamp
                        let instructions = data["instruction"] as? [Instruction]
                        let ingredients = data["ingredient"] as? [Ingredient]
                        let comments = data["comment"] as? [Comment]
 
//                        let recipe = RecipeDetail(recipeID: reipeId!, title: title!, instructions: instructions!, cookingTime: cookingTime!, image: image!, like: like!, serving: serving!, userID: userID!, ingredients: ingredients!, comment: comments!)
                        
                        let recipe = RecipeDetail(recipeID: reipeId!, title: title!, cookingTime: cookingTime!, image: image!, like: like!, serving: serving!, userID: userID!)
                        
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
    
    func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
        if exist{
            delegate?.reloadData(data:data)
        }
    }
    
    
}


