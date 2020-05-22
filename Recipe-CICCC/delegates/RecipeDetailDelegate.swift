//
//  RecipeDetailDelegate.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-26.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol RecipeDetailDelegate: class {
    func getCreator(creator: User)
    func isLikedRecipe(isLiked: Bool)
    func isFollowingCreator(isFollowing: Bool)
    func gotGenres(genres: [String])
    func UnfollowedAction()
    func FollowedAction()
    func isVIP(isVIP: Bool)
    func gotInstructionImages(images:[Int: UIImage])
}
