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
//        titleLabel.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        // Configure the view for the selected state
        titleLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
        
    }

}
