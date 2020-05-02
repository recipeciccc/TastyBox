//
//  IngredientTitleCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-12.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class IngredientTitleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    
    override func awakeFromNib() {
        titleLabel.textAlignment = .center
    }
    
    func focusCell(active: Bool) {
           let color = active ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.728063643, green: 1, blue: 0.9948994517, alpha: 1)
           titleView.backgroundColor = color
           let labelColor = active ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0.5880746245, blue: 1, alpha: 1)
           titleLabel.textColor = labelColor
       }
    
}
