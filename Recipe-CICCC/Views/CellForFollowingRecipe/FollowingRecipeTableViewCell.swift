//
//  FollowingRecipeTableViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol FollowingRecipeTableViewCellDelegate: class {
    func goToCreatorProfile(indexPath: IndexPath)
}

class FollowingRecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    
    @IBOutlet weak var creatorImageButton: UIButton!
    @IBOutlet weak var creatorNameButton: UIButton!
    
    var creatorImage:UIImage?
    var name: String?
    var indexPath: IndexPath?
    weak var delegate: FollowingRecipeTableViewCellDelegate?
    

    func collectionViewDelegate<D:UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate:D, row: Int ){
        recipeCollectionView.delegate = dataSourceDelegate
        recipeCollectionView.dataSource = dataSourceDelegate
        recipeCollectionView.tag = row
        recipeCollectionView.reloadData()
    }
    
   

    override func awakeFromNib() {
       
        self.creatorImageButton.layer.cornerRadius = self.creatorImageButton.frame.width / 2
        self.creatorImageButton.clipsToBounds = true
        creatorImageButton.setTitle("", for: .normal)

        self.creatorNameButton.contentHorizontalAlignment = .left
        self.creatorNameButton.tintColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
        
    }
    
    @IBAction func ToCreatorProfile(_ sender: Any) {
        self.delegate?.goToCreatorProfile(indexPath: indexPath!)
    }
    
}
