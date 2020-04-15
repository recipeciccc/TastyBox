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
    var delegate : CollectionViewInsideUserTableView?
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return 15
    //    }
    
    
    //    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
    //        collectionView.delegate = dataSourceDelegate
    //        collectionView.dataSource = dataSourceDelegate
    //        self.collectionView.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recipeItem")
    //
    //    }
    
    
    
    //    var collectionViewOffset: CGFloat {
    //        get {collectionViewID
    //            return collectionView.contentOffset.x
    //        }
    //
    //        set {
    //            collectionView.contentOffset.x = newValue
    //        }
    
    
    
}


extension RecipeItemCollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(recipeImage.count)
        return recipeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "creatorRecipes", for: indexPath) as? RecipeCreatorPostedCollectionViewCell)!
        
        cell.imageView!.tag = indexPath.row
        cell.imageView!.image = recipeImage[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.delegate?.cellTaped(data: indexPath)
    }
}
