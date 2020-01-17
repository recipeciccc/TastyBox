//
//  SideMenuTableViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-02.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        self.tableView.separatorColor = UIColor.clear
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        
        
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowSetting"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("ShowContact"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("ShowAbout"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("ShowLogout"), object: nil)
        default: break
        }
    }
}
