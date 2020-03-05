//
//  ShoppingList.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-05.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
class ShoppingList {
    var list: [IngredientShopping] = []
    
//    init() {
//        let row0Item = IngredientShopping()
//        let row1Item = IngredientShopping()
//        let row2Item = IngredientShopping()
//        
//        row0Item.name = "Tuna"
//        row0Item.amount = "1"
//        
//        row1Item.name = "Cucumber"
//        row1Item.amount = "5"
//        
//        row2Item.name = "Banana"
//        row2Item.amount = "100"
//        
//        list.append(row0Item)
//        list.append(row1Item)
//        list.append(row2Item)
//        
//    }
//    
//    func move(item: IngredientShopping, to index:Int) {
//        guard let currentIndex = list.index(of: item) else {
//            return
//        }
//        list.remove(at: currentIndex)
//        list.insert(item, at: index)
//    }
//    
//    func remove(items: [IngredientShopping]) {
//        
//        for item in items {
//            if let index = items.firstIndex(of: item) {
//                list.remove(at: index)
//            }
//        }
//    }
//    
//    func newToDo(item: IngredientShopping) -> IngredientShopping {
//        list.append(item)
//        return item
//    }
}
