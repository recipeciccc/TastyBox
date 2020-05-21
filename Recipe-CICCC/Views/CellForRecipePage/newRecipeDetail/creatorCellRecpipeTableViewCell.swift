//
//  creatorCellRecpipeTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

protocol ManageFollowersDelegate: class {
    func increaseFollower(followerID: String)
    func decreaseFollower(followerID: String)
}


class creatorCellRecpipeTableViewCell: UITableViewCell {
    
    weak var delegate: ManageFollowersDelegate?

    @IBOutlet weak var creatorNameButton: UIButton!
    @IBOutlet weak var imgCreator: UIButton!
    @IBOutlet weak var followManageButton: UIButton!
    
    var userID: String?
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var followBtn: UIButton!
    @IBAction func followerAdding(_ sender: UIButton) {
        
        if sender.backgroundColor == #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1) {
            self.delegate?.decreaseFollower(followerID: userID!)
        }
        else if sender.backgroundColor == .white {
            self.delegate?.increaseFollower(followerID: userID!)
        }
    }
    
    func followingButtonUIManagement(isFollowing: Bool) {
        
        if isFollowing {
            
            followManageButton.setTitle("  Following  ", for: .normal)
                
                followManageButton.setTitleColor(.white, for: .normal)
                followManageButton.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
                           
            } else {
                
                followManageButton.setTitle("  follow me!  ", for: .normal)
               
                followManageButton.backgroundColor = .white
                followManageButton.setTitleColor(#colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1), for: .normal)
                followManageButton.layer.borderWidth = 2
                followManageButton.layer.borderColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
            }
            
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.contentView.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        creatorNameButton.setTitleColor( #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1), for: .normal)
        imgCreator.layer.cornerRadius = imgCreator.layer.frame.width / 2
        imgCreator.layer.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        followManageButton.layer.cornerRadius = 10
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
