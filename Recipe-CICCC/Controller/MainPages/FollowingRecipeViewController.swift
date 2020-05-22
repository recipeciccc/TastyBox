//
//  FollowingRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

protocol FollowingRecipestopPagingDelegate:  class {
    func stopPaging(isPaging: Bool)
}

class FollowingRecipeViewController: UIViewController {
    
    @IBOutlet weak var followingTableView: UITableView!
    
    
    var creatorImageList = [Int:UIImage]()
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
    
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    ///  スクロール開始地点
    var scrollBeginPoint: CGFloat = 0.0
    
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        
        dataManager.findFollowing(id: uid)
        
        self.followingTableView.tableFooterView = UIView()
        
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        indicator.hidesWhenStopped = true
        indicator.color = .white
        
        let navigationBar = UINavigationBar()
        let height = UIScreen.main.bounds.height / 2 - navigationBar.frame.size.height - 50
        
        indicator.center = CGPoint(x: UIScreen.main.bounds.width / 2 , y: height)
        indicator.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.5)
        indicator.layer.cornerRadius = 10
        
        self.view.addSubview(indicator)
        
        
        DispatchQueue.global(qos: .default).async {
            
            // Do heavy work here
            
            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.startAnimating()
            }
        }
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if lastNavigationBarIsHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.followingsID.removeAll()
        self.followings.removeAll()
        navigationController?.setNavigationBarHidden(false, animated: true)
        lastNavigationBarIsHidden = false
        
        
    }
    
    
    func isVIPAction(superView: UIView) {
        
        let imageView = UIImageView(image: UIImage(systemName: "lock.circle"))
        imageView.isOpaque = false
        imageView.tintColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        
        
        superView.addSubview(imageView)
        
        let width =  superView.frame.size.width / 3 * 2
        
        imageView.frame = CGRect(x:(superView.frame.size.width / 2) - (width / 2), y: (superView.frame.size.width / 2) - (width / 2) , width: width, height: width)
        
        
    }
    
    func updateNavigationBarHiding(scrollDiff: CGFloat) {
        let boundaryValue: CGFloat = 100.0
        
        /// navigationBar表示
        if scrollDiff > boundaryValue {
            navigationController?.setNavigationBarHidden(false, animated: true)
            lastNavigationBarIsHidden = false
            return
        }
            
            /// navigationBar非表示
        else if scrollDiff < -boundaryValue {
            navigationController?.setNavigationBarHidden(true, animated: true)
            lastNavigationBarIsHidden = true
            return
        } 
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollBeginPoint - scrollView.contentOffset.y
        updateNavigationBarHiding(scrollDiff: scrollDiff)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginPoint = scrollView.contentOffset.y
    }
}

extension FollowingRecipeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let recipes = recipes[collectionView.tag] {
            if self.recipes.count == followingsID.count && !recipes.isEmpty {
                return recipes.count
            }
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
        
        cell.lockImageView.isHidden = recipes[collectionView.tag]![indexPath.row].isVIPRecipe! ? false : true
        
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
    
    // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        mainViewController = self.parent as? MainPageViewController
        
        if  mainViewController!.dataSource == nil {
            
            mainViewController!.dataSource = mainViewController
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        })
        
    }
}

extension FollowingRecipeViewController : FollowingRecipeDataManagerDelegate {
    func assignUserImage(image: UIImage, index: Int) {
        self.creatorImageList[index] = image
        
        
        self.followingTableView.reloadData()
    }
    
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
        
        if followingsIDs.isEmpty {

            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.stopAnimating()
            }
            
        } else {
            dataManager.getFollowings(IDs: followingsIDs)

        }
        
        for (index, id) in followingsIDs.enumerated() {
            self.followingsID[index] = id
        }
        
        if !followingsID.isEmpty {
            
            
            followingsIDs.enumerated().map {
                
                let queryRef = Firestore.firestore().collection("recipe").whereField("userID", isEqualTo: $0.1).order(by: "time", descending: true).limit(to: 10)
                
                _ = dataManager.Data(queryRef: queryRef, index: $0.0)
                
            }
            
        }
    }
    
    func appendRecipeImage(imgs: UIImage, indexOfImage: Int, orderFollowing: Int) {
        print("\(indexOfImage): \(imgs)")
        
        if recipeImages[orderFollowing] == nil {
            recipeImages[orderFollowing] = [Int:UIImage]()
        }
        recipeImages[orderFollowing]?[indexOfImage] = imgs
       
        DispatchQueue.global(qos: .default).async {
            
            // Do heavy work here
            
            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.stopAnimating()
            }
        }
        
        UIView.transition(with:  self.followingTableView, duration: 0.3, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
            
            self.followingTableView.reloadData()
        }, completion: nil)
        
        
    }
    
    
    
}

extension FollowingRecipeViewController:FollowingRecipeTableViewCellDelegate {
    func goToCreatorProfile(indexPath: IndexPath) {
        let profileVC = UIStoryboard(name: "creatorProfile", bundle: nil).instantiateViewController(identifier: "creatorProfile") as! CreatorProfileViewController
        
        profileVC.id = creators[indexPath.row].userID
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
