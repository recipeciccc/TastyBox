//
//  explanationTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-06.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class titleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
