//
//  VIPviewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

class VIPViewController: UIViewController {
    
    @IBOutlet weak var collectionview: RecipeCollectionView!
    
    let dataManager = VIPDataManager()
    var mainViewController: MainPageViewController?
    var pageViewControllerDataSource: UIPageViewControllerDataSource?
    
    ///  スクロール開始地点
    var scrollBeginPoint: CGFloat = 0.0
    
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.delegate = self
        collectionview.delegate = self
        
        dataManager.isVIP()
        dataManager.findFollowing()
        
        let width = collectionview.widthAnchor.constraint(equalToConstant: self.view.frame.size.width)
        let height =  collectionview.heightAnchor.constraint(equalToConstant: self.view.frame.size.height)
        
        width.isActive = true
        height.isActive = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        lastNavigationBarIsHidden = false
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

extension VIPViewController : VIPDataManagerDelegate {
    func isVIP(isVIP: Bool, isMessageWillShow: Bool) {
        collectionview.isVIP = isVIP
        
        if !isVIP && isMessageWillShow != true {
            
            let alertController = UIAlertController(title: "Register VIP member", message: "Those recipes in this page is VIP only. You need to be VIP member.", preferredStyle: .alert)
            let registerAction = UIAlertAction(title: "Register", style: .default, handler: { action in
                let vc = self.storyboard?.instantiateViewController(identifier: "registerVIP")
                //                guard self.navigationController?.topViewController == self else { return }
                self.navigationController?.pushViewController(vc!, animated: true)
            })
            
            let defaultAction = UIAlertAction(title: "No, Thanks", style: .default, handler: { action in
                
                let alertController = UIAlertController(title: "No longer show this message?", message: nil, preferredStyle: .alert)
                
                
                let noLongerShowAction = UIAlertAction(title: "Don't show", style: .default, handler: { action in
                    self.dataManager.nolongerShowMessage()
                })
                
                let neverMindAction = UIAlertAction(title: "Never mind", style: .cancel, handler: nil)
                
                alertController.addAction(noLongerShowAction)
                alertController.addAction(neverMindAction)
                
                
                self.present(alertController, animated: true, completion: nil)
            })
            
            alertController.addAction(defaultAction)
            alertController.addAction(registerAction)
            
            navigationController!.present(alertController, animated: true, completion: nil)
        }
    }
    
    func reloadCreators(data: [User]) {
        collectionview.users = data
    }
    
    
    func reloadRecipes(data: [RecipeDetail]) {
        collectionview.recipes = data
        
    }
    
    func reloadImages(data: [Int : UIImage]) {
        collectionview.imageDictionary = data
    }
}

extension VIPViewController :RecipeCollectionViewDelegate {
    func pushViewController(recipe: RecipeDetail?, image: UIImage?, creator: User?) {
        
        if recipe == nil {
            
            let alertController = UIAlertController(title: "Register VIP member", message: "This recipe is VIP only. You need to be VIP member.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let registerAction = UIAlertAction(title: "Sign up VIP membership", style: .default, handler: { action in
                let registerVC = self.storyboard?.instantiateViewController(identifier: "registerVIP") as! ExplainationVIPViewController
                
                self.navigationController?.pushViewController(registerVC, animated: true)
            })
            
            alertController.addAction(registerAction)
            alertController.addAction(defaultAction)
            
            navigationController!.present(alertController, animated: true, completion: nil)
            
        } else {
            
            let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
            
            vc.recipe = recipe
            vc.mainPhoto = image!
            vc.creator = creator
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
        let scrollDiff = scrollBeginPoint - scrollView.contentOffset.y
        updateNavigationBarHiding(scrollDiff: scrollDiff)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginPoint = scrollView.contentOffset.y
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        })
        
    }
}
