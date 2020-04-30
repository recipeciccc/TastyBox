//
//  User.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

struct User {
    var userID: String
    var name: String
//    var image: String
    var cuisineType: String
    var familySize: Int?
    var isVIP: Bool?
    
    
//    var followersID: [String]
//    var followingID: [String]
}

struct  AllergicFoodData {
    var allergicFood: String
    var checkedFood: Bool?
}



struct AllFoodList {
    var allFood:[AllergicFoodData]
}




