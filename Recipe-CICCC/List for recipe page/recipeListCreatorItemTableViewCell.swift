//
//  recipeListCreatorItemTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-19.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class recipeListCreatorItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameRecipeLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    
    var nameRecipe = ""
    var numLikes = 0
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numLikesLabel.text = "\(numLikes)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
