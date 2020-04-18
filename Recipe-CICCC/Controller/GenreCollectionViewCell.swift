//
//  GenreCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
       
        self.genreLabel.textAlignment = .center
       
        
       
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 3.0
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func highlight(active: Bool) {
        self.genreLabel.textColor =  active ? .white : .orange
        self.contentView.backgroundColor  = active ? .orange : .white
    }
    
}
