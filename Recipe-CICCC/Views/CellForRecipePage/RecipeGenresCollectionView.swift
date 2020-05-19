//
//  RecipeGenresCollectionView.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation


class RecipeGenresCollectionView: UICollectionView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func awakeFromNib() {
        self.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
         self.isUserInteractionEnabled = true
    }

}
