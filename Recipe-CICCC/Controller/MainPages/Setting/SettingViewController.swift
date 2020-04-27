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
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var accounttableView: UITableView!
    @IBOutlet weak var preferenceTableVIew: UITableView!
    
    static var accountData = [String]()
    var accountTitle = [String]()
    var preferenceTitle = [String]()
    var allergies = [String]()
    var mealSize = [String]()
    var cuisineType = [String]()
    
    let userManager =  UserdataManager()
    var accountSettingVC = AccountSettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataUpdate"), object: nil)
    
        initDefaultData()
        delegate_dataSource_Setup()
        userDataSetup()
        photoSetup()
        UIviewSetup()
    }
    private func initDefaultData(){
         accountTitle = ["Name:", "Email:"]
         preferenceTitle = ["Allergies or Dislike Ingredients", "Meal Size","Cuisine Type"]
         allergies = ["Peanut","Onion","Egg","Milk"]
         mealSize = ["1-2","3-4","5-6","7-8","9-10","above 10"]
         cuisineType = ["Chinese","Japanese","Korean","Canadian"]
    }
    private func delegate_dataSource_Setup(){
        accounttableView.delegate = self
        accounttableView.dataSource = self
        preferenceTableVIew.delegate = self
        preferenceTableVIew.dataSource = self
        accountSettingVC.delegate = self
    }
    private func UIviewSetup(){
        self.accounttableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.preferenceTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none
        accounttableView.isHidden = true
        preferenceTableVIew.isHidden = true
    }
    private func userDataSetup(){
        let name = Auth.auth().currentUser?.displayName
        let email = Auth.auth().currentUser?.email
        SettingViewController.accountData = ["",""]
        SettingViewController.accountData[0]  = name ?? ""
        SettingViewController.accountData[1]  = email ?? ""
    }
    private func photoSetup(){
        self.photo?.contentMode = .scaleAspectFit
        self.photo.layer.masksToBounds = false
        self.photo.layer.cornerRadius = self.photo.bounds.width / 2
        self.photo.clipsToBounds = true
        userManager.getUserImage(uid: Auth.auth().currentUser!.uid)
        userManager.delegate = self
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
                vc.row = indexPath.row
                vc.lists = allergies
            case 1:
                vc.row = indexPath.row
                vc.lists = mealSize
            case 2:
                vc.row = indexPath.row
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
        SettingViewController.accountData[index] = text
    }
}

extension SettingViewController: getUserDataDelegate{
    func gotUserData(user: User) {
    }
    
    func assignUserImage(image: UIImage) {
        self.photo.image = image
    }
}
