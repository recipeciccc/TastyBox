//
//  NumOfCreatorhasTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-01-23.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class NumOfCreatorhasTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var NumOfPostedButton: UIButton!
    @IBOutlet weak var NumOffollowingButton: UIButton!
    @IBOutlet weak var NumOFFollwerButton: UIButton!
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NumOfPostedButton.titleLabel?.numberOfLines = 0
         NumOfPostedButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        NumOffollowingButton.titleLabel?.numberOfLines = 0
        NumOffollowingButton.titleLabel?.textAlignment = NSTextAlignment.center
        NumOffollowingButton.setTitle("\nFollowing", for: .normal)
        
        NumOFFollwerButton.titleLabel?.numberOfLines = 0
        NumOFFollwerButton.titleLabel?.textAlignment = NSTextAlignment.center
        NumOFFollwerButton.setTitle("\nFollowed", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
