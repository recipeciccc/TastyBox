//
//  FolllowingFollower.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-30.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol FolllowingFollowerDelegate : class{
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String])
//    func assignFollowersFollowings(users: [User])
//    func assginFollowersFollowingsImages(image: UIImage, index: Int)
    func statusUsers(isBlocked: Bool, isBlocking: Bool, isFollowing: Bool)
}
