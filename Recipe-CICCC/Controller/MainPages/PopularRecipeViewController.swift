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
    var images:[Int:UIImage] = [:]
    let db = Firestore.firestore()
    
    let dataManager = RecipedataManagerClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataManager.delegate = self
        dataManager.getReipeDetail()
        
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
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
                                
                let cell = (tableView.dequeueReusableCell(withIdentifier: "medal recipe", for: indexPath) as? Number123TableViewCell)!
                cell.selectionStyle = .none
                
                cell.numberLikeLabel.text = "\(recipes[indexPath.row].like)"
                cell.titleLabel.text = recipes[indexPath.row].title
                cell.recipeImageView.image = images[indexPath.row]
               
                
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
        
        cell.selectionStyle = .none
        
        cell.rankingLabel.text = "No. \(indexPath.row + 3)"
        cell.numLikeLabel.text = "\(recipes[indexPath.row + 3].like)"
        cell.titleLabel.text = recipes[indexPath.row + 3].title
        cell.recipeImageView.image = images[indexPath.row + 3]
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let recipeVC = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(identifier: "detailvc") as! RecipeDetailViewController
        
        if indexPath.section == 0 {
            let cell = (tableView.cellForRow(at: indexPath) as? Number123TableViewCell)!
            recipeVC.recipe = self.recipes[indexPath.row]
            recipeVC.mainPhoto = cell.recipeImageView!.image!
        }
        else if indexPath.section == 1 {
            let cell = (tableView.cellForRow(at: indexPath) as? UnderNo4TableViewCell)!
            recipeVC.recipe = self.recipes[indexPath.row + 3]
            recipeVC.mainPhoto = cell.recipeImageView!.image!
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(recipeVC, animated: true)
    }
    
}

extension PopularRecipeViewController: getDataFromFirebaseDelegate {
    func assignImage(image: UIImage, index: Int) {
         self.images[index] = image
        self.tableView.reloadData()
    }
    
    func gotData(recipes: [RecipeDetail]) {
        self.recipes = recipes.sorted { $0.like > $1.like }
         
        recipes.enumerated().map {
            dataManager.getImage(rid: $0.1.recipeID, uid: $0.1.userID, index: $0.0)
        }
        
        tableView.reloadData()
    }
    
   
}



