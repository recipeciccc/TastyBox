//
//  ingredientsList.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-29.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import Foundation

class IngredientsList {
    var ingredientsList = [IngredientsTableViewCell]()
    
    init() {
        let row0Item = IngredientsTableViewCell()
        let row1Item = IngredientsTableViewCell()
        let row2Item = IngredientsTableViewCell()
        
        row0Item.ingredientName = "eggplant"
        row1Item.ingredientName = "egg"
        row2Item.ingredientName = "Raddish"
        
        row0Item.amountIngredient = "2"
        row1Item.amountIngredient = "4"
        row2Item.amountIngredient = "199"
        
        ingredientsList.append(row0Item)
        ingredientsList.append(row1Item)
        ingredientsList.append(row2Item)
    }
    
//    func newToDo() -> recipeListCreatorItemTableViewCell {
//        let item = recipeListCreatorItemTableViewCell()
//        item.textTest = "11: 30 PM"
//        creatorRecipeLists.append(item)
//        return item
//    }
//
    
}
