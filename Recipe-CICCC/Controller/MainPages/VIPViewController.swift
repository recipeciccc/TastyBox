//
//  VIPviewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class VIPViewController: UIViewController {

    @IBOutlet weak var collectionview: RecipeCollectionView!
    
    let dataManager = VIPDataManager()
     var mainViewController: MainPageViewController?
     var pageViewControllerDataSource: UIPageViewControllerDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionview.width = UIScreen.main.bounds.size.width
//        collectionview.height = UIScreen.main.bounds.size.height
        
        
        dataManager.delegate = self
        collectionview.delegate = self
        
        dataManager.isVIP()
        dataManager.findFollowing()

    }

}

extension VIPViewController : VIPDataManagerDelegate {
    func isVIP(isVIP: Bool, isMessageWillShow: Bool) {
        collectionview.isVIP = isVIP
       
        if !isVIP && isMessageWillShow != true {
            let alertController = UIAlertController(title: "Register VIP member", message: "Those recipes in this page is VIP only. You need to be VIP member.", preferredStyle: .alert)
                                      
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let noLongerShowAction = UIAlertAction(title: "Yes, No longer show it.", style: .default, handler: { action in
                self.dataManager.nolongerShowMessage()
            })
            let registerAction = UIAlertAction(title: "Register", style: .default, handler: { action in
                let vc = self.storyboard?.instantiateViewController(identifier: "registerVIP")
                self.navigationController?.pushViewController(vc!, animated: true)
            })
            
           
            alertController.addAction(noLongerShowAction)
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
    }
}
