//
//  FollowingViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-09.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var followingsID:[String] = []
    var followings:[User] = []
    var followingsImages:[UIImage] = []

    let userDataManager = UserdataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.searchBar.delegate = self as? UISearchBarDelegate
        self.tableView.dataSource = self
        userDataManager.delegateFollowerFollowing = self
        userDataManager.delegate = self
        
        let parentVC = self.parent as! followerFollowingPageViewController
        followingsID = parentVC.followingsID
        userDataManager.getFollowersFollowings(IDs: self.followingsID, followerOrFollowing: "following")
       
         self.navigationItem.title = "Following"
        
        tableView.tableFooterView = UIView()
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

extension FollowingViewController: FolllowingFollowerDelegate {
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        
    }
    
    func assignFollowersFollowings(users: [User]) {
        self.followings = users
        self.tableView.reloadData()
    }
    
}


extension FollowingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "followingUser") as? followingUserTableViewCell)!
        
        if followings.isEmpty {
            cell.userNameLabel.text = "no following"
        } else {
            cell.userNameLabel.text = followings[indexPath.row].name
        }
        
        userDataManager.getUserImage(uid: self.followingsID[indexPath.row])
        
        cell.imgView?.contentMode = .scaleAspectFit
        cell.imgView.layer.masksToBounds = false
        cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
        cell.imgView.clipsToBounds = true
        
        if !followingsImages.isEmpty {
            cell.imgView.image = followingsImages[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension FollowingViewController: getUserDataDelegate {
    func gotUserData(user: User) {
        
    }
    
    func assignUserImage(image: UIImage) {
        self.followingsImages.append(image)
        self.tableView.reloadData()
    }
}
