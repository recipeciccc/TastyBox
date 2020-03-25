//
//  UserRecipeDetail.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-03-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

struct UserRecipeDetail {
    var recipeID: String
    var title: String
    var cookingTime: Int
    var image: String
    var like: Int
    var serving: Int
    var userID:String
    var instructions: [String]
    var ingredients: [String]
    var comment: [String]
}
