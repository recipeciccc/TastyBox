//
//  FirstTimeUserProfileViewController.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2020-02-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit

class FirstTimeUserProfileTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var familySizeTextField: UITextField!
    
    @IBOutlet weak var cuisineTypeTextField: UITextField!
    
    var familySize = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    var familyPicker = UIPickerView()
    
    var cuisineType = ["Chinese Food", "Japanese Food", "Thai food"]
    
    var cuisinePicker = UIPickerView()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        familyPicker.delegate = self
        familyPicker.dataSource = self
        
        cuisinePicker.delegate = self
        cuisinePicker.dataSource = self
        cuisinePicker.tag = 11
        familyPicker.tag = 10
        
        familySizeTextField.inputView = familyPicker
        cuisineTypeTextField.inputView = cuisinePicker
        
        familySizeTextField.tag = 100
        cuisineTypeTextField.tag = 200
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag==10) {
            return familySize.count
        }
        else {
            return cuisineType.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag==10) {
            return familySize[row]
        }
        else {
            return cuisineType[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView.tag==10) {
            let familySizeTextField = self.view?.viewWithTag(100) as? UITextField
            familySizeTextField?.text = familySize[row]
        }
        else {
            let cuisineTypeTextField = self.view?.viewWithTag(200) as? UITextField
            cuisineTypeTextField?.text = cuisineType[row]
        }
    }
    
    @IBAction func finishFirstTimeProfile(_ sender: Any) {
        if userNameTextField.text == "" || emailTextField.text == "" || familySizeTextField.text == "" || cuisineTypeTextField.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter simple info to have better using experience", preferredStyle: .alert)
                
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
                
            present(alertController, animated: true, completion: nil)
        } else {
            let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
