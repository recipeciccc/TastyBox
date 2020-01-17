//
//  iconItemTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class iconItemTableViewCell: UITableViewCell {

    @IBOutlet weak var numLikeLabel: UILabel!
    
    var numLike = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numLikeLabel.text = "\(numLike)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
               // Configure the view for the selected state
    }

}
