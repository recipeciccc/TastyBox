//
//  UnderNo4TableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class UnderNo4TableViewCell: UITableViewCell {

    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var numLikeLabel: UILabel!
    @IBOutlet weak var numCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
        numLikeLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
        rankingLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
