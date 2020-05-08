//
//  follwerUserTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol userManageDelegate: class {
    func pressedUserManageButton(uid:String)
}

class follwerUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var followingButton: UIView!
    @IBOutlet weak var userManageButton: UIButton!
    
    var userID = ""
    
    weak var delegate: userManageDelegate?
    
    @IBAction func userManageButtonAction(_ sender: Any) {
        self.delegate?.pressedUserManageButton(uid: userID)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
