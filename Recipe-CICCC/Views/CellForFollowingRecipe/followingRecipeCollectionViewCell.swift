//
//  followingRecipeCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class followingRecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    
    override func awakeFromNib() {
        RecipeName.textAlignment = .center
        
        let widthAnchor = lockImageView.widthAnchor.constraint(equalToConstant: self.RecipeImage.frame.size.width / 3 * 2)
        
        let heightAnchor = lockImageView.heightAnchor.constraint(equalToConstant: self.RecipeImage.frame.size.width / 3 * 2)
        
        widthAnchor.isActive = true
        heightAnchor.isActive = true
    }
}


