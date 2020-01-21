//
//  CreatorViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-12.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

struct RecipeData{
    static var photo = [UIImage]()
    static var title = [String]()
    static var cookingtime = [String]()
    static var servings = [String]()
}


class CreatorViewController: UIViewController {
    
    @IBOutlet weak var MainPhotoTableView: UITableView!
    @IBAction func UploadPhotoAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func AddIngredients(_ sender: Any) {
        //ingredientList["New item"] = "Amount"
        ingredientList.updateValue("Amount", forKey: "New item")
        MainPhotoTableView.insertRows(at: [IndexPath(row: 0, section: 4)], with: .top)
    }
    @IBAction func SaveData(_ sender: Any) {
        RecipeData.title.append(recipeTitle)
        RecipeData.cookingtime.append(recipeTime)
        RecipeData.servings.append(recipeServings)
        RecipeData.photo.append(mainPhoto)
        print(RecipeData.title)
    }
    
    var imagePicker = UIImagePickerController()
    var mainPhoto = UIImage()
    var recipeTitle = String()
    var recipeTime = String()
    var recipeServings = String()
    var ingredientList: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
}



extension CreatorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            print("hey it is photo upload")
            mainPhoto = photo
        }else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                   mainPhoto = originalPhoto
               }
        dismiss(animated: true, completion: nil)
        MainPhotoTableView?.reloadData()
    }
    
    
}

extension CreatorViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0, 1, 2, 3 :
                return 1
            case 4:
                print(ingredientList.keys.count)
                return ingredientList.keys.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 380
            case 1,2,3,4:
                return 40
            default:
                return UITableView.automaticDimension
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.section{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "mainPhotoCell") as! CreatorPhotoCell
                cell.Mainphoto.image = mainPhoto
                return cell
            case 1:
                let cell : TitleCell = tableView.dequeueReusableCell(withIdentifier: "title") as! TitleCell
                recipeTitle =  cell.TitleTextField.text ?? ""
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "timeNserving") as! TimeNSearvingCell
                recipeTime = cell.TimeTextFieldCell.text ?? ""
                recipeServings = cell.ServingsTextFieldCell.text ?? ""
                return cell
            
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Editingredients") as! EditIngredientsCell
                ingredientList[cell.ingredientTextField.text ?? ""] = cell.AmountTextField.text ?? ""
                print(ingredientList.keys.count)
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients") as! IngredientsCell
                return cell
                
        }
    }
    
    
}

extension CreatorViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        MainPhotoTableView?.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
}





//TableViewCell
class CreatorPhotoCell: UITableViewCell{
    @IBOutlet weak var Mainphoto: UIImageView!
    
}


class TitleCell: UITableViewCell{
    @IBOutlet weak var TitleTextField: UITextField!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TitleTextField.resignFirstResponder()
    }
}


class TimeNSearvingCell: UITableViewCell {
    @IBOutlet weak  var TimeTextFieldCell: UITextField!
    @IBOutlet weak  var ServingsTextFieldCell: UITextField!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TimeTextFieldCell.resignFirstResponder()
        ServingsTextFieldCell.resignFirstResponder()
    }
}

class IngredientsCell: UITableViewCell{
}

class EditIngredientsCell: UITableViewCell{
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var AmountTextField: UITextField!
   
}
