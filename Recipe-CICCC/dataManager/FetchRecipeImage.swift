//
//  fetchRecipeImage.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-03-07.
//  Copyright © 2020 Argus Chen. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseStorage


class FetchRecipeImage{
    var delegate: ReloadDataDelegate?
    var delegateImg: ReloadDataDelegate?
    
    func getImage( uid:String, rid: [String], imageUrl: [String]){
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var imageList = [UIImage]()
        
        for index in 0..<rid.count{
            
            let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid[index])/\(rid[index])")
            imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    if let imgData = data{
                        
                        image = UIImage(data: imgData)!
                        imageList.append(image)
                        self.delegate?.reloadImg(img: imageList)
                    }
                }
                self.delegate?.reloadImg(img: imageList)
            }
        }
    }
    
    func getInstructionImg( uid:String, rid: String, count: Int) -> [UIImage]{
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var imgList = [UIImage]()
        for index in 0..<count{
            let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(index)")
            imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
                
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    } else {
                        if let imgData = data{
                            image = UIImage(data: imgData)!
                        }
                    }
                DispatchQueue.main.async {
                    imgList.append(image)
                    self.delegateImg?.reloadImg(img: imgList)
                }
            }
        }
        return imgList
    }
}


