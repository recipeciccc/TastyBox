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
    //    func gotGenres(getGenres: [String])
    //    func gotIngredients(ingredients: [String])
    func searchedUsers(users: [User])
    func assignUserImage(image: UIImage, index: Int)
    //    func reloadData(data:[RecipeDetail])
}

class SearchingDataManager: fetchRecipes {
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    weak var delegateChild: SearchingCreatorsDataManagerDelegate?
    
    func getSearchedCreator(query: CollectionReference, searchingWord: String) {
        
        query.addSnapshotListener {
            (querySnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                var users: [User] = []
                var user: User?
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    guard let userID = data["id"] as? String else { continue }
                    guard let name = data["userName"] as? String else { continue }
                    guard let familySize = data["familySize"] as? Int else { continue }
                    guard let cuisineType = data["cuisineType"] as? String else { continue }
                    guard let isVIP = data["isVIP"] as? Bool else { continue }
                    
                    
                    
                    user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                    
                    if let userName = user?.name.lowercased() {
                        let searchingWord = searchingWord.lowercased()
                        if userName.contains(searchingWord) {
                            users.append(user!)
                            
                        }
                        
                        
                    }
                    
                }
                self.delegateChild?.searchedUsers(users: users)
            }
            
        }
    }
    
    func getUserImage(uid: String, index: Int) {
        let imageRef = storageRef.child("user/\(uid)/userAccountImage")
        var image: UIImage?
        // Fetch the download URL
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data {
                    
                    print("imageRef: \(imageRef)")
                    
                    image = UIImage(data: imgData)!
                    self.delegateChild?.assignUserImage(image: image!, index: index)
                }
            }
        }
    }
    
    
}
