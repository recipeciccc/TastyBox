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


protocol FetchRecipeImageDelegate: class {
    func instructionImages(images:[Int: UIImage])
}

class FetchRecipeImage{
    weak var delegate: ReloadDataDelegate?
    weak var delegateImg: ReloadDataDelegate?
    
    var images:[Int:UIImage] = [:]
    
    func getImage( uid:String?, rid: [String]){
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        var imageList: [UIImage] = []
        var imageRefs: [StorageReference] = []
        
        
        guard let uid = uid else {
            return
        }
        
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
                        
                        print("imageRef: \(imageRef)")
                        
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
    
    
    
    func getInstructionImg( uid:String, rid: String, count: Int) {
        
        var image = UIImage()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        self.images.removeAll()
        
        for index in 0..<count{
            
            
            let imagesRef = storageRef.child("user/\(uid)/RecipePhoto/\(rid)/\(index)")
            imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in   //

                if error != nil {
                    
                    
                    self.images[index] = #imageLiteral(resourceName: "imageFile")
                    
                    if count == self.images.count {
                        var imgList = [UIImage]()
                        imgList = [UIImage](self.images.values)
                        
                        self.delegateImg?.reloadImg(img: imgList)
                    }
                    
                    print(error?.localizedDescription as Any)
                    
                   
                } else {
                    if let imgData = data{
                        image = UIImage(data: imgData)!
                        
                        if let images = self.gotInstructionImg(index: index, image: image, count: count)  {
                            if count == self.images.count {
                                self.delegateImg?.reloadImg(img: images)
                            }
                            
                        }
                        else {
                            
                            if count == self.images.count {
                                var imgList = [UIImage]()
                                imgList = [UIImage](self.images.values)
                                
                                self.delegateImg?.reloadImg(img: imgList)
                            }
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func gotInstructionImg(index: Int, image: UIImage, count: Int) -> [UIImage]?{
        
        images[index] = image
        
        if images.count == count {
            
            var imgList = [UIImage]()
            imgList = [UIImage](images.values)
            
            return imgList
        }
        return nil
    }
}


