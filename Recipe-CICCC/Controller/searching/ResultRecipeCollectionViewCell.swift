//
//  ResultRecipeCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-21.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class ResultRecipeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lockImageView: UIImageView!
    
    
    override func awakeFromNib() {
        let widthAnchor = lockImageView.widthAnchor.constraint(equalToConstant: self.frame.size.width / 3 * 2)
        
        let heightAnchor = lockImageView.heightAnchor.constraint(equalToConstant: self.frame.size.width / 3 * 2)
        
        widthAnchor.isActive = true
        heightAnchor.isActive = true
    }
}
