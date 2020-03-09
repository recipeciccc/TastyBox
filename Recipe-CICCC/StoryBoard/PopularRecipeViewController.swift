//
//  PopularRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class PopularRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: RecipeDetail?
    var recipes = [RecipeDetail]()
    let db = Firestore.firestore()
    
//
//    var numberLikes = [110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
//    var numberComments = [110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
//    var titles = ["Courgette and durian salad", "Denjang and fontina cheese salad", "Coriander and duck korma", "Cheese and raisin cupcakes","Cavatelli and nutmeg salad", "Goji berry and arugula salad","Celeriac and spinach wontons", "Lamb and rhubarb pie", "Apricot and cheese cheesecake", "Goat and mushroom madras"]
    
    let dataManager = RecipedataManagerClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        dataManager.delegate = self
        dataManager.getReipeDetail()
        
        
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
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


extension PopularRecipeViewController: UITableViewDelegate {
    
}

extension PopularRecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else  {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {

            if recipes.isEmpty {
                return UITableViewCell()
            }

            else {
                
                print("recipe:\(recipes) count: \(recipes.count)")
                
                let cell = (tableView.dequeueReusableCell(withIdentifier: "medal recipe", for: indexPath) as? Number123TableViewCell)!
                
                cell.numberLikeLabel.text = "\(recipes[0].like)"
                cell.numberCommentLabel.text = "\(recipes[0].cookingTime)"
                cell.titleLabel.text = recipes[0].title
                
                if cell.recipeImageView?.image == nil {
                    dataManager.getImage(imageString: recipes[0].image, imageView: cell.recipeImageView)
                }
                
                
                switch indexPath.row {
                case 0:
                    cell.badgeImageView.image = #imageLiteral(resourceName: "Group 28")
                   
                case 1:
                    cell.badgeImageView.image = #imageLiteral(resourceName: "Group 29")
                    
                case 2:
                    cell.badgeImageView.image = #imageLiteral(resourceName: "Group 30")
                    
                default:
                    break
                }
                
                return cell
            }
        }
        
        
        if recipes.isEmpty { return UITableViewCell() }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "under no.4", for: indexPath) as? UnderNo4TableViewCell)!
 
        
        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
        cell.numLikeLabel.text = "\(recipes[1].like)"
        cell.numCommentLabel.text = "\(recipes[1].cookingTime)"
        cell.titleLabel.text = recipes[1].title
        
        if cell.recipeImageView?.image == nil {
            dataManager.getImage(imageString: recipes[1].image, imageView: cell.recipeImageView)
        }
        
        
        print("recipes.count: \(recipes.count)")
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension PopularRecipeViewController: getDataFromFirebaseDelegate {
    func gotData(recipes: [RecipeDetail]) {
        self.recipes = recipes
        tableView.reloadData()
    }
    
    
    func assignImage(image: UIImage, reference: UIImageView) {
        reference.image = image
    }
    
    
}

