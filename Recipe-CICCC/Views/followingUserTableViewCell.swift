//
//  followingUserTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class followingUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var followingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
