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
    
     var recipeImage = [[UIImage]]()
     var recipeTitle = [[String]]()
     var numberofrow = 0
    
    override func awakeFromNib() {
        let tb = FollowingRecipeViewController()
        numberofrow = tb.creatorNameList.count
        
        recipeImage = [[#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600")],
                       [#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723")],
                       [#imageLiteral(resourceName: "images (1)"),#imageLiteral(resourceName: "images (1)"),#imageLiteral(resourceName: "images (1)"),#imageLiteral(resourceName: "images (1)"),#imageLiteral(resourceName: "images (1)"),#imageLiteral(resourceName: "images (1)")]]
        recipeTitle = [["Title","Title","Title","Title","Title","Title"],["Title","Title","Title","Title","Title","Title"],["Title","Title","Title","Title","Title","Title"]]
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
    }

}


extension FollowingRecipeTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeTitle[collectionView.tag].count // only show 6 new recipes
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! followingRecipeCollectionViewCell
       
        cell.RecipeImage.image = recipeImage[collectionView.tag][indexPath.row]
        cell.RecipeName.text = recipeTitle[collectionView.tag][indexPath.row]
        
        return cell
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 163, height: 162)
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        recipeCollectionView.delegate = dataSourceDelegate
        recipeCollectionView.dataSource = dataSourceDelegate
        recipeCollectionView.tag = row
        recipeCollectionView.reloadData()
    }
    
}
