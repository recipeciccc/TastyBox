//
//  recipeGenresCollectionViewExtension.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit

extension RecipeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeGenres", for: indexPath) as! recipeGenresCollectionViewCell
        cell.genreLabel.text = "#\(self.genres[indexPath.row])"
        cell.contentView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "resultRecipes") as! ResultRecipesViewController
        
        vc.searchingCategory = "genres"
        vc.searchingWord = self.genres[indexPath.row]
       
        guard self.navigationController?.topViewController == self else { return }

        navigationController?.pushViewController(vc, animated: true)
       
    }
}



