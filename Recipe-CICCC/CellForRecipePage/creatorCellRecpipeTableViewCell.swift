//
//  creatorCellRecpipeTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class creatorCellRecpipeTableViewCell: UITableViewCell {

    let numOfCreatorhasTableViewCell = NumOfCreatorhasTableViewCell()

    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var imgCreator: UIButton!
    
    
    @IBAction func followerAdding(_ sender: Any) {
        numOfCreatorhasTableViewCell.numOfFollowed += 1
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        creatorNameLabel.text = ""
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
