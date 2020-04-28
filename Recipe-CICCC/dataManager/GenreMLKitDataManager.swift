//
//  GenreMLKitDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-27.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol GenreMLKitDataManagerDelegate: class {
    func passLabeledArray(arr:[String])
}

class GenreMLKitDataManager {
    
    var labels:[String] = []
    
    weak var delegate: GenreMLKitDataManagerDelegate?
    func labelingImage(image: UIImage) {
        let image = VisionImage(image: image)
        let labeler = Vision.vision().cloudImageLabeler()
        
        labeler.process(image) { labels, error in
            guard error == nil else {
                print(error!)
                return }
            guard let labels = labels else { return }

            // Task succeeded.
            // ...
            for (index, label) in labels.enumerated() {
                let labelText = label.text
               
                if labelText == "Cuisine" || labelText == "Food" || labelText == "Recipe" || labelText == "Cooking" || labelText == "Dish" || labelText == "Ingredient" {
                  
                    
                } else {
                    self.labels.append(labelText)
                }
                
                if index == labels.count - 1 {
                    print(self.labels)
                    self.delegate?.passLabeledArray(arr: self.labels)
                }
            }
        }
    }
}
