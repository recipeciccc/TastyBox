//
//  CreatorViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-12.
//  Copyright © 2019 fangyilai. All rights reserved.
//
import UIKit
import Firebase
import FirebaseFirestore
import Crashlytics


//Globel variables
struct RecipeData{
    
    static var mainphoto = [UIImage]()
    static var title = [String]()
    static var cookingtime = [String]()
    static var servings = [String]()
    static var ingredients = [[String]]()
    static var amounts = [[String]]()
    static var stepPhotos = [[UIImage]]()
    static var stepTexts = [[String]]()
}

// ViewController
class CreatorViewController: UIViewController {
    
    //MARK: properties
    let db = Firestore.firestore()
    
    var move = false
    var imagePicker = UIImagePickerController()
    var mainPhoto:UIImage?
    var photoList = [UIImage]()
    
    var preparationText = [String]()
    var recipeTitle = String()
    var recipeTime = String()
    var recipeServings = String()
    var ingredientList = [String]()
    var amountList = [String]()
    var genres: [String] = []
    var imagesLabelsSelected:[String] = []
    var imagesLabels: [String] = []
    var isVIP = false
    
    var position = CGPoint()
    var tableviewHeight = CGFloat()
    var contentOffset = CGFloat()
    var numberPreparation = 1
    let genreVC = MealTypeSelectViewController()
    var keyboardHeight = CGFloat()
    var isKeyboardOpen = false
    var textFieldSelected = false
    var selectedIndexPath: IndexPath?
    
    var tap: UITapGestureRecognizer?
    
    //MARK: view cicles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton.isEnabled = false
        tableviewHeight = MainTableView.frame.origin.y
        imagePicker.delegate = self
        amountList.append("")
        ingredientList.append("")
        preparationText.append("")
        photoList.append(#imageLiteral(resourceName: "imageFile"))
        MainTableView.isEditing = false
        self.MainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.navigationController!.navigationBar.tintColor = UIColor.orange
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard:))
        //        self.view.addGestureRecognizer(tap!)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap!)
        self.view.isUserInteractionEnabled = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //MARK: IBOutlet
    @IBOutlet weak var MainTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: decide position
    @IBAction func UploadPhotoAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        position = (sender as AnyObject).convert(CGPoint.zero, to: self.MainTableView)
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func StepTextViewPosition(_ sender: UIButton) {
        position = (sender as AnyObject).convert(CGPoint.zero, to: self.MainTableView)
        sender.isHidden = true
        print(sender.isHidden)
    }
    
    //MARK: add cells
    
    @IBAction func AddIngredients(_ sender: Any) {
        ingredientList.append("")
        amountList.append("")
        MainTableView.insertRows(at: [IndexPath(row: ingredientList.count-1, section: 4)], with: .bottom)
        
        let cell = (self.MainTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as! EditIngredientsCell)
        //        self.view.frame.origin.y -= (cell.frame.height)
        let ingredientRow = IndexPath(row: ingredientList.count-1, section: 4)
        
        // 2
        if isKeyboardOpen {
            self.MainTableView.scrollToRow(at: ingredientRow, at: .bottom, animated: true)
            
        } else {
            self.MainTableView.scrollToRow(at: ingredientRow, at: .middle, animated: true)
        }
    }
    
    @IBAction func AddPreparationStep(_ sender: Any) {
        photoList.append(#imageLiteral(resourceName: "imageFile"))
        preparationText.append("")
        MainTableView.insertRows(at: [IndexPath(row: photoList.count-1, section: 6)], with: .top)
        
        let cell = (self.MainTableView.cellForRow(at: IndexPath(row: 0, section: 6)) as! PreparationCell)
        //        self.view.frame.origin.y -= (cell.frame.height)
        //        self.MainTableView.contentOffset.y += (cell.frame.height) + 51.0
        numberPreparation += 1
        
        let preparationRow =  IndexPath(row: photoList.count-1, section: 6)
        
        // 2
        self.MainTableView.scrollToRow(at: preparationRow, at: .bottom, animated: true)
        
    }
    
    
    @IBAction func EditMode(_ sender: UIButton) {
        
        MainTableView.isEditing = !MainTableView.isEditing
        if MainTableView.isEditing{
            sender.setTitle("Done", for: .normal)
        }else{
            
            sender.setTitle("Edit", for: .normal)
        }
    }
    
    // MARK: keyboard method
    @objc func keyboardWillShow(_ notification: Notification) {
        self.contentOffset =  self.MainTableView.contentOffset.y
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.keyboardHeight = keyboardHeight
            
            
            if self.isKeyboardOpen == false {
                
                if self.selectedIndexPath != nil {
                    
                    if self.selectedIndexPath?.section == 1 {
                        
                        self.MainTableView.scrollToRow(at: self.selectedIndexPath!, at: .middle, animated: true)
                        self.view.frame.origin.y -= keyboardHeight
                        
                        
                    } else {
                        self.MainTableView.scrollToRow(at: self.selectedIndexPath!, at: .middle, animated: true)
                        self.view.frame.origin.y -= keyboardHeight
                    }
                    self.isKeyboardOpen = true
                }
                
                //                    self.isKeyboardOpen = true
            }
            
        }
        //        })
    }
    
    @objc func dismissKeyBoard() {
        
        // 2
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.y = 0
            let preparationRow =  IndexPath(row: self.photoList.count-1, section: 6)
            self.MainTableView.scrollToRow(at: preparationRow, at: .bottom, animated: true)
            self.view.endEditing(true)
        })
     
        isKeyboardOpen = false
        
    }
    
    
    //MARK: prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MealTypeSelectViewController {
            vc.delegate = self
            vc.tagsSelected = self.genres
            vc.imageLabelingTagsSelected = self.imagesLabelsSelected
            vc.imageLabelingTags = imagesLabels
            vc.image = mainPhoto
            vc.isHighlightVIP = isVIP
            
            self.view.endEditing(true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: upload recipe
extension CreatorViewController{

    
    //MARK: Save Recipes
    @IBAction func SaveData(_ sender: Any) {
        print(genres)
        MainTableView.reloadData()
        
        
        let cgref = mainPhoto?.cgImage
        let cim = mainPhoto?.ciImage
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let rid = self.db.collection("recipe").document().documentID
        
        
        
        if recipeTitle == "" || (cgref == nil && cim == nil){
            let alertController = UIAlertController(title: "Error:", message: "Please enter recipe title and upload your main photo.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        }else{
            
            RecipeData.mainphoto.append(mainPhoto!)
            RecipeData.title.append(recipeTitle)
            RecipeData.cookingtime.append(recipeTime)
            RecipeData.servings.append(recipeServings)
            RecipeData.ingredients.append(ingredientList)
            RecipeData.amounts.append(amountList)
            RecipeData.stepPhotos.append(photoList)
            RecipeData.stepTexts.append(preparationText)
            
            print(RecipeData.title,RecipeData.cookingtime,RecipeData.servings, RecipeData.ingredients, RecipeData.amounts,RecipeData.stepTexts)
            
            self.uploadImage(mainPhoto!,uid,rid) { (url) in
                self.recipeUpload(uid,rid,url!.absoluteString)
                self.uploadGenres(genres: self.genres, ingredients: self.ingredientList, imageLabels: self.imagesLabelsSelected, rid: rid)
                self.ingredientUpload(rid)
                self.commentUpload(rid) // we may not need it
            }
            
            for index in 0..<photoList.count{
                self.uploadInstructionImage(photoList[index], uid, rid, index) { (url) in
                    self.instructionUpload(rid,index,url!.absoluteString)
                }
            }
            navigationController?.popViewController(animated: true)
            //}
        }
    }
    
    func recipeUpload(_ uid:String,_ rid:String, _ url:String){
        let recipeData = ["userID": uid,
                          "image":url as Any,
                          "title":self.recipeTitle,
                          "cookingTime":Int(self.recipeTime) as Any,
                          "serving":Int(self.recipeServings) as Any,
                          "recipeID":rid,
                          "like":0,
                          "time":Timestamp()] as [String : Any]
        self.db.collection("recipe").document(rid).setData(recipeData, merge: true) { (err) in
            if err != nil{
                print(err?.localizedDescription as Any)
            }else{
                print("Successfully set data")
                //                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func ingredientUpload(_ rid:String){
        for index in 0..<self.ingredientList.count{
            let ingredientData = ["ingredient": self.ingredientList[index],"amount": self.amountList[index]]
            let ref = self.db.collection("recipe").document(rid)
            ref.collection("ingredient").document().setData(ingredientData) { (err) in
                if err != nil{
                    print(err?.localizedDescription as Any)
                }else{
                    print("Successfully set ingredient data")
                    //                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            let dictonary = ["ingredient": [self.ingredientList[index]:true]]
            
            self.db.collection("ingredient").document("ingredient").setData(dictonary, merge: true) { (err) in
                if err != nil{
                    print(err?.localizedDescription as Any)
                }else{
                    print(dictonary)
                    print("Successfully set ingredient docement data")
                }
            }
        }
    }
    
    func commentUpload(_ rid: String){
        let commentData = ["time":Timestamp(),"text":"","user":""] as [String : Any]
        let ref = self.db.collection("recipe").document(rid)
        ref.collection("comment").document().setData(commentData) { (err) in
            if err != nil{
                print(err?.localizedDescription as Any)
            }else{
                print("Successfully set comment data")
                //                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    func instructionUpload(_ rid:String, _ index: Int, _ url:String){
        
        let instructionData = ["text": self.preparationText[index],"image": url,"index":index] as [String : Any]
        let ref = self.db.collection("recipe").document(rid)
        ref.collection("instruction").document(String(index)).setData(instructionData) { (err) in
            if err != nil{
                print(err?.localizedDescription as Any)
            }else{
                print("Successfully set instruction data")
                //                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func uploadInstructionImage(_ image:UIImage, _ uid:String, _ rid:String, _ index: Int, completion: @escaping((_ url: URL?)->())){
        
        let storageRef = Storage.storage().reference().child("user/\(uid)/RecipePhoto/\(rid)/\(index)")
        guard let imgData = image.jpegData(compressionQuality: 0.75) else{return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imgData, metadata: metaData){ (metaData, error) in
            if error == nil, metaData != nil{
                print("success")
                storageRef.downloadURL{ (url, err) in
                    completion(url)
                }
            }else{
                print("error in save instruction images")
                completion(nil)
            }
        }
    }
    
    func uploadImage(_ image:UIImage, _ uid:String, _ rid:String, completion: @escaping((_ url: URL?)->())){
        
        let storageRef = Storage.storage().reference().child("user/\(uid)/RecipePhoto/\(rid)/\(rid)")
        guard let imgData = image.jpegData(compressionQuality: 0.75) else{return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imgData, metadata: metaData){ (metaData, error) in
            if error == nil, metaData != nil{
                print("success")
                storageRef.downloadURL{ (url, err) in
                    completion(url)
                }
            }else{
                print("error in save image")
                completion(nil)
            }
            
        }
    }
    
    func uploadGenres(genres: [String], ingredients: [String], imageLabels: [String], rid: String) {
        var recipeGenres: [String : [String: Bool]] = [:]
        var dictionary: [String:Bool] = [:]
        
        for genre in genres {
            dictionary[genre] = true
        }
        
        for genre in imageLabels {
            dictionary[genre] = true
        }
        
        for ingredient in ingredients {
            dictionary[ingredient.capitalized] = true
        }
        
        recipeGenres["genres"] = dictionary
        
        self.db.collection("recipe").document(rid).setData(recipeGenres, merge: true) { (err) in
            if err != nil{
                print(err?.localizedDescription as Any)
            }else{
                print(genres)
                print("Successfully set genres")
            }
        }
        
        self.db.collection("genres").document("genre").setData(recipeGenres, merge: true) { (err) in
            if err != nil{
                print(err?.localizedDescription as Any)
            }else{
                print(genres)
                print("Successfully set genres document data")
            }
        }
        
        if isVIP == true {
            self.db.collection("recipe").document(rid).setData(
                ["VIP": true]
            , merge: true) { (err) in
                if err != nil{
                    print(err?.localizedDescription as Any)
                }else{
                    print(genres)
                    print("Successfully set VIP")
                }
            }
            
            let uid = (Auth.auth().currentUser?.uid)!
            
            //        db.collection("user").document(uid).collection("proifle").document("info").setData([
            db.collection("user").document(uid).setData([
                
                "VIPRecipes": [rid: true]
                
            ], merge: true) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("user VIP successfully written!")
                }
            }
        }
    }
}



//MARK: image picker
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
                print(photoList)
            }
        }
        dismiss(animated: true, completion: nil)
        MainTableView?.reloadData()
    }
}


//MARK: tableview delegate and datasorce
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
//        case 0:
//            return 350
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
            
            cell.TitleTextField.tag = 100
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "timeNserving") as! TimeNSearvingCell
            recipeTime = cell.TimeTextFieldCell.text ?? ""
            recipeServings = cell.ServingsTextFieldCell.text ?? ""
            
            cell.TimeTextFieldCell.tag = 220 + indexPath.row
            cell.ServingsTextFieldCell.tag = 230 + indexPath.row
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editingredients") as! EditIngredientsCell
            
            if tableView.isEditing == true {
                if move == true {
                    cell.ingredientTextField.text = ingredientList[indexPath.row]
                    cell.AmountTextField.text = amountList[indexPath.row]
                    
                }else{
                    ingredientList[indexPath.row] = cell.ingredientTextField.text ?? ""
                    amountList[indexPath.row] = cell.AmountTextField.text ?? ""
                }
            }
            else{
                ingredientList[indexPath.row] = cell.ingredientTextField.text ?? ""
                amountList[indexPath.row] = cell.AmountTextField.text ?? ""
            }
            
            cell.ingredientTextField.tag = 340 + indexPath.row
            cell.AmountTextField.tag = 350 + indexPath.row
            
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier:"instructions") as! InstructionTitleCell
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "preparation") as! PreparationCell
            cell.stepNumber.text = String(indexPath.row + 1) + " :"
            cell.stepsImageView.image = photoList[indexPath.row]
            
            
            cell.textView.tag = 460 + indexPath.row
            
            if tableView.isEditing == true {
                preparationText[indexPath.row] =  cell.textView.text
                // cell.textView.text = preparationText[indexPath.row]
                print(preparationText)
            }
            if cell.StepButton.isHidden {
                cell.StepButton.isHidden = false
            }
            return cell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredients") as! IngredientsCell
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    }
    
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section != sourceIndexPath.section{
            return sourceIndexPath
        }else{
            return proposedDestinationIndexPath
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let edit: Bool = indexPath.section == 6 || indexPath.section == 4 ? true : false
        return edit
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        move = true
        if sourceIndexPath.section == 4{
            let tempIngredient = ingredientList[sourceIndexPath.item]
            ingredientList.remove(at: sourceIndexPath.item)
            ingredientList.insert(tempIngredient, at: destinationIndexPath.item)
            
            let tempAmount = amountList[sourceIndexPath.item]
            amountList.remove(at: sourceIndexPath.item)
            amountList.insert(tempAmount, at: destinationIndexPath.item)
        }
        
        
        if sourceIndexPath.section == 6{
            let tempPreparation = preparationText[sourceIndexPath.item]
            preparationText.remove(at: sourceIndexPath.item)
            preparationText.insert(tempPreparation, at: destinationIndexPath.item)
            print(preparationText)
            let tempPhoto = photoList[sourceIndexPath.item]
            photoList.remove(at: sourceIndexPath.item)
            photoList.insert(tempPhoto, at: destinationIndexPath.item)
        }
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if indexPath.section == 4{
                ingredientList.remove(at: indexPath.item)
                amountList.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //  tableView.reloadData()
            }
            else if indexPath.section == 6{
                preparationText.remove(at: indexPath.item)
                photoList.remove(at: indexPath.item)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                //  tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}



extension CreatorViewController: UITextFieldDelegate, UITextViewDelegate{
    
    //MARK: TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        move = false
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        let cell = textField.superview?.superview as! UITableViewCell
        let tableView = cell.superview as! UITableView
        
        let textFieldIndexPath = tableView.indexPath(for: cell)
        selectedIndexPath = textFieldIndexPath
    }
    
    //MARK: Text view
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Please press [return] after the last character to finish editing." {
            textView.text = ""
            textView.textColor = UIColor.black
            
            if selectedIndexPath == nil {
                let cell = textView.superview?.superview as! UITableViewCell
                let tableView = cell.superview as! UITableView
                
                let textFieldIndexPath = tableView.indexPath(for: cell)
                selectedIndexPath = textFieldIndexPath
                
                UITextView.animate(withDuration: 0.4, animations: {
                    self.MainTableView.scrollToRow(at: self.selectedIndexPath!, at: .bottom, animated: true)
                    self.view.frame.origin.y -= self.keyboardHeight
                })
                
                
                self.isKeyboardOpen = true
            }
            
            let cell = textView.superview?.superview as! UITableViewCell
            let tableView = cell.superview as! UITableView
            
            let textFieldIndexPath = tableView.indexPath(for: cell)
            selectedIndexPath = textFieldIndexPath
            
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let indexPath = self.MainTableView.indexPathForRow(at: position) {
            //        if let indexPath
            if indexPath.section == 6 {
                preparationText[indexPath.row] = textView.text
                print(indexPath)
                print(preparationText)
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //        MainTableView.reloadData()
        if textView.text == "" {
            textView.text = "Please press [return] after the last character to finish editing."
            textView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        if  self.MainTableView.contentOffset.y > 0 {
            if numberPreparation == 1 {
                contentOffset = 51.0
                self.MainTableView.contentOffset.y = contentOffset
            }
        }
        
    }
    
    
}

//MARK: genre delegate
extension CreatorViewController: MealTypeSelectViewControllerDelegate {
    func assignGenres(genres: [String], imagesLabels: [String], imagesLabelsSelected: [String], isVIP: Bool) {
        
        self.genres = genres
        self.isVIP = isVIP
        self.imagesLabelsSelected = imagesLabelsSelected
        self.imagesLabels = imagesLabels
        self.saveButton.isEnabled = true
    }
    
}




//MARK: TableView Cells
class CreatorPhotoCell: UITableViewCell{
    @IBOutlet weak var Mainphoto: UIImageView!
}


class TitleCell: UITableViewCell{
    @IBOutlet weak var TitleTextField: UITextField!
    
    
}


class TimeNSearvingCell: UITableViewCell {
    @IBOutlet weak  var TimeTextFieldCell: UITextField!
    @IBOutlet weak  var ServingsTextFieldCell: UITextField!
    
    override func awakeFromNib() {
        self.TimeTextFieldCell.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        self.ServingsTextFieldCell.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
    }
    
    // 2
    @objc func tapDone(sender: Any) {
        self.TimeTextFieldCell.endEditing(true)
        self.ServingsTextFieldCell.endEditing(true)
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
    @IBOutlet weak var StepButton: UIButton!
    var imagePicker = UIImagePickerController()
    
    override func awakeFromNib() {
        self.textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
    }
    
    // 2
    @objc func tapDone(sender: Any) {
        self.textView.endEditing(true)
    }
}

//MARK: textview extension
extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
//MARK: TextField extension
extension UITextField {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
