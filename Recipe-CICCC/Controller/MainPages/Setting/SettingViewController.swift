//
//  SettingViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-01.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    @IBOutlet weak var accounttableView: UITableView!
    @IBOutlet weak var preferenceTableVIew: UITableView!
    
    let accountTitle = ["Name:", "Email:"]
    static var accountData = ["name","email"]
    
    let preferenceTitle = ["Allergies or Dislike Ingredients", "Meal Size","Cuisine Type"]

    let allergies = ["Peanut","Onion","Egg","Milk"]
    let mealSize = ["1-2","3-4","5-6","7-8","9-10","above 10"]
    let cuisineType = ["Chinese","Japanese","Korean","Canadian"]
    
    var arrayPicker = [[String]]()
    var array = [String]()
    var selectItem = String()
    var pickItem = Bool()
    var arrayRow = Int()
    
    var textfield = UITextField()
    var accountSettingVC = AccountSettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataUpdate"), object: nil)
        accounttableView.delegate = self
        accounttableView.dataSource = self
        preferenceTableVIew.delegate = self
        preferenceTableVIew.dataSource = self
        
        accountSettingVC.delegate = self
        pickItem = false
        
        self.accounttableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.preferenceTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none
        accounttableView.isHidden = true
        preferenceTableVIew.isHidden = true
        let name = Auth.auth().currentUser?.displayName
        let email = Auth.auth().currentUser?.email

        SettingViewController.accountData[0]  = name ?? ""
        SettingViewController.accountData[1]  = email ?? ""
        
        arrayPicker = [allergies,mealSize,cuisineType]
    }
    
    @objc func refresh(){
        self.accounttableView.reloadData()
    }
    
    @objc func closeKeyboard(){
           self.view.endEditing(true)
    }

    @IBAction func accountBtnClick(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.accounttableView.isHidden = !self.accounttableView.isHidden
        }
    }
    
    @IBAction func preferenceBtnClick(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
        self.preferenceTableVIew.isHidden = !self.preferenceTableVIew.isHidden
        }
    }
    

}

extension SettingViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == accounttableView{
        return accountTitle.count
        }
        return preferenceTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == accounttableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! AccountSettingTableViewCell
            cell.accountLabel.text = accountTitle[indexPath.row]
            cell.infoLabel.text =  SettingViewController.accountData[indexPath.row]
            return cell
        }
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell") as! PreferenceTableViewCell
            cell.title.text = preferenceTitle[indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == accounttableView{
            let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "accountSetting") as! AccountSettingViewController
            vc.row = indexPath.row
            
            switch indexPath.row{
            case 0:
                print("select row 0")
                vc.OriginalData =  SettingViewController.accountData[0]
            case 1:
                print("select row 1")
                vc.OriginalData =  SettingViewController.accountData[1]
            default:
                print("No row is selected")
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "PreferenceSetting") as! PreferenceViewController
            
            switch indexPath.row {
            case 0:
                vc.lists = allergies
            case 1:
                vc.lists = mealSize
            case 2:
                vc.lists = cuisineType
            default:
                print("defalt")
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SettingViewController: SaveChangeDelegate{
    func reloadVC(text:String,index: Int) {
        print("delegate is working")
        SettingViewController.accountData[index] = text
    }
}
