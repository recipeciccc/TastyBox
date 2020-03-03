//
//  FollowingRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class FollowingRecipeViewController: UIViewController {
    
    @IBOutlet weak var folowingTableView: UITableView!
    
    var creatorImageList = [UIImage]()
    var creatorNameList = [String]()
    var recipeImage = [[UIImage]]()
    var recipeTitle = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorImageList = [#imageLiteral(resourceName: "imageFile"),#imageLiteral(resourceName: "imageFile"),#imageLiteral(resourceName: "imageFile")]
        creatorNameList = ["Ruby Smith","Sherry Heni","Anne Casper"]
        recipeImage = [[#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600")],
                       [#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723")],
                       [#imageLiteral(resourceName: "13PAIRING-articleLarge"),#imageLiteral(resourceName: "13PAIRING-articleLarge"),#imageLiteral(resourceName: "13PAIRING-articleLarge"),#imageLiteral(resourceName: "13PAIRING-articleLarge"),#imageLiteral(resourceName: "13PAIRING-articleLarge"),#imageLiteral(resourceName: "13PAIRING-articleLarge")]]
        recipeTitle = [["Title","Title","Title","Title","Title","Title"],["Title","Title","Title","Title","Title","Title"],["Title","Title","Title","Title","Title","Title"]]
    }
    
}

extension FollowingRecipeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatorImageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! FollowingRecipeTableViewCell
        cell.creatorImage.image = creatorImageList[indexPath.row]
        cell.createrName.text = creatorNameList[indexPath.row]
        
        cell.createrName.isUserInteractionEnabled = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? FollowingRecipeTableViewCell else {return}
        tableViewCell.collectionViewDelegate(self, row: indexPath.row)
    }
    
    
}

extension FollowingRecipeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeTitle[collectionView.tag].count 
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
    
}

