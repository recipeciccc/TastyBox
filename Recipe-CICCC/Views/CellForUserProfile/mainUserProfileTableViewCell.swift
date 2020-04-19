//
//  mainUserProfileTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

class mainUserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editProfilebutton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let name = Auth.auth().currentUser?.displayName {
            userNameLabel.text = name
            
        }
        editProfilebutton.layer.cornerRadius = 10
        self.userImageView?.contentMode = .scaleAspectFit
        self.userImageView.layer.masksToBounds = false
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.width / 2
        self.userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
