//
//  PreferenceViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-26.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class PreferenceViewController: UIViewController{

    @IBOutlet weak var ListTableView: UITableView!
    @IBOutlet weak var AddTextField: UITextField!
    
    var lists = [String]()
    var slectedList = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
    }
    private func configureDelegate(){
        AddTextField.delegate = self
        ListTableView.delegate = self
        ListTableView.dataSource = self
    }
   
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        print("tab add button")
        if AddTextField.text! != "" && AddTextField.text! != "Add new choice"{
            lists.append(AddTextField.text!)
            AddTextField.text = ""
            AddTextField.textColor = #colorLiteral(red: 1, green: 0.816192925, blue: 0.350728631, alpha: 1)
            ListTableView.reloadData()
        }
        print(slectedList)
    }
    
}

extension PreferenceViewController: UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceItem") as! recipePreferenceTableViewCell
        cell.item.text = lists[indexPath.row]
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
            slectedList.insert(cell.item.text!)
        }
        else{
            cell.select = false
            cell.item.textColor = #colorLiteral(red: 1, green: 0.6749868989, blue: 0, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.accessoryType = UITableViewCell.AccessoryType.none
            slectedList.remove(cell.item.text!)
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
