//
//  recipeGenresTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class recipeGenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var genres:[String] = []
    
    func configure(with arr: [String]) {
        self.genres = arr
        self.genresCollectionView.reloadData()
        self.genresCollectionView.layoutIfNeeded()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
         self.contentView.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
