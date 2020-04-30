//
//  getAllergicFoodDelegate.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-29.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol getAllergicFoodDelegate: class {
    func getFoodData(foodList:[AllergicFoodData],index: Int)
    func getCheckedData(foodList:[String],index: Int)
}
