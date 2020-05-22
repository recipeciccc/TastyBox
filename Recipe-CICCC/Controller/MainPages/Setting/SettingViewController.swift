//
//  SettingViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-01.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Photos
import RSKImageCropper
import Crashlytics

class SettingViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var accounttableView: UITableView!
    @IBOutlet weak var preferenceTableVIew: UITableView!
    @IBOutlet weak var DoneBtn: UIBarButtonItem!
    @IBOutlet weak var photoBtn: UIButton!
    
    static var accountData = [String]()
    var accountTitle = [String]()
    var preferenceTitle = [String]()
    var allergies = [String]()
    var mealSize = [String]()
    var cuisineType = [String]()
    var userImage = UIImage()
    let userManager =  UserdataManager()
    var accountSettingVC = AccountSettingViewController()
    let settingManager = SettingManager()
    //  let allergicData  = allergicFoodData?.self
    
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "dataUpdate"), object: nil)
        
        initDefaultData()
        delegate_dataSource_Setup()
        userDataSetup()
        photoSetup()
        UIviewSetup()
    }
    private func initDefaultData(){
        accountTitle = ["Name:", "Email:"]
        preferenceTitle = ["Allergies or Dislike Ingredients", "Meal Size","Cuisine Type"]
        allergies = ["Peanut","Onion","Egg","Milk"]
        mealSize = ["1-2","3-4","5-6","7-8","9-10","above 10"]
        cuisineType = ["Chinese","Japanese","Korean","Canadian"]
    }
    
    private func delegate_dataSource_Setup(){
        accounttableView.delegate = self
        accounttableView.dataSource = self
        preferenceTableVIew.delegate = self
        preferenceTableVIew.dataSource = self
        accountSettingVC.delegate = self
        userManager.delegate = self
    }
    private func UIviewSetup(){
        self.scrollView.contentSize = self.view.frame.size
        self.accounttableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.preferenceTableVIew.separatorStyle = UITableViewCell.SeparatorStyle.none
        accounttableView.isHidden = true
        preferenceTableVIew.isHidden = true
        DoneBtn.isEnabled = false
        DoneBtn.title = ""
    }
    private func userDataSetup(){
        let name = Auth.auth().currentUser?.displayName
        let email = Auth.auth().currentUser?.email
        SettingViewController.accountData = ["",""]
        SettingViewController.accountData[0]  = name ?? ""
        SettingViewController.accountData[1]  = email ?? ""
    }
    private func photoSetup(){
        self.photoBtn?.contentMode = .scaleAspectFit
        self.photoBtn.layer.masksToBounds = false
        self.photoBtn.layer.cornerRadius = self.photoBtn.bounds.width / 2
        self.photoBtn.clipsToBounds = true
        userManager.getUserImage(uid: uid)
        userManager.delegate = self
    }
    
    @objc func refresh(){
        self.accounttableView.reloadData()
    }
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    
    @IBAction func ImageEditingIsDone(_ sender: Any) {
        userManager.updateUserImage(Img: userImage)
        DoneBtn.isEnabled = false
        DoneBtn.title = ""
    }
    
    @IBAction func showChoice(_ sender: Any) {
        DoneBtn.isEnabled = true
        DoneBtn.title = "Done"
        let actionSheet = UIAlertController(title: "Your image From...", message: "choose your camera roll or camera", preferredStyle: .alert)
        
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
    
    
    @IBAction func accountBtnClick(_ sender: Any) {
        
        UIView.transition(with: self.accounttableView, duration: 0.3, options: [UIView.AnimationOptions.transitionFlipFromTop], animations: {
            self.accounttableView.isHidden = !self.accounttableView.isHidden
            
            self.scrollView.contentSize.height = self.accounttableView.isHidden ? self.view.frame.size.height + self.accounttableView.frame.size.height : self.view.frame.size.height - self.accounttableView.frame.size.height
            
        }, completion: nil)
        
        //        UIView.animate(withDuration: 0.3) {
        //
        //        }
    }
    
    
    
    
    @IBAction func preferenceBtnClick(_ sender: Any) {
        //        UIView.animate(withDuration: 0.3) {
        //        self.preferenceTableVIew.isHidden = !self.preferenceTableVIew.isHidden
        //        }
        UIView.transition(with: self.preferenceTableVIew, duration: 0.3, options: [UIView.AnimationOptions.transitionFlipFromTop], animations: {
            
            self.preferenceTableVIew.isHidden = !self.preferenceTableVIew.isHidden
            
            self.scrollView.contentSize.height = self.preferenceTableVIew.isHidden ? self.view.frame.size.height + self.preferenceTableVIew.frame.size.height : self.view.frame.size.height - self.preferenceTableVIew.frame.size.height
            
        }, completion: { isFinish in
            
        
            let contentOffset = CGPoint(x: self.scrollView.contentSize.width - self.view.frame.size.width, y: 0)
            if !self.preferenceTableVIew.isHidden {
                self.scrollView.setContentOffset(contentOffset, animated: true)
            }
        })
    }
    
    
    func selectPicture() {
           
           PHPhotoLibrary.requestAuthorization { status in
               switch status {
               case .authorized:
                   
                   DispatchQueue.main.async {
                       let pickerView = UIImagePickerController()
                       pickerView.sourceType = .photoLibrary
                       pickerView.delegate = self
                       
                       self.present(pickerView, animated: true)
                   }
                   
                   
               case .restricted:
                   break
               case .denied:
                   DispatchQueue.main.async {
                       self.showAlert()
                   }
                   
               default:
                   break
               }
           }
       }
       
       func takeYourImage() {
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
               let pickerView = UIImagePickerController()
               pickerView.sourceType = .camera
               pickerView.delegate = self
               self.present(pickerView, animated: true)
           }
       }

       func showAlert() {
           let alert = UIAlertController(title: "Allow to access your photo library",
                                         message: "This app need to access your photo library. In order to allow that, \ngo to Settings -> Recipe-CICCC -> Photos",
                                         preferredStyle: .alert)
           
           let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           
           alert.addAction(cancelButton)
          
           present(alert, animated: true, completion: nil)
       }
    

}

extension SettingViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == accounttableView{
        return accountTitle.count
        }
        return preferenceTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == accounttableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! AccountSettingTableViewCell
            cell.accountLabel.text = accountTitle[indexPath.row]
            cell.infoLabel.text =  SettingViewController.accountData[indexPath.row]
            return cell
        }
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell") as! PreferenceTableViewCell
            cell.title.text = preferenceTitle[indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == accounttableView{
            let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "accountSetting") as! AccountSettingViewController
            vc.row = indexPath.row
            
            switch indexPath.row{
            case 0:
                print("select row 0")
                vc.OriginalData =  SettingViewController.accountData[0]
            case 1:
                print("select row 1")
                vc.OriginalData =  SettingViewController.accountData[1]
            default:
             
                print("No row is selected")
            }
            guard self.navigationController?.topViewController == self else { return }

            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "PreferenceSetting") as! PreferenceViewController
            
            switch indexPath.row {
            case 0:
                vc.row = indexPath.row
              //  vc.lists = allergies
                
        
            case 1:
                vc.row = indexPath.row
                vc.lists = mealSize
            case 2:
                vc.row = indexPath.row
                vc.lists = cuisineType
            default:
                print("defalt")
            }
            guard self.navigationController?.topViewController == self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SettingViewController: SaveChangeDelegate{
    func reloadVC(text:String,index: Int) {
        SettingViewController.accountData[index] = text
    }
}

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image : UIImage = info[.originalImage] as! UIImage
        
        imagePicker.dismiss(animated: false, completion: { () -> Void in
            
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
            
            imageCropVC.moveAndScaleLabel.text = "Triming"
            imageCropVC.cancelButton.setTitle("Cancel", for: .normal)
            imageCropVC.chooseButton.setTitle("Done", for: .normal)
            
            imageCropVC.delegate = self
            
            self.present(imageCropVC, animated: true)
        })
    }
}

extension SettingViewController:  RSKImageCropViewControllerDelegate {
    
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
            photoBtn.setBackgroundImage(png, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    
    //トリミング画面でキャンセルを押した時
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension SettingViewController: getUserDataDelegate {
    func gotUserData(user: User) {
    }
    
    func assignUserImage(image: UIImage) {
        self.userImage = image
        self.photoBtn.setBackgroundImage(image, for: .normal)
    }
    
}


