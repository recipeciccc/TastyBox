//
//  MainViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-16.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

protocol MainPageViewControllerDelegate : class {
    func indexPageCurledInContainer (index: Int, indexPathUserselectedBefore: Int, indexPath: IndexPath)
}

class MainPageViewController: UIPageViewController {
    var isPaging = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataSource = self
        self.isPaging = false
        // PageViewControllerにViewControllerをセット
        
        // tapによるページめくりを担当するインスタンスを取得
        let tapGestureRecognizer = self.gestureRecognizers.filter{ $0 is UITapGestureRecognizer }.first as! UITapGestureRecognizer
        
        tapGestureRecognizer.isEnabled = false
        
        self.setViewControllers([editorChoiceVC], direction: .forward, animated: true,completion: nil)
       
      
        ingredientVC.delegate = self
        
//        self.view.isUserInteractionEnabled = false
    }
    
    let FollowingVC = UIStoryboard(name: "followingRecipe", bundle: nil).instantiateViewController(identifier: "followingRecipe") as! FollowingRecipeViewController
    let ingredientVC = UIStoryboard(name: "ingredientRecipe", bundle: nil).instantiateViewController(identifier: "ingredientRecipe") as! IngredientsViewController
    let poppularVC = UIStoryboard(name: "popularPage", bundle: nil).instantiateViewController(identifier: "popularPage") as! PopularRecipeViewController
    let editorChoiceVC = UIStoryboard(name: "EditorChoice", bundle: nil).instantiateViewController(identifier: "EditorChoice") as EditorChoiceViewController
    let monthlyVC = UIStoryboard(name: "Monthly", bundle: nil).instantiateViewController(identifier: "Monthly") as! CuisineViewController
    let VIPVC = UIStoryboard(name: "VIP_page", bundle: nil).instantiateViewController(identifier: "VIP_page") as! VIPViewController
    
    weak var pageControllerDelegate: MainPageViewControllerDelegate?
    var indexPath: IndexPath?
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension MainPageViewController: stopPagingDelegate , UIGestureRecognizerDelegate {
    func stopPaging(isPaging: Bool) {
        self.view.isUserInteractionEnabled = isPaging
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
         -> Bool {
        // Returning true from here means, page view controller will behave as it is
        // Returning false means, paging will be blocked
        // As I needed to block paging only for landscape orientation, I'm just returning
        // if orientation is in portrait or not
            if isPaging == false {
                return false
            } else {
            
                return UIApplication.shared.statusBarOrientation.isPortrait
            }
    }

}

extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(viewController)
        
        switch viewController {
            
        case is FollowingRecipeViewController:
            return nil
            
        case is IngredientsViewController:
            
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 0, indexPathUserselectedBefore: 1, indexPath: indexPath!)
            
            return FollowingVC
            
        case is PopularRecipeViewController:
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 1, indexPathUserselectedBefore: 2, indexPath: indexPath!)
            return ingredientVC
            
        case is EditorChoiceViewController:
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 2, indexPathUserselectedBefore: 3, indexPath: indexPath!)
            return poppularVC
            
        case is CuisineViewController:
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 3, indexPathUserselectedBefore: 4, indexPath: indexPath!)
            return editorChoiceVC
            
        case is VIPViewController:
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 4, indexPathUserselectedBefore: 5, indexPath: indexPath!)
            
            return monthlyVC
            
        default:
            break
        }
        
        return nil
    }
    
    // 現在表示されているページの、Afterに位置する、つまり右側に位置するviewを呼び出す関数
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
      
        
        switch viewController {
            
        case is FollowingRecipeViewController:
            
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 1, indexPathUserselectedBefore: 0, indexPath: indexPath!)
            
            return ingredientVC
            
        case is IngredientsViewController:
            
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 2, indexPathUserselectedBefore: 1, indexPath: indexPath!)
            
            return poppularVC
            
        case is PopularRecipeViewController:
            
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 3, indexPathUserselectedBefore: 2, indexPath: indexPath!)
            
            return editorChoiceVC
            
        case is EditorChoiceViewController:
            
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 4, indexPathUserselectedBefore: 3, indexPath: indexPath!)
            
            return monthlyVC
            
        case is CuisineViewController:
            self.pageControllerDelegate?.indexPageCurledInContainer(index: 5, indexPathUserselectedBefore: 4, indexPath: indexPath!)
            
            return VIPVC
        
        case is VIPViewController:
            return nil
        default:
            break
        }
        
        return nil
        
    }
    
}

