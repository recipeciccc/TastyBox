//
//  recipeGenresCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class recipeGenresCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        genreLabel.textColor = .orange
    }
}
