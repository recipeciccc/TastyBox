//
//  buttonsList.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-08.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import Foundation

//class can be deleted!
class ButtonsList{
    var buttons = [ButtonTableViewCell]()
    
    init() {
        let row0Item = ButtonTableViewCell()
        let row1Item = ButtonTableViewCell()
        let row2Item = ButtonTableViewCell()
        
        row0Item.titleButton = "Histroy"
        row1Item.titleButton = "Refrigerator"
        row2Item.titleButton = "Shopping List"
        
        row0Item.buttonImage = #imageLiteral(resourceName: "best-salad-7")
        row1Item.buttonImage = #imageLiteral(resourceName: "08COOKING-POTATO2-articleLarge-v2")
        row2Item.buttonImage = #imageLiteral(resourceName: "77d08f50-3ccc-4432-a86d-4dcfdd3d7cd4")
        
        
        buttons.append(row0Item)
        buttons.append(row1Item)
        buttons.append(row2Item)
    }
}
