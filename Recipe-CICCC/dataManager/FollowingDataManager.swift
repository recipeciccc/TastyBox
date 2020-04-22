//
//  FollowingDataManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-16.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

class FollowingDataManager {

weak var delegate: FollowingDelegate?

func getImageOfRecipesFollowing(uid: String, rid: String, indexOfImage: Int, orderFollowing: Int) {
    
    var image = UIImage()
    let storage = Storage.storage()
    let storageRef = storage.reference()
    
    let imageRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
    
    
    
    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
        if error != nil {
            print(error?.localizedDescription as Any)
        } else {
            image = UIImage(data: data!)!
            self.delegate?.appendRecipeImage(imgs: image, indexOfImage: indexOfImage, orderFollowing: orderFollowing)
        }
        
    }
    
    
    
}
}
