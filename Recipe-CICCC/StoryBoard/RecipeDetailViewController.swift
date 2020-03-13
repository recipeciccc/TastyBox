//
//  RecipeDetailViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-12.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // pass the recipe that is RecipeDetail type.
    // retrieve the data of user with RecipeDetail.userID
    var recipe: RecipeDetail?
    var creator: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension RecipeDetailViewController: UITableViewDelegate {
    
}

extension RecipeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 6:
//            return recipe?.instructions.count ?? 0
            return 0
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "mainImage") as? MainImageRecipeTableViewCell)!
            
//            cell.imageVIew.image = Recipe image (now It's string, we need to get image from firebase strage.)
            
            return cell
        case 1:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "title") as? titleTableViewCell)!
            
            cell.titleLabel.text = recipe?.title
            
            return cell
        case 2:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "servingAndTime") as? ServingAndTimeTableViewCell)!
            
            cell.servingLabel.text = "\(recipe?.serving ?? 0) serving"
            cell.timeLabel.text = "\(recipe?.cookingTime ?? 0) mins"
            
            return cell
            
        case 3:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "icons") as? iconItemTableViewCell)!
            
            cell.delegate = self as? iconItemTableViewCellDelegate
            
            return cell
        case 4:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creator") as? creatorCellRecpipeTableViewCell)!
            
            cell.delegate = self as? creatorCellRecpipeTableViewCellDelegate
//            cell.imgCreator.setImage(creator.image, for: .normal)
            cell.labelCreator.setTitle(creator?.name, for: .normal)
            
            return cell
        case 5:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ingredientRecipe") as? IngredientsTableViewCell)!
            
//            cell.ingredientsNameLabel.text = recipe?.ingredients[indexPath.row].name ?? "none"
//            cell.amountIngredientsLabel.text = recipe?.ingredients[indexPath.row].amount ?? "none"
            
            return cell
        case 6:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "instructionsRecipe") as? HowToCookTableViewCell)!
            
//            cell.howToCookLabel.text = recipe?.instructions[indexPath.row].text
//            cell.imageView?.image = recipe?.instructions[indexPath.row].image
//
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160.0
        case 6:
            return 400.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// this extension tell firebase to increase this recipe's like
//
//extension RecipeDetailViewController: iconItemTableViewCellDelegate{
//    func increaseLike() {
//        <#code#>
//    }
//}

// this extension tell firebase to increase this user's follower.

//extension RecipeDetailViewController: creatorCellRecpipeTableViewCellDelegate{
//    func increaseFollower() {
//        <#code#>
//    }
//
//
// }
