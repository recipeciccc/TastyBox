//
//  SearchingIngredients.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol getIngredientsDelegate: class {
    func gotIngredients(ingredients: [String])
    
}

protocol searchingResultDelegate: class {
    func reloadIngredients(recipe: [RecipeDetail])
}

class SearchingIngredientsDataManager: ResultFetchRecipeData {
    
    //    let db = Firestore.firestore()
    weak var getIngredientDelegate: getIngredientsDelegate?
    weak var searchingResultDelegate: searchingResultDelegate?
    
    //    var searchingIngredient: String?
    var searchedRecipes: [RecipeDetail] = []
    
    func getIngredients(searchingWord: String) {
        
        var arr:[String] = []
        db.collection("ingredient").document("ingredient").addSnapshotListener() {
            (querySnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                let data = querySnapshot!.data()
                
                
                let arrOfData = data!["ingredient"] as? [String:Bool]
                
                for element in arrOfData! {
                    if element.key.lowercased().contains(searchingWord.lowercased()) {
                        arr.append(element.key)
                    }
                }
                
                self.getIngredientDelegate?.gotIngredients(ingredients: arr)
            }
        }
        
    }
    
//    override func isDataExist(_ exist: Bool, _ data: [RecipeDetail]) {
//        if exist{
//            
//            searchingRecipes(recipes: data)
//            
//        }
//    }
//    
//    
//    func searchingRecipes(recipes: [RecipeDetail]) {
//        
//        var isFinished = false
//        for (index, recipe) in recipes.enumerated() {
//            db.collection("recipe").document("\(recipe.recipeID)").collection("ingredient").addSnapshotListener{
//                (querysnapshot, error) in
//                if error != nil {
//                    print("Error getting documents: \(String(describing: error))")
//                } else {
//                    for document in querysnapshot!.documents {
//                        let data = document.data()
//                        
//                        let ingredient = data["ingredient"] as! String
//                        if  self.searchingIngredient!.capitalized == ingredient.capitalized {
//                            self.searchedRecipes.append(recipe)
//                            break
//                        }
//                        
//                    }
//                    
//                }
//                
//            }
//            if index == recipes.count - 1{
//                isFinished = true
//            }
//        }
//        if isFinished {
//            self.passRecipes()
//        }
//    }
//    
//    
//    func passRecipes() {
//        searchingResultDelegate?.reloadIngredients(recipe: self.searchedRecipes)
//    }
    
}
