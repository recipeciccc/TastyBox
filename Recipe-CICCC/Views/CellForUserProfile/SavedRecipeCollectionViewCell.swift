//
//  SavedRecipeCollectionViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-01-23.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class SavedRecipeCollectionViewCell: UICollectionViewCell {
    
    var item = RecipeItem()
    
    var name: String = ""
    var image :UIImage?
    var imageView:UIImageView?
    
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    
    
    required convenience init?(coder: NSCoder) {
        
        self.init(coder: coder)
        // enable to input any value later
        name = "08COOKING-POTATO2-articleLarge-v2"
        image = UIImage(named: name)
        imageView = UIImageView(image: image)
        
        width = ((self.superview?.frame.width)! - 2) / 3
        height = width
    }
    
   // imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
    
}
