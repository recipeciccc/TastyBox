//
//  followerFollowingPageViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-08.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class followerFollowingPageViewController: UIPageViewController {
    
    var titleVC: String?
    var userID: String?
    var followersID: [String] = []
    var followingsID: [String] = []
    var VCs: [UIViewController] = []
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        let followingVC = storyboard?.instantiateViewController(identifier: "following") as! FollowingViewController
        let followerVC = storyboard?.instantiateViewController(identifier: "follower") as! FollowerViewController

        
        VCs = [followingVC, followerVC]
        
        self.navigationItem.title = titleVC!
        self.setViewControllers([returnVC(followerOrFollowing: titleVC!)], direction: .forward, animated: true, completion: nil)
        
    }
    
    private func returnVC(followerOrFollowing: String) -> UIViewController {
        if followerOrFollowing == "Following" {
            return storyboard?.instantiateViewController(identifier: "following") as! FollowingViewController
        }
        
        return storyboard?.instantiateViewController(identifier: "follower") as! FollowerViewController
        
        
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

extension followerFollowingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: FollowingViewController.self) {
            return nil
        }
        
        return storyboard?.instantiateViewController(identifier: "following") as! FollowingViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: FollowerViewController.self) {
            
            return nil
        }
        return storyboard?.instantiateViewController(identifier: "follower") as! FollowerViewController
    }
    
    
}

extension followerFollowingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let vc = self.viewControllers?[0]
        self.navigationItem.title = vc?.navigationItem.title
        
    }
}

extension followerFollowingPageViewController: passTheIDsDelegate {
    func passTheIDsDelegate(IDs: [String]) {
        
    }

}
