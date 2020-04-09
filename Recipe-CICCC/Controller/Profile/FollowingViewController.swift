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

    let userDataManager = UserdataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.searchBar.delegate = self as? UISearchBarDelegate
        self.tableView.dataSource = self
        userDataManager.delegateFollowerFollowing = self
        
        let parentVC = self.parent as! followerFollowingPageViewController
        followingsID = parentVC.followingsID
        userDataManager.getFollowersFollowings(IDs: self.followingsID, followerOrFollowing: "following")
        
         self.navigationItem.title = "Following"
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
        let cell = (tableView.dequeueReusableCell(withIdentifier: "followingUser") as? followingUserTableViewCell )!
        
        if followings.isEmpty {
            cell.userNameLabel.text = "no following"
        } else {
            cell.userNameLabel.text = followings[indexPath.row].name
        }
        
        return cell
    }
    
    
}
