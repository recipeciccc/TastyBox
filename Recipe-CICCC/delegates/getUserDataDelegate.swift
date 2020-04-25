//
//  getUserDataDelegate.swift
//  
//
//  Created by 北島　志帆美 on 2020-03-05.
//

import Foundation

protocol getUserDataDelegate : class {
//    func gotUsersData(users: [User])
    func gotUserData(user: User)
    func assignUserImage(image: UIImage)
    
}
