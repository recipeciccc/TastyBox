//
//  buttonTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-08.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    
    var titleButton = ""
    var buttonImage: UIImage? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonTitleLabel.text = titleButton
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
