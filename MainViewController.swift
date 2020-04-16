//
//  MainViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-16.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class MainViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    let FollowingVC = UIStoryboard(name: "followeringRecipe", bundle: nil).instantiateViewController(identifier: "followeringRecipe") as! FollowingRecipeViewController
    let ingredientVC = UIStoryboard(name: "ingredientRecipe", bundle: nil).instantiateViewController(identifier: "RecipeViewController") as! RecipeViewController
    let poppularVC = UIStoryboard(name: "popularPage", bundle: nil).instantiateViewController(identifier: "popularPage") as! PopularRecipeViewController
    let editorChoiceVC = UIStoryboard(name: "EditorChoice", bundle: nil).instantiateViewController(identifier: "EditorChoice") as EditorChoiceViewController
    let monthlyVC = UIStoryboard(name: "Monthly", bundle: nil).instantiateViewController(identifier: "Monthly") as! MonthlyViewController
    let VIPVC = UIStoryboard(name: "VIP_page", bundle: nil).instantiateViewController(identifier: "VIP_page") as! VIPviewController
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print(viewController)
        let VCs = [FollowingVC, ingredientVC, poppularVC, editorChoiceVC, VIPVC]
        
        if viewController is FollowingRecipeViewController {
            
            return nil
        }
        
        return VCs[ VCs.firstIndex(of: viewController)! - 1]
    }
    
    // 現在表示されているページの、Afterに位置する、つまり右側に位置するviewを呼び出す関数
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print(viewController)
        
        let VCs = [FollowingVC, ingredientVC, poppularVC, editorChoiceVC, VIPVC]
        
        if viewController is VIPviewController {
            
            return nil
        }
        
        return VCs[ VCs.firstIndex(of: viewController)! + 1]
    }

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

}
