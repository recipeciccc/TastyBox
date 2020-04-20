//
//  getDataFromFirebase.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-02.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit


protocol getDataFromFirebaseDelegate:class {
    func assignImage(image: UIImage, index: Int)
    
    func gotData(recipes:[RecipeDetail])
    
    
}
