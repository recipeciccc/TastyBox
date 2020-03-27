////
////  userPageTableViewController.swift
////  RecipeTest
////
////  Created by 北島　志帆美 on 2019-12-07.
////  Copyright © 2019 北島　志帆美. All rights reserved.
////
//import UIKit
//import Firebase
//import FirebaseFirestore
//
//class userPageTableViewController: UITableViewController {
//    
//    let fetchData = FetchRecipeData()
//    let fetchImage = FetchRecipeImage()
//    let userDataManager = UserdataManager()
//    let uid = Auth.auth().currentUser?.uid
//    var recipeList = [RecipeDetail]()
//    var imageList = [UIImage]()
//    var urlList = [String]()
//    var ridList = [String]()
//    var followers:[User] = []
//    var following:[User] = []
//    
//    var user: User?
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
//        
//        fetchData.delegate = self
//        fetchImage.delegate = self
//        userDataManager.delegate = self
//        
//        let db = Firestore.firestore()
//        let queryRef = db.collection("recipe").whereField("userID", isEqualTo: uid as Any).order(by: "time", descending: true)
//        
//        recipeList = fetchData.Data(queryRef: queryRef)
//        
//        self.userDataManager.getUserDetail(id: uid)
//        
//    }
//    
//    func get_url_rid(){
//        if recipeList.count != 0{
//            for data in recipeList {
//                //                urlList.append(data.image)
//                ridList.append(data.recipeID)
//                print(data.recipeID)
//            }
//        }
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let nextVC = segue.destination as? showFolllowingFollowedCreatorsViewController {
//            
//            //            nextVC.followers = user!.followersID
//            //            nextVC.following = user!.followingID
//            
//            if segue.identifier == "following" {
//                
//                nextVC.titleVC = "Following"
//                
//            }
//            if segue.identifier == "follower" {
//                
//                nextVC.titleVC = "Follower"
//                
//            }
//        }
//        
//        
//    }
//    
//    //    func getImage(data: RecipeDetail){
//    ////        for data in recipeList{
//    ////        }
//    //        let rid = data.recipeID
//    //        let url = data.image
//    //        fetchImage.getImage(uid: uid!, rid: rid, imageUrl: url)
//    //
//    //    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 3 //4
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let section = indexPath.section
//        
//        if section == 0 {
//            let cell = (tableView.dequeueReusableCell(withIdentifier: "Main User Page", for: indexPath) as? mainUserProfileTableViewCell)!
//            cell.userImageView.layer.masksToBounds = false
//            cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
//            cell.userImageView.clipsToBounds = true
//            
//            
//            return cell
//        }
//            
//        else if section == 1 {
//            let cell = (tableView.dequeueReusableCell(withIdentifier: "show the num", for: indexPath) as? NumberTableViewCell)!
//            return cell
//        }
//        
//        let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeItemForUser", for: indexPath) as? userRecipeItemTableViewCell)!
//        if recipeList.count != 0{
//            cell.recipeData = recipeList
//            
//            if imageList.count >= recipeList.count {
//                cell.recipeImage = imageList
//                cell.collectionView.reloadData()
//            }
//        }
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return 135
//        case 1:
//            return 60
//            //        case 2:
//        //            return 38
//        case 2:
//            return self.view.frame.height - ((self.view.frame.origin.y) * -1)
//        //return UITableView.automaticDimension
//        default:
//            return UITableView.automaticDimension
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    @IBAction func postedButtonTapped(_ sender: Any) {
//        self.view.frame.origin.y = -195.0
//    }
//    
//}
//
//extension userPageTableViewController: ReloadDataDelegate{
//    func reloadData(data:[RecipeDetail]) {
//        
//        recipeList = data
//        
//        if imageList.count == 0 {
//            self.tableView.reloadData()
//        }
//    }
//    func reloadImg(img:[UIImage]){
//        imageList = img
//        self.tableView.reloadData()
//    }
//}
//
//extension userPageTableViewController : getUserDataDelegate {
//    //    func gotUsersData(users: [User]) {
//    //        <#code#>
//    //    }
//    //
//    func gotUserData(user: User) {
//        self.user = user
//        self.user!.name = (Auth.auth().currentUser?.displayName)!
//    }
//    
//    
//}
