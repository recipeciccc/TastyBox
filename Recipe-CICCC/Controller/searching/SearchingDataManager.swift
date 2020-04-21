//
//  SearchingCreatorsDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol SearchingCreatorsDataManagerDelegate: class {
    func gotGenres(getGenres: [String])
    func gotIngredients(ingredients: [String])
    func searchedUsers(users: [User])
    func reloadData(data:[RecipeDetail])
}

class SearchingDataManager: fetchRecipes {
    
    let db = Firestore.firestore()
   
    weak var delegateChild: SearchingCreatorsDataManagerDelegate?
    
    func createQuery(searchWord word: String, selectedIndex index: Int) {
        
        let query = db.collection("user").whereField("name", isGreaterThanOrEqualTo: word)
            
        getSearchedCreator(query: query)
            
        Data(queryRef: query)
    }
    
    func getSearchedCreator(query: Query) {
        
        query.addSnapshotListener {
            (querySnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                var users: [User] = []
                var user: User?
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    let userID = data["id"] as? String
                    let name = data["userName"] as? String
                    let familySize = data["familySize"] as? Int
                    let cuisineType = data["cuisineType"] as? String
                    
                    
                    user = User(userID: userID!, name: name!, cuisineType: cuisineType!, familySize: familySize!)
                    users.append(user!)
                }
                
                self.delegateChild?.searchedUsers(users: users)
            }
            
        }
    }
    
//    func Data(queryRef:Query) {
//        var recipeList = [RecipeDetail]()
//        var exist = Bool()
//        queryRef.getDocuments { (snapshot, err) in
//            if err == nil {
//                if let snap = snapshot?.documents {
//                    for document in snap{
//
//                        let data = document.data()
//                        let recipeId = data["recipeID"] as? String
//                        let title = data["title"] as? String
//                        let cookingTime = data["cookingTime"] as? Int
//                        let like = data["like"] as? Int
//                        let serving = data["serving"] as? Int
//
//                        let userId = data["userID"] as? String
//                        let time = data["time"] as? Timestamp
//
//                        let image = data["image"] as? String
//                        let genresData = data["genres"] as? [String: Bool]
//
//                        var genresArr: [String] = []
//
//                        if let gotData = genresData {
//                            for genre in gotData {
//                                genresArr.append(genre.key)
//                            }
//                        }
//
//
//
//                        let recipe = RecipeDetail(recipeID: recipeId!, title: title!, updatedDate: time!, cookingTime: cookingTime ?? 0, image: image ?? "", like: like!, serving: serving ?? 0, userID: userId!, genres: genresArr)
//
//                        recipeList.append(recipe)
//
//                    }
//                }
//                exist = true
//            } else {
//                print(err?.localizedDescription as Any)
//                print("Document does not exist")
//                exist = false
//            }
//
//            self.isDataExist(exist,recipeList)
//        }
//
//    }
//
//       func isDataExist(_ exist:Bool, _ data: [RecipeDetail]){
//           if exist{
//               delegate?.reloadData(data:data)
//           }
//       }
//
//
       
       
}
