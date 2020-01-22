//
//  howToCookList.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-29.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import Foundation

class howToCookList {
     var howToCookList = [HowToCookTableViewCell]()
        
        init() {
            let row0Item = HowToCookTableViewCell()
            let row1Item = HowToCookTableViewCell()
            let row2Item = HowToCookTableViewCell()
            
            row0Item.howToCook = "Position a rack in the lower third of the oven and heat the oven to 350°F. Butter and then flour the bottom and sides of a 6-cup (8-1/2 x 4-1/2-inch or 9 x 5-inch) loaf pan, tapping out any excess flour."
            row1Item.howToCook = "In a large bowl, combine the flour, sugar, baking powder, and salt. Whisk until well blended. Stir in the chocolate chips and dried cherries."
            row2Item.howToCook = "Position a rack in the lower third of the oven and heat the oven to 350°F. Butter and then flour the bottom and sides of a 6-cup (8-1/2 x 4-1/2-inch or 9 x 5-inch) loaf pan, tapping out any excess flour."
        
            
            howToCookList.append(row0Item)
            howToCookList.append(row1Item)
            howToCookList.append(row2Item)
        }
        
    //    func newToDo() -> recipeListCreatorItemTableViewCell {
    //        let item = recipeListCreatorItemTableViewCell()
    //        item.textTest = "11: 30 PM"
    //        creatorRecipeLists.append(item)
    //        return item
    //    }
    //
}
