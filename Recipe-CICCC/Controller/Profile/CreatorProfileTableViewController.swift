//
//  TableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-19.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreatorProfileTableViewController: UITableViewController {
    
    
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
    var user: User?
    var recipes:[RecipeDetail] = []
    let images: [UIImage] = [#imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "images"), #imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "images")]
    let dataManager = UserdataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "recipeItem")
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "creatorsProfie")
        
        let app = UINavigationBarAppearance()
        
//        dataManager.getUserDetail(id: <#T##String?#>)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3 //4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    
    // about deta the cell has
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creatorsProfie") as? profieTableViewCell)!
            
            cell.imgView.layer.masksToBounds = false
            cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
            cell.imgView.clipsToBounds = true
            cell.delegate = self
            cell.userID = user?.userID
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "number") as? NumOfCreatorhasTableViewCell)!
            
            return cell
        }
            
        else if indexPath.section == 2 {
            let cell : RecipeItemCollectionViewTableViewCell =  (tableView.dequeueReusableCell(withIdentifier: "collectionView") as? RecipeItemCollectionViewTableViewCell)!
            
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        //RecipeListCreator.creatorRecipeLists.remove(at: indexPath.row)
    //        let indexPaths = [indexPath]
    //        tableView.deleteRows(at: indexPaths, with: .automatic)
    //    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 135.0
        }
        else if indexPath.section == 1 { //2 {
            //return 150.0
            //            return 50.0
            return UITableView.automaticDimension
            
        }
        //        } else if indexPath.section == 3 {
        //            return 435 // it needs to be until the end of the screen and if the items inside are more than the border, it should become bigger.
        //        }
        // return tableView.frame.height - 135.0
        
        return self.view.frame.height - ((self.view.frame.origin.y) * -1)
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipePage Segue" {
            if let recipeVC = segue.destination as? RecipeDetailViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let recipe = recipes[indexPath.row]
                    recipeVC.recipe = recipe
                }
            }
        }
    }
    
}


extension CreatorProfileTableViewController: AddingFollowersDelegate {
    func increaseFollower(followerID: String) {
        dataManager.increaseFollower(userID: user!.userID, followerID: followerID)
        tableView.reloadData()
    }
    
}



