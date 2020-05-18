//
//  RecipeDetailDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase


class RecipeDetailDataManager {
    var recipe: RecipeDetail?
    var ingredientList:[Ingredient] = []
    var instructionList: [Instruction] = []
    let db = Firestore.firestore()
    weak var delegate: RecipeDetailDelegate?
    let uid = Auth.auth().currentUser?.uid
    
    func isLikedRecipe(recipeID: String) {
        db.collection("user").document(uid!).addSnapshotListener {
            (querysnapshot, error) in
            
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                if let data = querysnapshot?.data() {
                    if let dictionaryLikedRecipe = data["likedRecipe"] as? [String : Bool] {
                       
                        
                        let isLiked = dictionaryLikedRecipe.enumerated().filter {
                            $0.1.key == recipeID
                        }.map {
                            $0.element.value
                        }
                        
                        if isLiked.isEmpty {
                            self.delegate?.isLikedRecipe(isLiked: false)

                        } else {
                            self.delegate?.isLikedRecipe(isLiked: isLiked[0])

                        }
                    }
                    
                }
                
            }
        }
    }
    
    func getGenres(tableView: UITableView, recipe: RecipeDetail){
        db.collection("recipe").document(recipe.recipeID).addSnapshotListener { (snapshot, err) in
               if err != nil{
                   print("Error: Can not fetch data.")
               }
               else{
                   if let data = snapshot?.data(){
                       
                    guard let genresDictionary = data["genres"] as? [String: Bool] else {
                        return
                    }
                    
                    let genres = [String](genresDictionary.keys)
                    self.delegate?.gotGenres(genres: [String](genres))
                       
                   }
               }
           }
       }
    
    
    func getIngredientData(query:Query, tableView: UITableView){
        query.getDocuments { (snapshot, err) in
            if err != nil{
                print("Error: Can not fetch data.")
            }
            else{
                if let snap = snapshot?.documents{
                    for document in snap{
                        let ingredientData = document.data()
                        let name = ingredientData["ingredient"] as? String
                        let amount = ingredientData["amount"] as? String
                        self.ingredientList.append(Ingredient(name: name!, amount: amount!))
                    }
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getInstructionData(query:Query, tableView: UITableView){
        query.getDocuments { (snapshot, err) in
            if err != nil{
                print("Error: Can not fetch data.")
            }
            else{
                if let snap = snapshot?.documents{
                    for document in snap{
                        let Data = document.data()
                        let url = Data["image"] as? String
                        let text = Data["text"] as? String
                        self.instructionList.append(Instruction(index: self.ingredientList.count, imageUrl: url!, text: text!))
                    }
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func increaseLike(recipe: RecipeDetail, isIncreased: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("recipe").document(recipe.recipeID).setData (
            ["like": recipe.like], merge: true
        ) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        let increaseOrDecrease = isIncreased ? true : false
        db.collection("user").document(uid).setData (
            ["likedRecipe": [recipe.recipeID : increaseOrDecrease]], merge: true
        ) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func increaseFollower(followerID: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("user").document(followerID).collection("follower").document(uid).setData([
            "id": uid
        ], merge: true ){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        db.collection("user").document(uid).collection("following").document(followerID).setData([
            "id": followerID
        ], merge: true ){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
