//
//  MainSettingsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-26.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class MainSettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titles = ["Profile info", "Notification"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Settings"
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //
        //        if segue.identifier == "accountSwitch" {
        //            if let loginVC = segue.destination as? LoginMainpageViewController {
        //                        do {
        //                            try Auth.auth().signOut()
        //                        } catch {
        //                            print("couldn't sign out")
        //                        }
        //        navigationController?.pushViewController(loginVC, animated: true)
        //
        //        }
    }
    //
    
}

extension MainSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SettingsTableViewCell()
        
        if indexPath.section == 0 {
            cell = (tableView.dequeueReusableCell(withIdentifier: "accountSwitch") as? SettingsTableViewCell)!
            cell.titleLabel.text = "Account Switch"
        }
        else if indexPath.section == 1 {
            
            cell = (tableView.dequeueReusableCell(withIdentifier: "settings") as? SettingsTableViewCell)!
            cell.titleLabel.text = titles[indexPath.row]
            
         
        }
        
           return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            switch indexPath.row {
                
            case 0:
                let settingProfileVC = storyboard?.instantiateViewController(identifier: "settingProfile") as! SettingProifleViewController
                navigationController?.pushViewController(settingProfileVC, animated: true)
                
            case 1:
                let settingNotificationVC = storyboard?.instantiateViewController(identifier: "settingNotification") as! SettingNotificationViewController
                navigationController?.pushViewController(settingNotificationVC, animated: true)
            default:
                break
            }
            
        }
    }
    
}
