//
//  RecipeItemCollectionViewTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-12.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class RecipeItemCollectionViewTableViewCell: UITableViewCell {
    
    var recipeData: [RecipeDetail] = []
    var recipeImage = [UIImage]()
    weak var delegate : CollectionViewInsideProfileTableViewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
}


extension RecipeItemCollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(recipeImage.count)
        return recipeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "creatorRecipes", for: indexPath) as? RecipeCreatorPostedCollectionViewCell)!
        
        cell.recipeImageView!.tag = indexPath.row
        cell.recipeImageView!.image = recipeImage[indexPath.row]
        
        cell.lockImageView.isHidden = recipeData[indexPath.row].isVIPRecipe! ? false : true
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 1.0

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellTaped(data: indexPath)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset == CGPoint(x: 0, y: 0) {
            self.delegate?.beginDragging()
        }
    }
}
