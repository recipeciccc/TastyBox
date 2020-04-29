//
//  SectionHeaderGenreSelectCollectionReusableView.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-28.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class SectionHeaderGenreSelectCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        titleLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
    }
}
