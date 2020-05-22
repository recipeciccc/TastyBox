//
//  GetCommentsDelegate.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol GetCommentsDelegate: class {
    func assignUserImage(image: UIImage)
    func gotData(comments:[Comment])
    func getCommentUser(user: [User], comments: [Comment])
    func assignUserImage(images: [Int:UIImage])
}
