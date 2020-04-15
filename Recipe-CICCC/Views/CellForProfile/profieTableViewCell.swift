//
//  profieTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-22.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

class profieTableViewCell: UITableViewCell {
    
    let recipes: [RecipeDetail] = []
    let numOfCreatorhasTableViewCell = NumOfCreatorhasTableViewCell()
    weak var delegate: AddingFollowersDelegate?


    @IBOutlet weak var creatorImageView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var followMeButton: UIButton!
    
    var userID: String?
    let uid = Auth.auth().currentUser?.uid
    
    lazy var numRecipes = recipes.count
    
    
    @IBAction func followersAddButton(_ sender: Any) {
        // how can i show the number when it increase?
        self.delegate!.increaseFollower(followerID: uid!)
    }
    
    
    // this is called when it is initialized.
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
