//
//  SearchingIngredients.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol SearchingIngredientsDelegate: class {
    func gotIngredients(ingredients: [String])
    //    func reloadData(data: [RecipeDetail])
    func reloadIngredients(recipe: RecipeDetail)
}

class SearchingIngredientsDataManager: fetchRecipes {
    
    let db = Firestore.firestore()
    weak var delegateChild: SearchingIngredientsDelegate?
    
    
    func getIngredients() {
        
        var arr:[String] = []
        db.collection("ingredient").document("ingredient").addSnapshotListener() {
            (querySnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                let data = querySnapshot!.data()
                
                
                let arrOfData = data!["ingredient"] as? [String:Bool]
                
                for element in arrOfData! {
                    arr.append(element.key)
                }
                
                self.delegateChild?.gotIngredients(ingredients: arr)
            }
        }
        
    }
    
    func getAllRecipes() {
        let query = db.collection("recipe").order(by: "like", descending: true)
        Data(queryRef: query)
    }
    
    func getAllIngredients(recipe: RecipeDetail, searchingWord: String) {
        
        var ingredients:[Ingredient] = []
        var exist = false
        
        db.collection("recipe").document("\(recipe.recipeID)").collection("ingredient").addSnapshotListener{
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                for document in querysnapshot!.documents {
                    let data = document.data()
                    
                    let ingredient = data["ingredient"] as! String
                    let amount = data["amount"] as! String
                    
                    ingredients.append(Ingredient(name: ingredient, amount: amount))
                    
                }
                exist = true
                self.isSearchingIngredientExist(exist, ingredients, recipe, searchingWord: searchingWord)
            }
            
            self.isSearchingIngredientExist(exist, ingredients, recipe, searchingWord: searchingWord)
            
        }
    }
    
    func isSearchingIngredientExist(_ exist:Bool, _ data: [Ingredient], _ recipe: RecipeDetail, searchingWord: String){
        
        if exist{
            for ingredient in data {
                if  searchingWord.capitalized == ingredient.name.capitalized {
                    delegateChild?.reloadIngredients(recipe: recipe)
                    break
                }
            }
            
        }
    }
    
    //    func getSearchedRecipes(recpes:[RecipeDetail]) {
    //        <#function body#>
    //    }
}
