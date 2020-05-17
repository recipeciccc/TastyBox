//
//  MealPreferenceViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-01.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

protocol SaveChangeDelegate{
    func reloadVC(text:String,index: Int)
}


class AccountSettingViewController: UIViewController {
    
    @IBOutlet weak var oldTitle: UILabel!
    @IBOutlet weak var oldData: UILabel!
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var newData: UITextField!
    var row = Int()
    var OriginalData = String()
    var delegate: SaveChangeDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureLabel()
        configureTextField()
        configureTapGesture()
        configureDelegate()
    }
    private func configureDelegate(){
        let vc = SettingViewController()
        self.delegate = vc
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
    
    @IBAction func saveData(_ sender: Any) {
        if newData.text != nil && newData.text != ""{
            let user = Auth.auth().currentUser
            switch row {
            case 0:
                let changeRequest = user?.createProfileChangeRequest()
                changeRequest?.displayName = newData.text
                changeRequest?.commitChanges(completion: { (error) in
                    print("Erroe is \(error.debugDescription)")
                })
                
                
                self.navigationController?.popViewController(animated: true)
                self.delegate?.reloadVC(text:newData.text ?? "",index: row)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdate"), object: nil)
                //some issues of changing data from popVC
                
            case 1:
                user?.updateEmail(to: newData.text!) { (error) in
                    print("Erroe is \(error.debugDescription)")
                }
                print("save data")
                self.navigationController?.popViewController(animated: true)
                self.delegate?.reloadVC(text:newData.text ?? "",index: row)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataUpdate"), object: nil)
            default:
                print("no row")
            }
        }
    }
}

extension AccountSettingViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



