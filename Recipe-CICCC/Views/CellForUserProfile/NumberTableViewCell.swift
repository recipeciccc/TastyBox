//
//  buttonsTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class NumberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numOfRecipeUserSavedButton: UIButton!
    
    @IBOutlet weak var numOfRecipeUserPostedButton: UIButton!
    
    @IBOutlet weak var numOfFollowerButton: UIButton!
    
    @IBOutlet weak var numOfFollwingButton: UIButton!
    
    var numOfRecipeUserSaved = 0
    var numOfRecipeUserPosted = 0
    var numOfFollower = 0
    var numOfFollwing = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numOfRecipeUserSavedButton.titleLabel?.numberOfLines = 0
        numOfRecipeUserSavedButton.setTitle("\(numOfRecipeUserSaved) \nSaved", for: .normal)
        numOfRecipeUserSavedButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        numOfRecipeUserPostedButton.titleLabel?.numberOfLines = 0
        numOfRecipeUserPostedButton.setTitle("\(numOfRecipeUserPosted) \nPosted", for: .normal)
        numOfRecipeUserPostedButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        numOfFollowerButton.titleLabel?.numberOfLines = 0
        numOfFollowerButton.setTitle("\(numOfFollower) \nFollower", for: .normal)
        numOfFollowerButton.titleLabel?.textAlignment = NSTextAlignment.center
        
        numOfFollwingButton.titleLabel?.numberOfLines = 0
        numOfFollwingButton.setTitle("\(numOfFollwing) \nFollowing", for: .normal)
        numOfFollwingButton.titleLabel?.textAlignment = NSTextAlignment.center
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
