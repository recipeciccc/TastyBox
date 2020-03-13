//
//  IngredientsTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientsNameLabel: UILabel!
    @IBOutlet weak var amountIngredientsLabel: UILabel!
    
    var ingredientName = ""
    var amountIngredient = ""
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ingredientsNameLabel.text = ingredientName
        amountIngredientsLabel.text = amountIngredient
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
