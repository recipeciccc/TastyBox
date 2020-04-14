//
//  FirstTimeUserProfileViewController.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2020-02-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Photos
import RSKImageCropper

class FirstTimeUserProfileTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var familySizeTextField: UITextField!
    
    @IBOutlet weak var cuisineTypeTextField: UITextField!
    
    @IBOutlet weak var userImageButton: UIButton!
    
    var userImage: UIImage?
    
    var familySize = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    var familyPicker = UIPickerView()
    
    var cuisineType = ["Chinese Food", "Japanese Food", "Thai food"]
    
    var cuisinePicker = UIPickerView()
    
    let dataManager = UserdataManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        userNameTextField.text = Auth.auth().currentUser?.displayName
        emailTextField.text = Auth.auth().currentUser?.email
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
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
        
        
        userImage = #imageLiteral(resourceName: "Easy-strawberry-desserts-–-Greek-Yogurt-recipes-–-Valentines-desserts")
        userImageButton.imageView?.contentMode = .scaleAspectFit
        userImageButton.layer.cornerRadius = 0.5 * userImageButton.bounds.size.width
        userImageButton.clipsToBounds = true
        userImage?.withRenderingMode(.alwaysOriginal)
        userImageButton.setBackgroundImage(userImage!, for: .normal)
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

            dataManager.userRegister(userName: userNameTextField.text ?? "", eMailAddress: emailTextField.text ?? "", familySize: Int(familySizeTextField!.text!) ?? 0, cuisineType: cuisineTypeTextField!.text ?? "", accountImage: userImage!)

            let Storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = Storyboard.instantiateViewController(withIdentifier: "Discovery")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func selectPicture() {
           
           PHPhotoLibrary.requestAuthorization { status in
               switch status {
               case .authorized:
                   
                   DispatchQueue.main.async {
                       // 写真を選ぶビュー
                       let pickerView = UIImagePickerController()
                       // 写真の選択元をカメラロールにする
                       // 「.camera」にすればカメラを起動できる
                       pickerView.sourceType = .photoLibrary
                       // デリゲート
                       pickerView.delegate = self
                       // ビューに表示
                       self.present(pickerView, animated: true)
                   }
                   
                   
               case .restricted:
                   break
               case .denied:
                   DispatchQueue.main.async {
                       // アラート表示
                       self.showAlert()
                   }
                   
               default:
                   // place for .notDetermined - in this callback status is already determined so should never get here
                   break
               }
           }
       }
       
       func takeYourImage() {
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               // 写真を選ぶビュー
               let pickerView = UIImagePickerController()
               // 写真の選択元をカメラロールにする
               // 「.camera」にすればカメラを起動できる
               pickerView.sourceType = .camera
               // デリゲート
               pickerView.delegate = self
               // ビューに表示
               self.present(pickerView, animated: true)
           }
       }

       
       /// アラート表示
       func showAlert() {
           
           let alert = UIAlertController(title: "Allow to access your photo library",
                                         message: "This app need to access your photo library. In order to allow that, \ngo to Settings -> Recipe-CICCC -> Photos",
                                         preferredStyle: .alert)
           
           let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           
           // アラートにボタン追加
           alert.addAction(cancelButton)
           
           // アラート表示
           present(alert, animated: true, completion: nil)
       }
    
    
    @IBAction func showChoice(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Your image From...", message: "choose your camera roll or camera", preferredStyle: .actionSheet)
        
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default, handler: { action in
             self.selectPicture()
        })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            self.takeYourImage()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        actionSheet.addAction(cameraRollAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
extension FirstTimeUserProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image : UIImage = info[.originalImage] as! UIImage
        
        imagePicker.dismiss(animated: false, completion: { () -> Void in
            
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            
            imageCropVC.moveAndScaleLabel.text = "Triming"
            imageCropVC.cancelButton.setTitle("Cancel", for: .normal)
            imageCropVC.chooseButton.setTitle("done", for: .normal)
            
            imageCropVC.delegate = self
            
            self.present(imageCropVC, animated: true)
        })
    }
}

extension FirstTimeUserProfileTableViewController:  RSKImageCropViewControllerDelegate {
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        
        //もし円形で画像を切り取りし、その画像自体を加工などで利用したい場合
        if controller.cropMode == .circle {
            UIGraphicsBeginImageContext(croppedImage.size)
            let layerView = UIImageView(image: croppedImage)
            layerView.frame.size = croppedImage.size
            layerView.layer.cornerRadius = layerView.frame.size.width * 0.5
            layerView.clipsToBounds = true
            let context = UIGraphicsGetCurrentContext()!
            layerView.layer.render(in: context)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            let pngData = capturedImage.pngData()!
            //このImageは円形で余白は透過です。
            let png = UIImage(data: pngData)!
            
            
            UserDefaults.standard.set(pngData, forKey: "userImage")
            userImage = png
            userImageButton.setBackgroundImage(png, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //トリミング画面でキャンセルを押した時
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

