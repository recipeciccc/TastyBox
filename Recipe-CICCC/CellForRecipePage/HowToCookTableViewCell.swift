//
//  HowToCookTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class HowToCookTableViewCell: UITableViewCell {

    @IBOutlet weak var howToCookLabel: UILabel!
    
    var howToCook = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        howToCookLabel.text = howToCook
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
