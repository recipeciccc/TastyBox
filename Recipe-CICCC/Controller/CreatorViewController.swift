//
//  CreatorViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-12.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

//Globel variables
struct RecipeData{
    static var photo = [UIImage]()
    static var title = [String]()
    static var cookingtime = [String]()
    static var servings = [String]()
}

// ViewController
class CreatorViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()
    var mainPhoto = UIImage()
    var photoList = [UIImage]()
    var preparationText = [String]()
    var recipeTitle = String()
    var recipeTime = String()
    var recipeServings = String()
    var ingredientList = [String]()
    var amountList = [String]()
    var keyboardShow : Bool = false
    var position = CGPoint()
    var stepNumberString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        amountList.append("")
        ingredientList.append("")
        preparationText.append("")
        photoList.append(#imageLiteral(resourceName: "imageFile"))
        self.MainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
               view.addGestureRecognizer(tap)
        //let indexPath = MainTableView.
        //stepNumberString = String(indexPath!.row + 1)
        
        
        
    }
    
    @IBOutlet weak var MainTableView: UITableView!
    
    @IBAction func UploadPhotoAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        position = (sender as AnyObject).convert(CGPoint.zero, to: self.MainTableView)
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func AddIngredients(_ sender: Any) {
        ingredientList.append("")
        amountList.append("")
        MainTableView.insertRows(at: [IndexPath(row: ingredientList.count-1, section: 4)], with: .top)
    }
    
    @IBAction func AddPreparationStep(_ sender: Any) {
        photoList.append(#imageLiteral(resourceName: "imageFile"))
        preparationText.append("")
        MainTableView.insertRows(at: [IndexPath(row: photoList.count-1, section: 6)], with: .top)
    }
    
    @IBAction func SaveData(_ sender: Any) {
        RecipeData.title.append(recipeTitle)
        RecipeData.cookingtime.append(recipeTime)
        RecipeData.servings.append(recipeServings)
        RecipeData.photo.append(mainPhoto)
        print(RecipeData.title)
    }
    
    @IBAction func EditMode(_ sender: UIButton) {
        MainTableView.isEditing = !MainTableView.isEditing
        if MainTableView.isEditing{
            sender.setTitle("Done", for: .normal)
        }else{
            sender.setTitle("Edit", for: .normal)
        }
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
        
        
        if let indexPath = self.MainTableView.indexPathForRow(at: position) {
            let section = indexPath.section
            if section == 0 {
                if let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    mainPhoto = photo
                }else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    mainPhoto = originalPhoto
                }
                
            }else if section == 6 {
                if let photo = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                    photoList[indexPath.row] = photo
                }else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    photoList[indexPath.row] = originalPhoto
                }
            }
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
        case 6:
            return preparationText.count
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
        case 6:
            return 100
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
            stepNumberString = String(indexPath.row + 1)
            cell.stepNumber.text = stepNumberString + " :"
            cell.stepsImageView.image = photoList[indexPath.row]
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients") as! IngredientsCell
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt : IndexPath) {
        tableView.cellForRow(at: didSelectRowAt)?.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section != sourceIndexPath.section{
            return sourceIndexPath
        }else{
            return proposedDestinationIndexPath
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let tempText = preparationText[sourceIndexPath.item]
            preparationText.remove(at: sourceIndexPath.item)
            preparationText.insert(tempText, at: destinationIndexPath.item)
            
            let tempPhoto = photoList[sourceIndexPath.item]
            photoList.remove(at: sourceIndexPath.item)
            photoList.insert(tempPhoto, at: destinationIndexPath.item)
            tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
       let edit: Bool = (indexPath.section == 6 ) ? true : false
        return edit
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           preparationText.remove(at: indexPath.row)
            photoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
}


// TextField
extension CreatorViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //MainTableView?.reloadData()
        textField.resignFirstResponder()
        keyboardShow = false
        return true
    }
}



//TableView Cells
class CreatorPhotoCell: UITableViewCell{
    @IBOutlet weak var Mainphoto: UIImageView!
    
}


class TitleCell: UITableViewCell{
    @IBOutlet weak var TitleTextField: UITextField!
}


class TimeNSearvingCell: UITableViewCell {
    @IBOutlet weak  var TimeTextFieldCell: UITextField!
    @IBOutlet weak  var ServingsTextFieldCell: UITextField!
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
    var imagePicker = UIImagePickerController()
}


