//
//  getIngredientData.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-04.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol getIngredientShoppingDataDelegate {
    
    func gotData(ingredients:[IngredientShopping])
}


protocol getIngredientRefrigeratorDataDelegate {
    
    func gotData(ingredients:[IngredientRefrigerator])
}
