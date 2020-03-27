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
    var delegate: GetCommentsDelegate?
    
    var comments:[Comment] = []
    
    func addComment(recipeId: String, userId: String, text: String, time: Timestamp) {
        db.collection("recipe").document(recipeId).collection("comment").document().setData([
            "user": userId,
            "text": text,
            "time": time
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        self.getComments(recipeId: recipeId)
    }
    
    func getComments(recipeId: String) {
        db.collection("recipe").document(recipeId).collection("comment").addSnapshotListener { querySnapshot, error in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                self.comments.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let userId = data["userId"] as! String
                    let text = data["text"] as! String
                    
                    let time = data["time"] as! Timestamp
                    
                    let comment = Comment(userId: userId, text: text, time: time)
                    
                    self.comments.append(comment)
                }
            }
            self.delegate?.gotData(comments: self.comments)
        }
    }
}
