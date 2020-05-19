//
//  IngredientImageCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-12.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class IngredientImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ingredientRecipeImage: UIImageView!
    @IBOutlet weak var ingredientRecipeName: UILabel!
    
    @IBOutlet weak var lockImageView: UIImageView!
    
    override func awakeFromNib() {
        let widthAnchor = lockImageView.widthAnchor.constraint(equalToConstant: self.ingredientRecipeImage.frame.size.width / 3 * 2)
        
        let heightAnchor = lockImageView.heightAnchor.constraint(equalToConstant: self.ingredientRecipeImage.frame.size.width / 3 * 2)
        
        widthAnchor.isActive = true
        heightAnchor.isActive = true
    }
    
}
