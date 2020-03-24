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
    
    let RecipeListCreator = recipeListCreator()
    let numOfCreatorhasTableViewCell = NumOfCreatorhasTableViewCell()
    weak var delegate: AddingFollowersDelegate?


    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    var userID: String?
    let uid = Auth.auth().currentUser?.uid
    
    lazy var numRecipes = RecipeListCreator.creatorRecipeLists.count
    
    
    @IBAction func followersAddButton(_ sender: Any) {
        numOfCreatorhasTableViewCell.numOfFollowed += 1
        // how can i show the number when it increase?
        self.delegate!.increaseFollower(userID: userID!, followerID: uid!)
    }
    
    
    // this is called when it is initialized.
    override func awakeFromNib() {
        super.awakeFromNib()
        creatorNameLabel.text = "Lay FangYi"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
