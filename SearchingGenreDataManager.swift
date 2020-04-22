//
//  SearchingGenreDelegate.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol isGenreExistDelegate: class {
    func gotGenres(getGenres: [String])
}

protocol passRecipeDataDelegate: class {
    func passRecipesData(recipes: [RecipeDetail])
}

class SearchingGenreDataManager: ResultRecipesDataManager {
    
//    let db = Firestore.firestore()
    weak var isGenreExistDelegate: isGenreExistDelegate?
    weak var passRecipesDataDelegate: passRecipeDataDelegate?
    
    func getIngredients(searchingWord: String) {
    
    var arr:[String] = []
    db.collection("genres").document("genre").addSnapshotListener() {
        (querySnapshot, error) in
        if error != nil {
            print("Error getting documents: \(String(describing: error))")
        } else {
            
            let data = querySnapshot!.data()
            
            
            let arrOfData = data!["genres"] as? [String:Bool]
            
            for element in arrOfData! {
                if element.key.lowercased().contains(searchingWord.lowercased()) {
                    arr.append(element.key)
                }
            }
            
            self.isGenreExistDelegate?.gotGenres(getGenres: arr)
        }
    }
    }
     
//    func getGenres() {
//
//           var arr:[String] = []
//        db.collection("genres").document("genre").addSnapshotListener() {
//                          (querySnapshot, error) in
//                          if error != nil {
//                              print("Error getting documents: \(String(describing: error))")
//                          } else {
//
//                           let data = querySnapshot!.data()
//
//                            let arrOfData = data!["genres"] as? [String:Bool]
//                            for element in arrOfData! {
//                               arr.append(element.key)
//                           }
//                           self.childDelegate?.gotGenres(getGenres: arr)
//                   }
//               }
//
//       }
    
    
    
}
