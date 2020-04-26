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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        initVariable()
    }
    private func configureDelegate(){
        AddTextField.delegate = self
        ListTableView.delegate = self
        ListTableView.dataSource = self
    }
    private func initVariable(){
    }
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        print("tab add button")
        lists.append(AddTextField.text!)
        AddTextField.text = ""
        ListTableView.reloadData()
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
        }
        else{
            cell.select = false
            cell.item.textColor = #colorLiteral(red: 1, green: 0.6749868989, blue: 0, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
      
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
