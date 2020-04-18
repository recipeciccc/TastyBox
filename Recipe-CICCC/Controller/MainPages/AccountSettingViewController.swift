//
//  MealPreferenceViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-01.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class AccountSettingViewController: UIViewController {
    
    @IBOutlet weak var oldTitle: UILabel!
    @IBOutlet weak var oldData: UILabel!
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var newData: UITextField!
    var row = Int()
    var OriginalData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
        configureTextField()
        configureTapGesture()
        
    }
    
    private func configureLabel(){
        switch row {
        case 0:
            oldTitle.text = "Profile name:"
            oldData.text = OriginalData
            newTitle.text = "Update profile name:"
        case 1:
            oldTitle.text = "Email:"
            oldData.text = OriginalData
            newTitle.text = "Update email:"
        default:
            print("The row is not exist.")
        }
    }
    private func configureTextField(){
        newData.delegate = self
    }
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(handelTap))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func handelTap(){
        view.endEditing(true)
    }
}

extension AccountSettingViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



