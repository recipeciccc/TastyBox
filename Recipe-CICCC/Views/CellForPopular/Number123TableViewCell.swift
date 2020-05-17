//
//  Number123TableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class Number123TableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var numberLikeLabel: UILabel!
    
    @IBOutlet weak var lockImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
        numberLikeLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
        
        lockImageView.isOpaque = false
        lockImageView.tintColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7)
        
        
        lockImageView.frame.size.width = self.recipeImageView.frame.size.width / 3 * 2
              lockImageView.frame.size.height = self.recipeImageView.frame.size.width / 3 * 2
              
              let widthAnchor = lockImageView.widthAnchor.constraint(equalToConstant: self.recipeImageView.frame.size.width / 3 * 2)
              let heightAnchor = lockImageView.heightAnchor.constraint(equalToConstant: self.recipeImageView.frame.size.width / 3 * 2)
        
        widthAnchor.isActive = true
        heightAnchor.isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
