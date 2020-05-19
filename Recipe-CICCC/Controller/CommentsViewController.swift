//
//  CommentsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    var comments: [Comment] = []
    var users: [User] = []
    var usersImage = [Int: UIImage]()
    var recipe: RecipeDetail?
    
    let dataManager = CommentDataManager()
//    let userDataManager = UserdataManager()
//    let fetchData = FetchRecipeData()
    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(title: "Comming Soon!", message: "You can leave comments after comming soon update! Hope you will be able to leave fancy comments soon!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        textView.delegate = self
        dataManager.delegate = self
//        userDataManager.delegate = self
//        fetchData.commentDelegate = self
        
        tableView.tableFooterView = UIView()
        
         //uncomment it below after can comment
//        let dbRef = Firestore.firestore().collection("recipe").document(recipe?.recipeID ?? "")
//        let query_comment = dbRef.collection("comment").order(by: "time", descending: true)
        
//        dataManager.getComments(recipeID: recipe?.recipeID ?? "")
//        dataManager.getUserImage()
//        fetchData.getComments(queryRef: query_comment)
//        userDataManager.getUserImage(uid: uid!)
        
        // get rid of it below after can comment
        textView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        
        createToolbar()
        tapRecognizer.isEnabled = false
    }
    
    
    func createToolbar(){
        // ToolBar
        let toolBar = UIToolbar()
        //        toolBar.barStyle = .blackTranslucent
        //        toolBar.isTranslucent = true
        //        toolBar.backgroundColor = UIColor.blue
        toolBar.tintColor = UIColor.orange
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postComment))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelComment))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.textView.inputAccessoryView = toolBar
        
    }
    
    @objc func postComment() {
        
        let comment = Comment(userId: uid!, text: textView.text ?? "", time: Timestamp())
        
        comments.append(comment)
        dataManager.addComment(recipeId: recipe!.recipeID, userId: uid!, text: comment.text, time: comment.time)
        self.textView.resignFirstResponder()
        self.tapRecognizer.isEnabled = false
        
        tableView.reloadData()
    }
    
    @objc func cancelComment() {
        self.tapRecognizer.isEnabled = false
        self.textView.resignFirstResponder()
    }
    
    
    @IBAction func closeKeyboard(_ sender: Any) {
        self.textView.resignFirstResponder()
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
    
        cell.commentLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cell.commentLabel.text = comments[indexPath.row].text
        
        if !users.isEmpty && !usersImage.isEmpty {
            cell.nameLabel.text = users[indexPath.row].name
            cell.userImageView.image = usersImage[indexPath.row]
        }
        
       
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 76
        //UITableView.automaticDimensionでcellの高さを可変にする
        return UITableView.automaticDimension
    }
    
}

extension CommentsViewController: UITextViewDelegate {
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                //MARK: adjust it later
                let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                toolbar.sizeToFit()
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    self.view.frame.origin.y -= keyboardHeight
                }
//                self.view.frame.origin.y -= 305 //+ toolbar.frame.height
            }
            self.tapRecognizer.isEnabled = true
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
}

extension CommentsViewController: GetCommentsDelegate {
    func assignUserImage(image: UIImage) {
         self.userImageView.image = image
    }
    
    func assignUserImage(images: [Int : UIImage]) {
        self.usersImage = images
        self.tableView.reloadData()
    }
    
    func getCommentUser(user: [User], comments: [Comment]) {
        self.users = user
        // reorder users by date
        for (newIndex, comment) in self.comments.enumerated() {
            for (originalIndex, user) in self.users.enumerated() {
                if comment.userId == user.userID {
                    self.users.remove(at: originalIndex)
                    self.users.insert(user, at: newIndex)
                }
            }
        }
    
        self.tableView.reloadData()
    }
    
    func gotData(comments: [Comment]) {
        self.comments = comments
        self.tableView.reloadData()
    }
}

