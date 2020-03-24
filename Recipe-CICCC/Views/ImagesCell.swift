//
//  ImageCell.swift
//  RecipeDiscovery
//
//  Created by fangyilai on 2019-10-24.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

class ImagesCell: UITableViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ImageLabel: UILabel!
    
    func setImage(UIimage: Image){
        ImageView.image = UIimage.image
        ImageLabel.text = UIimage.title
    }
    
}
