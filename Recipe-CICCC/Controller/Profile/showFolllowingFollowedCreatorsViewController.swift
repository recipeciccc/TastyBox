//
//  showFolllowingFollowedCreatorsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-21.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class showFolllowingFollowedCreatorsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var followerTableView = UITableView()
    var followingTableView = UITableView()
    
    //    var user: User?
    var titleVC: String?
    var userID: String?
    
    var followersID: [String] = []
    var followingID: [String] = []
    var followers: [User] = []
    var following: [User] = []
    
    
    let dataManager = UserdataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        user = User(userID: "jkfl;da", name: "Test", followersID: <#[String]#>)
        
        searchBar.delegate = self
        scrollView.delegate = self
        dataManager.delegateFollowerFollowing = self
        
        self.navigationItem.title = titleVC
        
        if titleVC == "Following" {
            self.scrollView.contentOffset.x = self.scrollView.frame.size.width
        }
        
        self.navigationItem.title = titleVC
        
        addTableView()
//        dataManager.findFollowerFollowing(id: userID!, collection: "following")
//        dataManager.findFollowerFollowing(id: userID!, collection: "follower")
            
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    
    
    func addTableView() {
        let scrollViewWidth = scrollView.frame.width
        let scrollViewHeight = scrollView.frame.height
        
        scrollView.contentSize = CGSize(width: scrollViewWidth * 2, height: scrollViewHeight)
        
        //        followerTableView.tableFooterView = UIView()
        //        followingTableView.tableFooterView = UIView()
        //
        followerTableView = UITableView(frame: CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight), style: .plain)
        followingTableView = UITableView(frame: CGRect(x: scrollViewWidth, y: 0, width: scrollViewWidth, height: scrollViewHeight), style: .plain)
        
        followerTableView.backgroundColor = .cyan
        followingTableView.backgroundColor = .red
        
        followerTableView.tableFooterView = UIView()
        followingTableView.tableFooterView = UIView()
        
        let lagel = UILabel()
        
        followerTableView.register(FollowingUserTableViewCell.self, forCellReuseIdentifier: "follower")
        followingTableView.register(FollowingUserTableViewCell.self, forCellReuseIdentifier: "followingUser")
        
        
        
        scrollView.addSubview(followerTableView)
        scrollView.addSubview(followingTableView)
        
        
        followerTableView.dataSource = self
        followingTableView.dataSource = self
        
    }
    
    
    func createFollowerTableview() {
        
        
    }
    
    func createFollowingTableview() {
        
    }
    
}

extension showFolllowingFollowedCreatorsViewController: FolllowingFollowerDelegate {
    func assignFollowersFollowings(users: [User]) {
        
    }

    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        self.followersID = followersIDs
        self.followingID = followingsIDs
        
        
        // MARK: Problem!
        // can get the ids and pass them
        // firebase skip implementation once, if the fuction to retrieve data is called in viewDidLoad,
        // it is executed. but the fuction below is not. Therefore it doesnt retrieve user data from firebase.
        // i moved it to viewDidLoad once, but when it is called, self.followingID is empty.
//        self.dataManager.getFollowersFollowings(followingsIDs: self.followingID, followersIDs: self.followingID)
    }

    
    
}

extension showFolllowingFollowedCreatorsViewController: UISearchBarDelegate {
    
}

extension showFolllowingFollowedCreatorsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.frame.size.width {
            self.navigationItem.title = "Following"
        }
        else if scrollView.contentOffset.x == 0 {
            self.navigationItem.title = "Follower"
        }
        
    }
}

extension showFolllowingFollowedCreatorsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == followerTableView {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == followerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "follower") as! FollowingUserTableViewCell
            
            
            cell.userImage.clipsToBounds = true
            cell.userImage.layer.masksToBounds = false
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2
            
            cell.label.text = "test"
            
            return cell
        }
        
        if tableView == followingTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "followingUser") as! FollowingUserTableViewCell
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "followingUser") as! FollowingUserTableViewCell
            //            cell?.textLabel?.text = "followingTableView"
            //           cell.user = User(userID: "jkfl;da", name: "Test")
            cell.userImage.clipsToBounds = true
            cell.userImage.layer.masksToBounds = false
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height / 2
            
            if !following.isEmpty {
                cell.label.text = following[indexPath.row].name
            }
            //            cell.user = user.followingUsers[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
}



