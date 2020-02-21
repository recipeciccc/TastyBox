//
//  showFolllowingFollowedCreatorsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-21.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class showFolllowingFollowedCreatorsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    @IBAction func swipeLeftAciton(_ sender: UISwipeGestureRecognizer) {
        if UISwipeGestureRecognizer.Direction.left == .left {
//            let vc: showFollowedViewController = showFollowedViewController()
//            navigationController?.pushViewController(vc, animated: true)
            performSegue(withIdentifier: "showFollowing", sender: nil)
            
            
        }
    }
    
    @IBAction func swipeRightAction(_ sender: UISwipeGestureRecognizer) {
        if UISwipeGestureRecognizer.Direction.right == .right {
            //let vc: showFolllowingFollowedCreatorsViewController = showFolllowingFollowedCreatorsViewController()
           performSegue(withIdentifier: "showFollowers", sender: nil)
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
