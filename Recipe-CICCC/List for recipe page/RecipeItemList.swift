//
//  RecipeItemList.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-18.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import Foundation

class RecipeItemList {
    var recipeItemList = [RecipeItem]()

    init() {
        let row0Item = RecipeItem()
        let row1Item = RecipeItem()
        let row2Item = RecipeItem()
        
        row0Item.recipeName = "english maffun"
        row0Item.recipeExplanation = "Brussels sprouts are one of the most underrated vegetables. These cruciferous green gems are good for you and, when cooked correctly, so darn delicious. Still not sure? We’ve rounded up a few recipes that prove it!"
        row0Item.numOfLike = 5
        row0Item.creator = "Lay FangYi"
        row0Item.numOfFollower = 10
        row0Item.ingredients = IngredientsList()
        row0Item.HowToCookList = howToCookList()
        
        row1Item.recipeName = "Creamy Sun-Dried Tomato and Spinach Penne"
        row0Item.recipeExplanation = "If it ain't broke, don't fix it. That’s what we have to say about the tried-and-true combination of spinach and sun-dried tomatoes, which is then folded into a creamy sauce with stringy and cheesy mozzarella. This bowl of pasta brings flavour, warmth and a touch of summer to your dinner table!"
        row1Item.numOfLike = 100
        row1Item.creator = "Lay FangYi"
        row1Item.numOfFollower = 10
        row1Item.ingredients = IngredientsList()
        row1Item.HowToCookList = howToCookList()
        
        row2Item.recipeName = "Gnocchi in Tomato Sauce"
        row2Item.recipeExplanation = "Gnocchi are little pillowy potato dumplings that are delicious when doused with sauce. But we're jazzing up this recipe by taking gnocchi a step further – pan-frying them until they're crispy and golden-brown really turns this dish into something special."
        row2Item.numOfLike = 50
        row2Item.creator = "Lay FangYi"
        row2Item.numOfFollower = 10
        row2Item.ingredients = IngredientsList()
        row2Item.HowToCookList = howToCookList()
        
        recipeItemList.append(row0Item)
        recipeItemList.append(row1Item)
        recipeItemList.append(row2Item)
    }
}
