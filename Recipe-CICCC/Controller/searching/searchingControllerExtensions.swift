//
//  searchingControllerExtensions.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Crashlytics

extension SearchingViewController : SearchingCreatorsDataManagerDelegate{
    func searchedUsers(users: [User]) {
        self.searchedResults = users
        
        for (index, user) in self.searchedResults.enumerated() {
            CreatorDataManager.getUserImage(uid: user.userID, index: index)
        }
        if creatorVC.tableView != nil {
            creatorVC.tableView.reloadData()
        }
    }
    
    func assignUserImage(image: UIImage, index: Int) {
        self.searchedUsersImages[index] = image
        if creatorVC.tableView != nil {
            creatorVC.tableView.reloadData()
        }
    }
    
}

extension SearchingViewController : getIngredientsDelegate {
    
    func gotIngredients(ingredients: [String]) {
        
        self.searchedIngredient = ingredients
        if ingredientVC.tableView != nil {
            ingredientVC.tableView.reloadData()
        }
        
    }
    
}

extension SearchingViewController : isGenreExistDelegate {
    func gotGenres(getGenres: [String]) {
        searchedGenre = getGenres
        
        if genreVC.tableView != nil {
            genreVC.tableView.reloadData()
        }
    }
    
}
