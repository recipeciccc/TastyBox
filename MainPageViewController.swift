//
//  MainViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-16.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataSource = self
        // PageViewControllerにViewControllerをセット
        
        self.setViewControllers([editorChoiceVC], direction: .forward, animated: true,completion: nil)
    }
    
    let FollowingVC = UIStoryboard(name: "followingRecipe", bundle: nil).instantiateViewController(identifier: "followingRecipe") as! FollowingRecipeViewController
    let ingredientVC = UIStoryboard(name: "ingredientRecipe", bundle: nil).instantiateViewController(identifier: "ingredientRecipe") as! IngredientsViewController
    let poppularVC = UIStoryboard(name: "popularPage", bundle: nil).instantiateViewController(identifier: "popularPage") as! PopularRecipeViewController
    let editorChoiceVC = UIStoryboard(name: "EditorChoice", bundle: nil).instantiateViewController(identifier: "EditorChoice") as EditorChoiceViewController
    let monthlyVC = UIStoryboard(name: "Monthly", bundle: nil).instantiateViewController(identifier: "Monthly") as! MonthlyViewController
    let VIPVC = UIStoryboard(name: "VIP_page", bundle: nil).instantiateViewController(identifier: "VIP_page") as! VIPViewController
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(viewController)
        
        
        switch viewController {
            
        case is FollowingRecipeViewController:
            return nil
            
        case is IngredientsViewController:
            return FollowingVC
            
        case is PopularRecipeViewController:
            return ingredientVC
            
        case is EditorChoiceViewController:
            return poppularVC
            
        case is MonthlyViewController:
            return editorChoiceVC
            
        case is VIPViewController:
            return monthlyVC
            
        default:
            break
        }
        
        return nil
    }
    
    // 現在表示されているページの、Afterに位置する、つまり右側に位置するviewを呼び出す関数
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(viewController)
        
        switch viewController {
            
        case is FollowingRecipeViewController:
            return ingredientVC
            
        case is IngredientsViewController:
            return poppularVC
            
        case is PopularRecipeViewController:
            return editorChoiceVC
            
        case is EditorChoiceViewController:
            return monthlyVC
            
        case is MonthlyViewController:
            return VIPVC
        
        case is VIPViewController:
            return nil
        default:
            break
        }
        
        return nil
        
    }
}
