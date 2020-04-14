//
//  userPageTableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var profileTableVIew: UITableView!
    
    let fetchData = FetchRecipeData()
    let fetchImage = FetchRecipeImage()
    let userDataManager = UserdataManager()
    
    let uid = Auth.auth().currentUser?.uid
    
    var recipeList = [RecipeDetail]()
    var imageList = [UIImage]()
    var urlList = [String]()
    var ridList = [String]()
    var followers:[String] = []
    var following:[String] = []
    var user: User?
    var userImage: UIImage = #imageLiteral(resourceName: "imageFile")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
        profileTableVIew.delegate = self
        profileTableVIew.dataSource = self
        profileTableVIew.allowsSelection = false
        
        fetchData.delegate = self
        fetchImage.delegate = self
        userDataManager.delegate = self
        userDataManager.delegateFollowerFollowing = self
        
        let db = Firestore.firestore()
        let queryRef = db.collection("recipe").whereField("userID", isEqualTo: uid as Any).order(by: "time", descending: true)
        recipeList = fetchData.Data(queryRef: queryRef)
       
        userDataManager.findFollowerFollowing(id: uid, collection: "following")
       userDataManager.findFollowerFollowing(id: uid, collection: "follower")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? followerFollowingPageViewController {
            
            nextVC.userID = uid!
            nextVC.followersID = followers
            nextVC.followingsID = following
            
            if segue.identifier == "following" {
               
                nextVC.titleVC = "Following"
            
            }
            if segue.identifier == "follower" {
            
                nextVC.titleVC = "Follower"
            
            }
        }
        
          
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3 //4
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "Main User Page", for: indexPath) as? mainUserProfileTableViewCell)!
            cell.userImageView.layer.masksToBounds = false
            cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
            cell.userImageView.clipsToBounds = true
            cell.imageView?.image = self.userImage
            
            return cell
        }
            
        else if section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "show the num", for: indexPath) as? NumberTableViewCell)!
            
            cell.numOfRecipeUserPostedButton.setTitle("\(recipeList.count) \nPosted", for: .normal)
            cell.numOfFollowerButton.setTitle("\(followers.count) \nFollowers", for: .normal)
            cell.numOfFollowingButton.setTitle("\(following.count) \nFollowings", for: .normal)
            
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeItemForUser", for: indexPath) as? userRecipeItemTableViewCell)!
            cell.delegate = self
        
         if recipeList.count != 0{
                   cell.recipeData = recipeList

                   if imageList.count >= recipeList.count {
                       cell.recipeImage = imageList
                       cell.collectionView.reloadData()
                   }
               }
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 135
        case 1:
            return 60
            //        case 2:
        //            return 38
        case 2:
            return self.view.frame.height - ((self.view.frame.origin.y) * -1)
        //return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func postedButtonTapped(_ sender: Any) {
        self.view.frame.origin.y = -195.0
    }
    
    
    // MARK: cant tap image although put tap recognizer.
    @IBAction func changeAccountImage(_ sender: UITapGestureRecognizer) {
        let imagePickerVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "imagePickerVC")
        navigationController?.pushViewController(imagePickerVC, animated: true)
    }
}

extension MyPageViewController: ReloadDataDelegate{
  
    func reloadData(data:[RecipeDetail]) {
        
        recipeList = data
        
        if imageList.count == 0 {

        get_url_rid()
        fetchImage.getImage(uid: uid!, rid: ridList, imageUrl: urlList)
        
        if imageList.count == 0{
           profileTableVIew.reloadData()
        }
    }
    }
    
    // MARK: initialized ImageList
    func reloadImg(img:[UIImage]){
        imageList = img
        self.profileTableVIew.reloadData()
    }
    
}

extension MyPageViewController : getUserDataDelegate {

    func gotUserData(user: User) {
        self.user = user
        self.user!.name = (Auth.auth().currentUser?.displayName)!
        self.profileTableVIew.reloadData()
    }
     // MARK: initialized recipe id and image id
    
    func get_url_rid(){
        if recipeList.count != 0{
            for data in recipeList{
                urlList.append(data.image!)
                ridList.append(data.recipeID)
                
                print(data.recipeID)
                print(data.updatedDate)
                print(data.image!)
            
            }
//           urlListが日付順になっているか調べる
            // po urlList, ridList and po recipeList
            // この時点では上記全てが日付順になっている
        }
            
    }
}

extension MyPageViewController: CollectionViewInsideUserTableView{
    func cellTaped(data: IndexPath) {

        let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
        vc.userProfile = true
        vc.recipe = recipeList[data.row]
        vc.mainPhoto = imageList[data.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyPageViewController: FolllowingFollowerDelegate {
    func assignFollowersFollowings(users: [User]) {
        
    }
    
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        self.following = followingsIDs
        self.followers = followersIDs
    }
    
}

extension MyPageViewController: setImageDelegate {
    func setAccountImage(image: UIImage) {
        self.userImage = image
        self.profileTableVIew.reloadData()
    }
}