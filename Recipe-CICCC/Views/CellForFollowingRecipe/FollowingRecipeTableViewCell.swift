//
//  FollowingRecipeTableViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class FollowingRecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var createrName: UILabel!
    

    func collectionViewDelegate<D:UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate:D, row: Int ){
        recipeCollectionView.delegate = dataSourceDelegate
        recipeCollectionView.dataSource = dataSourceDelegate
        recipeCollectionView.tag = row
        recipeCollectionView.reloadData()
    }

}
