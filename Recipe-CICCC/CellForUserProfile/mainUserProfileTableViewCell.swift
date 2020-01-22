//
//  mainUserProfileTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class mainUserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userNameLabel.text = "Shihomi Kitajima"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
