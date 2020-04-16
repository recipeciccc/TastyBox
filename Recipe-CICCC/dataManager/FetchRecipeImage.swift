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
    
    func getImage( uid:String, rid: [String]){
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var imageList: [UIImage] = []
        var imageRefs: [StorageReference] = []
        
        for index in 0..<rid.count{
                   
            print("\(index): \(rid[index])")
            let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid[index])/\(rid[index])")
            imageRefs.append(imagesRef)
        }
        
//        print(imageRefs)
        imageList = Array(repeating: UIImage(), count: imageRefs.count)
        
        for (index, imageRef) in imageRefs.enumerated() {
            
           
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    if let imgData = data{
                        
//                        print("imageRef: \(imageRef)")
                        
                        image = UIImage(data: imgData)!
//                        print(index)
                        imageList.remove(at: index)
                        imageList.insert(image, at: index)
                        
                        self.delegate?.reloadImg(img: imageList)
                    }
                }
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


