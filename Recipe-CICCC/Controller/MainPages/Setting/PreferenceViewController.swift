//
//  PreferenceViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-26.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import Crashlytics

class PreferenceViewController: UIViewController{

    @IBOutlet weak var ListTableView: UITableView!
    @IBOutlet weak var AddTextField: UITextField!
    var row = Int()
    var lists = [String]()
    var slectedList = Set<String>()
    var settingManager = SettingManager()
    let uid = Auth.auth().currentUser?.uid
    var checkItem = [String]()
    var AllergicFoodInFirebase = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        if row == 0{
        settingManager.getAllFood(userID: uid!, index: row)
        checkItem = settingManager.getCheckedItemInAllFood(userID: uid!, index: row)
        }
    }
    private func configureDelegate(){
        AddTextField.delegate = self
        ListTableView.delegate = self
        ListTableView.dataSource = self
        settingManager.delegate = self
    }
   
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        print("tab add button")
        if AddTextField.text! != "" && AddTextField.text! != "Add new choice"{
            lists.append(AddTextField.text!)
            settingManager.addAllFood(userID: uid ?? "", allergicFood: AddTextField.text!)
            
            AddTextField.text = ""
            AddTextField.textColor = #colorLiteral(red: 1, green: 0.816192925, blue: 0.350728631, alpha: 1)
            ListTableView.reloadData()
        }
    }
    
    @IBAction func saveData(_ sender: Any) {
        if row == 0{
            removeCheck()
            updateCheckedData()
        }
    }

    func removeCheck(){
        let previousCheckedList = checkItem
        let difference = previousCheckedList.difference(from: lists)
        if difference.count != 0{
            for item in 0...difference.count-1{
                    settingManager.removeCheckedFood(userID: uid ?? "", allergicFood: difference[item])
            }
        }
    }

    func updateCheckedData(){
        for item in checkItem{
            settingManager.addCheckedAllergicFood(userID: uid ?? "", allergicFood: item)
        }
    }
    
    
}

extension PreferenceViewController: UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceItem") as! recipePreferenceTableViewCell
        cell.item.text = lists[indexPath.row]
        
        if  checkItem.contains(cell.item.text ?? ""){
            cell.select = true
            cell.item.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8206811547, blue: 0.4302719235, alpha: 1)
            cell.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
         let cell = tableView.cellForRow(at: indexPath) as! recipePreferenceTableViewCell
        if cell.select != true{
            cell.select = true
            cell.item.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8206811547, blue: 0.4302719235, alpha: 1)
            cell.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            var set_checkItem = Set(checkItem)
            set_checkItem.insert(cell.item.text!)
            checkItem = Array(set_checkItem)
        }
        else{
            cell.select = false
            cell.item.textColor = #colorLiteral(red: 1, green: 0.6749868989, blue: 0, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.accessoryType = UITableViewCell.AccessoryType.none
            var set_checkItem = Set(checkItem)
            set_checkItem.remove(cell.item.text!)
            checkItem = Array(set_checkItem)
        }
      
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return true
    }
    
    
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}


extension PreferenceViewController: getAllergicFoodDelegate{
    func getCheckedData(foodList: [String],index: Int) {
        if index == 0{
            checkItem = foodList
            print("checkItem: \(checkItem)")
            ListTableView.reloadData()
        }
    }
    
    func getFoodData(foodList:[AllergicFoodData],index: Int) {
        if index == 0{
                for item in foodList{
                    lists.append(item.allergicFood)
                }
            ListTableView.reloadData()
        }
    }
}
