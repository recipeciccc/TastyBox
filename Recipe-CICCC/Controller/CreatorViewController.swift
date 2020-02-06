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
    
    @IBOutlet weak var MainTableView: UITableView!
    @IBAction func UploadPhotoAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func AddIngredients(_ sender: Any) {
        ingredientList.append("")
        amountList.append("")
        MainTableView.insertRows(at: [IndexPath(row: ingredientList.count-1, section: 4)], with: .top)
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
    var ingredientList = [String]()
    var amountList = [String]()
    var keyboardShow : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
        amountList.append("")
        ingredientList.append("")
    }
    
    @objc func keyboardWillShow(note:NSNotification){
        
        if let newFrame = (note.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            
            if !keyboardShow {
                keyboardShow = true
                MainTableView.contentInset = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            }else{
                MainTableView.contentInset = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
            }
        }
    }
}


//image picker
extension CreatorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            print("hey it is photo upload")
            mainPhoto = photo
        }else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                   mainPhoto = originalPhoto
               }
        dismiss(animated: true, completion: nil)
        MainTableView?.reloadData()
    }
    
    
}

//tableview
extension CreatorViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0, 1, 2, 3, 5:
                return 1
            case 4:
                return ingredientList.count
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 380
            case 1,2,3,4,5:
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "editingredients") as! EditIngredientsCell
                ingredientList[indexPath.row] = cell.ingredientTextField.text!
                amountList[indexPath.row] = cell.AmountTextField.text!
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier:"instructions") as! InstructionTitleCell
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "preparation") as! PreparationCell
                return cell
            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients") as! IngredientsCell
                return cell
                
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt : IndexPath) {
        tableView.cellForRow(at: didSelectRowAt)?.selectionStyle = .none
    }
    
}

extension CreatorViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        MainTableView?.reloadData()
        textField.resignFirstResponder()
        keyboardShow = false
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

class InstructionTitleCell: UITableViewCell{
    
}
class PreparationCell: UITableViewCell{
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stepsImageView: UIImageView!
}
