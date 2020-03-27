//
//  CommentsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var comments: [Comment] = []
    var recipe: RecipeDetail?
    
    let dataManager = CommentDataManager()
    let fetchData = FetchRecipeData()
    
    let uid = Auth.auth().currentUser?.uid
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        textField.delegate = self
        dataManager.delegate = self
        
        tableView.tableFooterView = UIView()
        
        let dbRef = Firestore.firestore().collection("recipe").document(recipe?.recipeID ?? "")
        let query_comment = dbRef.collection("comment").order(by: "time", descending: true)
        
        fetchData.getComments(queryRef: query_comment)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
    }
    
    @IBAction func postComment(_ sender: UIButton) {
        
        let comment = Comment(userId: uid!, text: textField.text ?? "", time: Timestamp())
        
        comments.append(comment)
        dataManager.addComment(recipeId: recipe!.recipeID, userId: uid!, text: comment.text, time: comment.time)
        tableView.reloadData()
     }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "comment") as? CommentTableViewCell)!
        
        
        return cell
        
    }
    
}

extension CommentsViewController: UITextFieldDelegate {
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                //MARK: adjust it later
                self.view.frame.origin.y -= 300
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        
        return true
    }
}

extension CommentsViewController: GetCommentsDelegate {
    func gotData(comments: [Comment]) {
        self.comments = comments
        self.tableView.reloadData()
    }
}
