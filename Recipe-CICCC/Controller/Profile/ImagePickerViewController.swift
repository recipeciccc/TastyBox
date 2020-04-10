//
//  ImagePickerViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-09.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            // デフォルトの画像を表示する
            imageView.image = UIImage(named: "no_image.png")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectPicture(_ sender: UIButton) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
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
    }
    
    @IBAction func deletePicture(_ sender: UIButton) {
        // アラート表示
        showAlert()
    }
    
    /// アラート表示
    func showAlert() {
        let alert = UIAlertController(title: "確認",
                                      message: "画像を削除してもいいですか？",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler:{(action: UIAlertAction) -> Void in
                                        // デフォルトの画像を表示する
                                        self.imageView.image = UIImage(named: "no_image.png")
        })
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        // アラートにボタン追加
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        // アラート表示
        present(alert, animated: true, completion: nil)
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        imageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}
