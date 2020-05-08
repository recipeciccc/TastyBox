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
    @IBOutlet weak var userManageButton: UIButton!
    
    weak var delegate: userManageDelegate?
    var userID:String = ""

    @IBAction func userManageButtonAction(_ sender: Any) {
        self.delegate?.pressedUserManageButton(uid: userID)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgView?.contentMode = .scaleAspectFit
        self.imgView.layer.masksToBounds = false
        self.imgView.layer.cornerRadius = self.imgView.bounds.width / 2
        self.imgView.clipsToBounds = true
        
        self.followingButton.setTitleColor(.orange, for: .normal)
        self.followingButton.backgroundColor = .white
        self.followingButton.layer.borderWidth = 2
        self.followingButton.layer.borderColor = #colorLiteral(red: 1, green: 0.6430701613, blue: 0, alpha: 1)
        self.followingButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
