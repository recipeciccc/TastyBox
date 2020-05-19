//
//  recipeStruct.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct RecipeDetail {
    var recipeID: String
    var title: String
    var updatedDate: Timestamp
    var cookingTime: Int
    var image: String?
    var like: Int
    var serving: Int
    var userID:String
    var genres: [String] = []
    var isVIPRecipe: Bool?
}

struct Ingredient {
    var name: String
    var amount: String
}

struct Instruction {
    var index: Int
    var imageUrl: String  
    var text: String
}

struct Comment {
    var userId: String
    var text: String
    var time: Timestamp
}


