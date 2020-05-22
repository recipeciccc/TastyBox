//
//  File.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class CommentDataManager {
    let db = Firestore.firestore()
    weak var delegate: GetCommentsDelegate?
    
    var comments:[Comment] = []
    var user:User?
    var users:[User] = []
    var usersImages = [Int: UIImage]()
    
    func addComment(recipeId: String, userId: String, text: String, time: Timestamp) {
        db.collection("recipe").document(recipeId).collection("comment").document().setData([
            "user": userId,
            "text": text,
            "time": time
        ],merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        self.getComments(recipeID: recipeId)
    }
    
    func getUserImage() {
        
        let uid = Auth.auth().currentUser?.uid
        
        let imageRef = Storage.storage().reference().child("user/\(uid!)/userAccountImage")
        var image: UIImage?
        // Fetch the download URL
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data {
                    
                    print("imageRef: \(imageRef)")
                    
                    image = UIImage(data: imgData)!
                    self.delegate?.assignUserImage(image: image!)
                }
            }
        }
    }
    
    func getComments(recipeID: String) {
        
        db.collection("recipe").document(recipeID).collection("comment").order(by: "time", descending: true).addSnapshotListener { querySnapshot, error in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                self.comments.removeAll()
                
                if let documents = querySnapshot?.documents {
                    
                    for document in documents {
                        let data = document.data()
                        
                        let userId = data["user"] as! String
                        let text = data["text"] as! String
                        
                        let time = data["time"] as! Timestamp
                        
                        let comment = Comment(userId: userId, text: text, time: time)
                        
                        self.comments.append(comment)
                    }
                    
                    self.delegate?.gotData(comments: self.comments)
                    
                    if !self.comments.isEmpty {
                        self.getCommentedUsers()
                    }
                    
                }
                
            }
            
        }
        
    }
    
    fileprivate func getCommentedUsers() {
        for (index, comment) in comments.enumerated() {
            db.collection("user").document(comment.userId).addSnapshotListener { querySnapshot, error in
                if error != nil {
                    print("Error getting documents: \(String(describing: error))")
                } else {
                    if let data = querySnapshot!.data() {
                        
                        print("data count: \(data.count)")
                        
                        
                        guard let userID = data["id"] as? String else { return }
                        guard let name = data["userName"] as? String else { return }
                        guard let familySize = data["familySize"] as? Int else { return }
                        guard let cuisineType = data["cuisineType"] as? String else { return }
                        guard let isVIP = data["isVIP"] as? Bool else { return }
                        
                        self.user = User(userID: userID, name: name, cuisineType: cuisineType, familySize: familySize, isVIP: isVIP)
                        self.users.append(self.user!)
                        
                        if index == self.comments.count - 1 {
                            self.getUserImage(uid: self.user!.userID, index: index)
                            
                        } else {
                            self.getUserImage(uid: self.user!.userID, index: index)
                        }
                    }
                }
            }
        }
    }
    
    
    func getUserImage(uid: String, index: Int) {
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("user/\(uid)/userAccountImage")
        var image: UIImage?
        // Fetch the download URL
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if let imgData = data {
                    
                    //                       print("imageRef: \(imageRef)")
                    
                    image = UIImage(data: imgData)!
                    self.usersImages[index] = image
                    
                    if self.comments.count == self.usersImages.count {
                        self.delegate?.getCommentUser(user: self.users, comments: self.comments)
                        self.delegate?.assignUserImage(images: self.usersImages)
                    }
                    
                }
            }
        }
    }
}
