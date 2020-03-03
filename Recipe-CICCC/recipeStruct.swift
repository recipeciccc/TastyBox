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
    var id: String
    var title: String
//        var explaination: String
    var cookingTime: Int
//     var image: UIImage
    var like: Int
    var serving: Int
//    var ingredient: Ingredient
//        var instruciton: Instruction
//     var comment: Comment
    
//    init(snapshot:QueryDocumentSnapshot) {
//        guard
//            let docId = snapshot.documentID,
//            let title = snapshot.get("title") as! String,
//            let cookingTime = snapshot.get("Cooking Time") as! Int,
//    //                    let image = document.get("image") as! String
//            let like = snapshot.get("like") as! Int,
//            let serving = snapshot.get("serving") as! Int
//        else { return }
//        
//        self.id = "ID"
//    }
    
    
}

struct Ingredient {
    var name: String
    var amount: String
}

struct Instruction {
    var image:UIImage
    var text: String
}

struct Comment {
    var user: User
    var text: String
}

struct User {
    var name: String
}
