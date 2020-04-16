//
//  FollowingDelegate.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-16.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol  FollowingDelegate: class {
    func appendRecipeImage(imgs: UIImage, indexOfImage: Int, orderFollowing: Int)
}
