//
//  profieTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-22.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

protocol followingManageDelegate: class {
    func increaseFollower()
    func unfollow()
}

class profieTableViewCell: UITableViewCell {
    
    let recipes: [RecipeDetail] = []
    let numOfCreatorhasTableViewCell = NumOfCreatorhasTableViewCell()
    weak var delegate: followingManageDelegate?


    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var followMeButton: UIButton!
    
    var userID: String?
    let uid = Auth.auth().currentUser?.uid
    
    lazy var numRecipes = recipes.count
    
    
    @IBAction func followingManageAction(_ sender: UIButton) {
        // how can i show the number when it increase?
        if sender.titleLabel?.text! == "  follow me!  " {
             self.delegate!.increaseFollower()
//            self.followingManagement(isFollowing: true)
        }
        else if sender.titleLabel?.text! == "  Following  "{
            self.delegate?.unfollow()
        }
       
    }
    
    func followingManagement(isFollowing: Bool) {
        print(isFollowing)
        if isFollowing {
            self.followMeButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.followMeButton.layer.borderColor = #colorLiteral(red: 1, green: 0.6430701613, blue: 0, alpha: 1)
            self.followMeButton.layer.borderWidth = 2
            self.followMeButton.tintColor = .orange
            self.followMeButton.setTitle("  Following  ", for: .normal)
        } else {
            self.followMeButton.backgroundColor = #colorLiteral(red: 1, green: 0.6430701613, blue: 0, alpha: 1)
            self.followMeButton.tintColor = .white
            self.followMeButton.setTitle("  follow me!  ", for: .normal)
            
        }
    }
    
    // this is called when it is initialized.
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.creatorImageView!.layer.masksToBounds = false
        self.creatorImageView!.layer.cornerRadius = self.creatorImageView!.bounds.width / 2
        self.creatorImageView!.clipsToBounds = true
        
        self.followMeButton.layer.cornerRadius = 10
        self.followMeButton.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
