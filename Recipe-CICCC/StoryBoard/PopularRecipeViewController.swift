//
//  PopularRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class PopularRecipeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var numberLikes = [110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
    var numberComments = [110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
    var titles = ["Courgette and durian salad", "Denjang and fontina cheese salad", "Coriander and duck korma", "Cheese and raisin cupcakes","Cavatelli and nutmeg salad", "Goji berry and arugula salad","Celeriac and spinach wontons", "Lamb and rhubarb pie", "Apricot and cheese cheesecake", "Goat and mushroom madras",]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        let cell = (tableView.dequeueReusableCell(withIdentifier: "medal recipe", for: indexPath) as? Number123TableViewCell)!
            
            
            switch indexPath.row {
            case 0:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 28")
                cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
                cell.numberLikeLabel.text = "\(numberLikes[indexPath.row]) Likes"
                  cell.numberCommentLabel.text = "\(numberComments[indexPath.row]) comments"
                cell.titleLabel.text = titles[indexPath.row]
            case 1:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 29")
                cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
                 cell.numberLikeLabel.text = "\(numberLikes[indexPath.row]) Likes"
                  cell.numberCommentLabel.text = "\(numberComments[indexPath.row]) comments"
                cell.titleLabel.text = titles[indexPath.row]
            case 2:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 30")
                cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
                 cell.numberLikeLabel.text = "\(numberLikes[indexPath.row]) Likes"
                  cell.numberCommentLabel.text = "\(numberComments[indexPath.row]) comments"
                cell.titleLabel.text = titles[indexPath.row]
            default:
                break
            }
        
        return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "under no.4", for: indexPath) as? UnderNo4TableViewCell)!
        
        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
        cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
        cell.numLikeLabel.text =  "\(numberLikes[indexPath.row + 4]) Likes"
        cell.numCommentLabel.text = "\(numberComments[indexPath.row + 4]) comments"
        cell.titleLabel.text = titles[indexPath.row + 3]
        
        return cell
    }
    
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


