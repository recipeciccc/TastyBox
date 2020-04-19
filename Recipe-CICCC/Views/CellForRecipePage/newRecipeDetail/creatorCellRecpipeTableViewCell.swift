//
//  creatorCellRecpipeTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase

protocol AddingFollowersDelegate: class {
    func increaseFollower(followerID: String)
}


class creatorCellRecpipeTableViewCell: UITableViewCell {

    let numOfCreatorhasTableViewCell = NumOfCreatorhasTableViewCell()
    
    weak var delegate: AddingFollowersDelegate?

//    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var creatorNameButton: UIButton!
    @IBOutlet weak var imgCreator: UIButton!
    
    var userID: String?
    
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var followBtn: UIButton!
    @IBAction func followerAdding(_ sender: Any) {
        self.delegate?.increaseFollower(followerID: userID!)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        creatorNameButton
        self.contentView.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        creatorNameButton.setTitleColor( #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1), for: .normal)
        imgCreator.layer.cornerRadius = imgCreator.layer.frame.width / 2
        imgCreator.layer.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
