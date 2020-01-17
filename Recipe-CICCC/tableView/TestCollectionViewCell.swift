//
//  TestCollectionViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-12.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var imageView: UIImageView! 
       
       var image: UIImage! {
           didSet {
               self.imageView.image = image
               self.setNeedsLayout()
           }
       }
}
