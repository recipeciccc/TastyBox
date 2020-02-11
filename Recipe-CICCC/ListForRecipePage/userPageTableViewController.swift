//
//  userPageTableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

class userPageTableViewController: UITableViewController {
    
    let buttons = ButtonsList()

    override func viewDidLoad() {
        super.viewDidLoad()
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3 //4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return 1
//        switch section {
//        case 2:
//            return buttons.buttons.count
//        default:
//            return 1
//        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "Main User Page", for: indexPath) as? mainUserProfileTableViewCell)!

            
            // picture should be much smaller
            // Configure the cell...
            cell.userImageView.layer.masksToBounds = false
//            cell.userImageView.layer.cornerRadius = 112.5
            cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
            cell.userImageView.clipsToBounds = true

            return cell
        }
        else if section == 1 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "show the num", for: indexPath) as? NumberTableViewCell)!

            // Configure the cell...
            
            

            return cell
        }
//        else if section == 3 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeItemForUser", for: indexPath) as? userRecipeItemTableViewCell)!

            // Configure the cell...

            return cell
       // }
       
//        let cell = (tableView.dequeueReusableCell(withIdentifier: "buttons", for: indexPath) as? ButtonTableViewCell)!
//
//            // Configure the cell...
//        let _ = buttons.buttons[indexPath.row]
//        cell.buttonTitleLabel.text =  buttons.buttons[indexPath.row].titleButton
//        cell.buttonImageView.image = buttons.buttons[indexPath.row].buttonImage
        
            //return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 135
        case 1:
            return 60
//        case 2:
//            return 38
        case 2:
            return 560
            
            //return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//
//    }
    
//    func segueToSecondViewController() {
//        let cell = tableView.
//        .performSegue(withIdentifier: "to Shopping List", sender: self.parameters)
//    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buttonTitle = buttons.buttons[indexPath.row].titleButton
//            
//        if buttonTitle == "Shopping List" {
//            let segue = self.performSegue(withIdentifier: "to Shopping List", sender:nil)
//            let distination =  segue.destination as! ShoppingListTableViewController
//            
//        }
    }
    

}
