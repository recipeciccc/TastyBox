//
//  recipeGenresCollectionViewExtension.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit

extension RecipeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeGenres", for: indexPath) as! recipeGenresCollectionViewCell
        cell.genreLabel.text = "#\(self.genres[indexPath.row])"
        
        return cell
    }
    
    

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let cell = collectionView.cellForItem(at: indexPath) as! recipeGenresCollectionViewCell
//        
//        let width: CGFloat = cell.genreLabel.frame.size.width
//        let height = UILabel().frame.size.height
//        return CGSize(width: width, height: height)
//    }
}



