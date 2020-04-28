//
//  FollowingRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

protocol FollowingRecipestopPagingDelegate:  class {
    func stopPaging(isPaging: Bool)
}

class FollowingRecipeViewController: UIViewController {
    
    @IBOutlet weak var followingTableView: UITableView!
    
    var creatorImageList = [UIImage]()
    var creatorNameList = [String]()
    var recipeImageOneFollowinghas: [Int:UIImage] = [:]
    var recipeImages:[Int: [Int: UIImage]] = [:]
    var recipes: [Int:[RecipeDetail]] = [:]
    var tempRecipes:[RecipeDetail] = []
    var creators:[User] = []
    var followingsID:[Int:String] = [:]
    var followings:[User] = []
    var pageViewControllerDataSource: UIPageViewControllerDataSource?
    var mainViewController: MainPageViewController?
    
    let uid = Auth.auth().currentUser?.uid
    let dataManager = FollowingRecipeDataManager()
    
    weak var delegate: FollowingRecipestopPagingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        
        dataManager.findFollowing(id: uid)
        
        self.followingTableView.tableFooterView = UIView()
        
      
    }
    
}

extension FollowingRecipeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creators.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! FollowingRecipeTableViewCell
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        if creatorImageList.count == followingsID.count {
            cell.creatorImageButton.setBackgroundImage(creatorImageList[indexPath.row], for: .normal)
        }
        
        if creators.count == followingsID.count {
            cell.creatorNameButton.setTitle(creators[indexPath.row].name, for: .normal)
        }
        
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
        if recipes.count == followingsID.count {
            return recipes[collectionView.tag]!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! followingRecipeCollectionViewCell
        
        if followingsID.count == recipeImages.count {
           
                cell.RecipeImage.image = self.recipeImages[collectionView.tag]?[indexPath.row]
        }
        
        
        if !recipes.isEmpty {
            cell.RecipeName.text = recipes[collectionView.tag]![indexPath.row].title
            
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 163, height: 162)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeDetailVC = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(identifier: "detailvc") as! RecipeDetailViewController
        
        recipeDetailVC.recipe = recipes[collectionView.tag]![indexPath.row]
        recipeDetailVC.creator = creators[collectionView.tag]
        
        let cell = (collectionView.cellForItem(at: indexPath) as? followingRecipeCollectionViewCell )
        
        recipeDetailVC.mainPhoto = (cell?.RecipeImage.image)!
        
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
////        delegate?.stopPaging(isPaging: false)
//        mainViewController = self.parent as! MainPageViewController
//        pageViewControllerDataSource = mainViewController!.dataSource
//
////        if  mainViewController!.dataSource != nil {
//        mainViewController!.dataSource = nil
//            mainViewController?.isPaging = false
////        }
//    }
    
    
    // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          
        mainViewController = self.parent as? MainPageViewController
        
        if  mainViewController!.dataSource == nil {
            
            mainViewController!.dataSource = mainViewController
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainViewController = self.parent as? MainPageViewController
        pageViewControllerDataSource = mainViewController!.dataSource
                
        mainViewController!.dataSource = nil
        mainViewController?.isPaging = false
    }
}

extension FollowingRecipeViewController : FollowingRecipeDataManagerDelegate {
    func assignFollowings(users: [User]) {
        
        self.creators = users
               
        self.followingTableView.reloadData()
           
    }
    
    func reloadData(data: [RecipeDetail], index: Int) {
        recipes[index] = data
        
        if recipes.count == followingsID.count {
            
            for element in self.followingsID{
                
                recipeImageOneFollowinghas.removeAll()
                for (indexRecipe, recipe) in recipes[element.key]!.enumerated() {
                    print("\(recipe.title): \(indexRecipe)")
                    self.dataManager.getImageOfRecipesFollowing(uid: element.value, rid: recipe.recipeID, indexOfImage: indexRecipe, orderFollowing: element.key)
                    
                }
            }
        }
        
        self.followingTableView.reloadData()
        
        
    }
    
    func passFollowing(followingsIDs: [String]) {
        dataManager.getFollowings(IDs: followingsIDs)
        
        for (index, id) in followingsIDs.enumerated() {
            self.followingsID[index] = id
        }
        
        if !followingsID.isEmpty {
            
            
            followingsIDs.enumerated().map {
                
                dataManager.getUserImage(uid: followingsIDs[$0.0])
                
                let queryRef = Firestore.firestore().collection("recipe").whereField("userID", isEqualTo: $0.1).order(by: "time", descending: true).limit(to: 10)
                
                _ = dataManager.Data(queryRef: queryRef, index: $0.0)
                
            }
            
        }
    }
    
    
    func assignUserImage(image: UIImage) {
        self.creatorImageList.append(image)
        self.followingTableView.reloadData()
    }
    
    func appendRecipeImage(imgs: UIImage, indexOfImage: Int, orderFollowing: Int) {
         print("\(indexOfImage): \(imgs)")
       
        if recipeImages[orderFollowing] == nil {
            recipeImages[orderFollowing] = [Int:UIImage]()
        }
        recipeImages[orderFollowing]?[indexOfImage] = imgs
        self.followingTableView.reloadData()
        
        }
    
}

extension FollowingRecipeViewController:FollowingRecipeTableViewCellDelegate {
    func goToCreatorProfile(indexPath: IndexPath) {
        let profileVC = UIStoryboard(name: "creatorProfile", bundle: nil).instantiateViewController(identifier: "creatorProfile") as! CreatorProfileViewController
        
        profileVC.id = creators[indexPath.row].userID
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
