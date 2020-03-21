//
//  creatorCellRecpipeTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

protocol creatorCellRecpipeTableViewCellDelegate: class {
    func increaseFollower()
}


class creatorCellRecpipeTableViewCell: UITableViewCell {

    let numOfCreatorhasTableViewCell = NumOfCreatorhasTableViewCell()
    
    weak var delegate: creatorCellRecpipeTableViewCellDelegate?

//    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var labelCreator: UIButton!
    @IBOutlet weak var imgCreator: UIButton!
    
    
    @IBOutlet weak var followBtn: UIButton!
    @IBAction func followerAdding(_ sender: Any) {
        self.delegate?.increaseFollower()
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
