//
//  PopularRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Crashlytics

class PopularRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: RecipeDetail?
    var recipes: [RecipeDetail] = []
    var images:[Int:UIImage] = [:]
    let db = Firestore.firestore()
    
    let dataManager = popularDataManager()
    var mainViewController: MainPageViewController?
    var pageViewControllerDataSource: UIPageViewControllerDataSource?
    
    ///  スクロール開始地点
    var scrollBeginPoint: CGFloat = 0.0
    
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataManager.delegate = self
        dataManager.getReipeDetail()
        
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        
        tableView.separatorStyle = .none
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if lastNavigationBarIsHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        lastNavigationBarIsHidden = false
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    func isVIPAction(superView: UIView, isVIP: Bool) {
        
        if isVIP == true {
            let imageView = UIImageView(image: UIImage(systemName: "lock.circle"))
            imageView.isOpaque = false
            imageView.tintColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
            
            
            if superView.subviews.count == 3 {
                superView.addSubview(imageView)
                
                imageView.frame.size.width = superView.frame.size.width / 3 * 2
                imageView.frame.size.height = superView.frame.size.width / 3 * 2
                
                imageView.center = superView.center
            }
        }
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


extension PopularRecipeViewController: UITableViewDelegate {
    
}

extension PopularRecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else  {
            return recipes.count - 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !recipes.isEmpty else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "medal recipe", for: indexPath) as? Number123TableViewCell)!
            cell.selectionStyle = .none
            
            cell.numberLikeLabel.text = "\(recipes[indexPath.row].like)"
            cell.titleLabel.text = recipes[indexPath.row].title
            cell.recipeImageView.image = images[indexPath.row]
            cell.lockImageView.isHidden = recipes[indexPath.row].isVIPRecipe! ? false : true
            
            
            switch indexPath.row {
            case 0:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 28")
                
            case 1:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 29")
                
            case 2:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 30")
                
            default:
                break
            }
            
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "under no.4", for: indexPath) as? UnderNo4TableViewCell)!
        
        cell.selectionStyle = .none
        //        isVIPAction(superView: cell.contentView, isVIP: recipes[indexPath.row + 3].isVIPRecipe ?? false)
        
        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
        cell.numLikeLabel.text = "\(recipes[indexPath.row + 3].like)"
        cell.titleLabel.text = recipes[indexPath.row + 3].title
        cell.recipeImageView.image = images[indexPath.row + 3]
        
        cell.lockImageView.isHidden = recipes[indexPath.row + 3].isVIPRecipe! ? false : true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let recipeVC = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(identifier: "detailvc") as! RecipeDetailViewController
        
        if indexPath.section == 0 {
            let cell = (tableView.cellForRow(at: indexPath) as? Number123TableViewCell)!
            recipeVC.recipe = self.recipes[indexPath.row]
            recipeVC.mainPhoto = cell.recipeImageView!.image!
        }
        else if indexPath.section == 1 {
            let cell = (tableView.cellForRow(at: indexPath) as? UnderNo4TableViewCell)!
            recipeVC.recipe = self.recipes[indexPath.row + 3]
            recipeVC.mainPhoto = cell.recipeImageView!.image!
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(recipeVC, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginPoint = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollBeginPoint - scrollView.contentOffset.y
        updateNavigationBarHiding(scrollDiff: scrollDiff)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        })
        
    }
}

extension PopularRecipeViewController: getDataFromFirebaseDelegate {
    func assignImage(image: UIImage, index: Int) {
         self.images[index] = image
        print("\(index): \(image)")
        
        if self.images.count == 10 {
            UIView.transition(with: self.tableView, duration: 0.7, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
                self.tableView.reloadData()
            }, completion: nil)
        }
        
    }
    
    func gotData(recipes: [RecipeDetail]) {
        
        if recipes.count == 10 {
            self.recipes = recipes
            images.removeAll()
        recipes.enumerated().map {
            dataManager.getImage(rid: $0.1.recipeID, uid: $0.1.userID, index: $0.0)
            }
        }
        
        tableView.reloadData()
    }
    
   // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         
       mainViewController = self.parent as? MainPageViewController
       
       if  mainViewController!.dataSource == nil {
           
           mainViewController!.dataSource = mainViewController
       }
   }
}



