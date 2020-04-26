//
//  recipePreferenceTableViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-26.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class recipePreferenceTableViewCell: UITableViewCell {

    @IBOutlet weak var item: UILabel!
    var select = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
