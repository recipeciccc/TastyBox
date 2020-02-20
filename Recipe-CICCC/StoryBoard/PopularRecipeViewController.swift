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
        if section == 0{
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
            case 1:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 29")
            case 2:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 30")
            default:
                break
            }
        
        return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "under no.4", for: indexPath) as? UnderNo4TableViewCell)!
        
        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
        cell.numLikeLabel.text =  "Likes"
        cell.numCommentLabel.text = "comments"
        
        return cell
    }
    
        
    
    
    
}


