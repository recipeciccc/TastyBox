//
//  SearchingPageViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

class SearchingPageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let ingredientVC = storyboard?.instantiateViewController(identifier: "ingredientVC") as! SearchingIngredientsViewController
        self.setViewControllers([ingredientVC], direction: .forward, animated: true,completion: nil)
        
        // tapによるページめくりを担当するインスタンスを取得
//        let tapGestureRecognizer = self.gestureRecognizers.filter{ $0 is UITapGestureRecognizer }.first as! UITapGestureRecognizer
        
//        tapGestureRecognizer.isEnabled = false
        
        
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

