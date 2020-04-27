//
//  FollowerViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-09.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var followersIDs: [String] = []
    var followers:[User] = []
    var followersImages: [UIImage] = []
    let userDataManager = UserdataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self as? UISearchBarDelegate
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        userDataManager.delegateFollowerFollowing = self
        userDataManager.delegate = self
        
        let parentVC = self.parent as! followerFollowingPageViewController
        followersIDs = parentVC.followersID
        userDataManager.getFollowersFollowings(IDs: self.followersIDs, followerOrFollowing: "follower")
        
        followersIDs.map {
             userDataManager.getUserImage(uid: $0)
        }
        
        
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.title = "Follower"
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


extension FollowerViewController: FolllowingFollowerDelegate {
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        
    }
    
    func assignFollowersFollowings(users: [User]) {
        self.followers = users
        self.tableView.reloadData()
    }
    
}


extension FollowerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "followerUser") as? follwerUserTableViewCell)!
        
        if followersIDs.isEmpty {
            cell.userNameLabel.text = "no follower"
        } else {
            cell.userNameLabel.text = followers[indexPath.row].name
        }
//        userDataManager.getUserImage(uid: self.followersIDs[indexPath.row])
        
        cell.imgView?.contentMode = .scaleAspectFit
        cell.imgView.layer.masksToBounds = false
        cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
        cell.imgView.clipsToBounds = true
        
        if followersIDs.count == followersImages.count {
            cell.imgView.image = followersImages[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension FollowerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "creatorProfile", bundle: nil).instantiateViewController(identifier: "creatorProfile") as! CreatorProfileViewController

        vc.id = followers[indexPath.row].userID
        tableView.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowerViewController: getUserDataDelegate {
    func gotUserData(user: User) {
        
    }
    
    func assignUserImage(image: UIImage) {
        self.followersImages.append(image)
        self.tableView.reloadData()
    }
}
