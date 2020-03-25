//
//  getDataFromFirebase.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-02.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit


protocol getDataFromFirebaseDelegate {
    func assignImage(image: UIImage, reference: UIImageView)
    
    func gotData(recipes:[RecipeDetail])
    
    func gotImagesData(images:[UIImage])
}
