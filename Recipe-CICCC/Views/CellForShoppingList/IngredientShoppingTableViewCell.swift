//
//  IngredientShoppingTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-05.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class IngredientShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
