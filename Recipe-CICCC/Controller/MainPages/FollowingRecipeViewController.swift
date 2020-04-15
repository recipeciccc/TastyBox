//
//  FollowingRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class FollowingRecipeViewController: UIViewController {
    
    @IBOutlet weak var followingTableView: UITableView!
    
    var creatorImageList = [UIImage]()
    var creatorNameList = [String]()
    var recipeImage = [[UIImage]]()
    //    var recipeTitle = [[String]]()
    
    var recipes: [[RecipeDetail]] = []
    var creators:[User] = []
    var followingsID:[String] = []
    var followings:[User] = []
    
    let uid = Auth.auth().currentUser?.uid
    let userDataManager = UserdataManager()
    let dataManagerWithQuery = FetchRecipeData()
    let fetchImageDataManager = FetchRecipeImage()
    let getImageDataManager = RecipedataManagerClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDataManager.delegate = self
        userDataManager.delegateFollowerFollowing = self
        fetchImageDataManager.delegate = self
        dataManagerWithQuery.delegate = self
        getImageDataManager.delegate = self
        
        userDataManager.findFollowerFollowing(id: uid)
        self.followingTableView.tableFooterView = UIView()
   
    }
 
}

extension FollowingRecipeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creators.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! FollowingRecipeTableViewCell
        
        if !creatorImageList.isEmpty {
            cell.creatorImage.image = creatorImageList[indexPath.row]
        }
        
        if !creatorNameList.isEmpty {
            cell.createrName.text = creatorNameList[indexPath.row]
        }
        cell.createrName.isUserInteractionEnabled = true
        cell.creatorImage.layer.cornerRadius = cell.creatorImage.frame.width / 2
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? FollowingRecipeTableViewCell else {return}
        tableViewCell.collectionViewDelegate(self, row: indexPath.row)
    }
    
    
}

extension FollowingRecipeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if recipes.isEmpty {
            return 0
        }
        
        return recipes[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! followingRecipeCollectionViewCell
        
       
        if !recipeImage.isEmpty {cell.RecipeImage.image = recipeImage[collectionView.tag][indexPath.row]}
        
        if !recipes.isEmpty {
            cell.RecipeName.text = recipes[collectionView.tag][indexPath.row].title
            getImageDataManager.getImage(rid: recipes[collectionView.tag][indexPath.row].recipeID, uid: recipes[collectionView.tag][indexPath.row].userID, imageView: cell.RecipeImage!)
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 163, height: 162)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeDetailVC = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(identifier: "detailvc") as! RecipeDetailViewController
        
        recipeDetailVC.recipe = recipes[collectionView.tag][indexPath.row]
        recipeDetailVC.creator = creators[collectionView.tag]
        
        let cell = (collectionView.cellForItem(at: indexPath) as? followingRecipeCollectionViewCell )
        recipeDetailVC.mainPhoto = (cell?.RecipeImage.image)!
        
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
}

extension FollowingRecipeViewController: getUserDataDelegate {
    func gotUserData(user: User) {
        
    }
    
    func assignUserImage(image: UIImage) {
        self.creatorImageList.append(image)
        self.followingTableView.reloadData()
    }
}
extension FollowingRecipeViewController: FolllowingFollowerDelegate {
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        
        self.followingsID = followingsIDs
        
        userDataManager.getFollowersFollowings(IDs: self.followingsID, followerOrFollowing: "following")
        followingsID.enumerated().map {
            
            let queryRef = Firestore.firestore().collection("recipe").whereField("userID", isEqualTo: $0.1).order(by: "time", descending: true).limit(to: 10)
                        
            _ = dataManagerWithQuery.Data(queryRef: queryRef)
            
            
            userDataManager.getUserImage(uid: $0.1)
            self.followingTableView.reloadData()
        }
    }
    
    func assignFollowersFollowings(users: [User]) {
        
        users.map {
            creatorNameList.append($0.name)
        }
        
        self.creators = users
        
        self.followingTableView.reloadData()
    }
    
}

extension FollowingRecipeViewController: ReloadDataDelegate {
    func reloadData(data: [RecipeDetail]) {
        var recipeIDs:[String] = []

        recipes.append(data)
        
        for recipeArray in recipes {
            for recipeData in recipeArray {
                recipeIDs.append(recipeData.recipeID)
            }
        }
        
        self.followingsID.map {
            fetchImageDataManager.getImage(uid: $0, rid: recipeIDs)
        }
    }
    
    func reloadImg(img: [UIImage]) {
        recipeImage.append(img)
        self.followingTableView.reloadData()
    }
    
}

extension FollowingRecipeViewController: getDataFromFirebaseDelegate {
    func assignImage(image: UIImage, reference: UIImageView) {
        reference.image = image
    }
    
    func gotData(recipes: [RecipeDetail]) {
        
    }
    
    func gotImage(image: UIImage) {
        
    }
    
}
