//
//  RecipeItemCollectionViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-12.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class RecipeItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var test1: UILabel!
    @IBOutlet weak var test2: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // cellの枠の太さ
        self.layer.borderWidth = 1.0
        // cellの枠の色
        self.layer.borderColor = UIColor.black.cgColor
        // cellを丸くする
        self.layer.cornerRadius = 8.0
    }
}
