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
    var images:[UIImage] = []
    let db = Firestore.firestore()
    
    let dataManager = RecipedataManagerClass()
    let fetchData = FetchRecipeImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        dataManager.delegate = self
        dataManager.getReipeDetail()
        
        fetchData.delegate = self
      
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        
        
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.

        if let vc = segue.destination as? RecipeDetailViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                print(recipes[indexPath.row].title)
                if segue.identifier == "Top3" { vc.recipe = recipes[indexPath.row] }
                else { vc.recipe = recipes[indexPath.row + 3] }
            }
        }
     }
     
    
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
            return recipes.count - 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            if recipes.isEmpty {
                return UITableViewCell()
            }
                
            else {
                
//                print("recipe:\(recipes) count: \(recipes.count)")
                
                let cell = (tableView.dequeueReusableCell(withIdentifier: "medal recipe", for: indexPath) as? Number123TableViewCell)!
                
                cell.numberLikeLabel.text = "\(recipes[indexPath.row].like)"
                cell.numberCommentLabel.text = "\(recipes[indexPath.row].cookingTime)"
                cell.titleLabel.text = recipes[indexPath.row].title
//                cell.imageView?.image = images[indexPath.row]

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
        
        
        cell.rankingLabel.text = "No. \(indexPath.row + 3)"
        cell.numLikeLabel.text = "\(recipes[indexPath.row + 3].like)"
        cell.numCommentLabel.text = "\(recipes[indexPath.row + 3].cookingTime)"
        cell.titleLabel.text = recipes[indexPath.row + 3].title
//        cell.imageView?.image = images[indexPath.row + 3]
        
        
        
        // after the number in firebase is over 10 recipes, comment out them.
        
//        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
//        cell.numLikeLabel.text = "\(recipes[indexPath.row + 4].like)"
//        cell.numCommentLabel.text = "\(recipes[indexPath.row + 4].cookingTime)"
//        cell.titleLabel.text = recipes[indexPath.row + 4].title
//        
//        if cell.recipeImageView?.image == nil {
//            dataManager.getImage(imageString: recipes[indexPath.row + 4].image, imageView: cell.recipeImageView)
//        }
        
        
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
        self.recipes = recipes.sorted { $0.like > $1.like }
        var userIDs:[String] = []
        var recipeIDs:[String] = []
        var imageURLs:[String] = []
        
        for recipe in recipes {
            userIDs.append(recipe.userID)
            recipeIDs.append(recipe.recipeID)
            imageURLs.append(recipe.image!)
        }
        
//        fetchData.getImage(uid:userIDs, rid: recipeIDs, imageUrl: imageURLs)
        tableView.reloadData()
    }
    
    func assignImage(image: UIImage, reference: UIImageView) {
        reference.image = image
    }
    
    
}


extension PopularRecipeViewController: ReloadDataDelegate {
    func reloadData(data: [RecipeDetail]) {
        
    }
    
    func reloadImg(img: [UIImage]) {
        self.images = img
    }
    
    
}


