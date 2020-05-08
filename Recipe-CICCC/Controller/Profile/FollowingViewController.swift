//
//  FollowingViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-09.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var followingsID:[String] = []
    var followings:[User] = []
    var followingOrNot = [Int:Bool]()
    var followingsImages:[Int:UIImage] = [:]
    var searchedFollowings:[User] = []
    var searchedFollowingsImages:[Int:UIImage] = [:]
    
    let userDataManager = UserdataManager()
    let dataManager = FollowingViewControllerDataManager()
    
    var searchingWord : String = "" {
             didSet {
                 
                 guard searchingWord != "" else {
                     return
                 }
                 
                searchedFollowingsImages.removeAll()
                searchedFollowings.removeAll()
                
                for (index, user) in followings.enumerated() {
                    
                    if user.name.lowercased().contains(searchingWord.lowercased()) {
                        searchedFollowings.append(user)
                        searchedFollowingsImages[searchedFollowingsImages.count - 1] = followingsImages[index]
                    }
                }
               
             }
         }
    
    var parentVC: followerFollowingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        userDataManager.delegateFollowerFollowing = self
       
        
        parentVC = self.parent as? followerFollowingPageViewController
        followingsID = parentVC!.followingsID
        userDataManager.getFollowersFollowings(IDs: self.followingsID, followerOrFollowing: "following")
        
        followingsID.enumerated().map {
            userDataManager.getFollwersFollowingsImage(uid: $0.1, index: $0.0)
        }
        
        self.navigationItem.title = "Following"
        
        for index in 0 ..< followingsID.count {
            followingOrNot[index] = true
        }
        
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.navigationController == nil {
           //view controller was dismissed
            
            for index in 0 ..< followings.count {
                if followingOrNot[index] == false {
                    dataManager.unfollowing(user: followings[index])
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func followingManagement(_ sender: UIButton) {
        let cell = sender.superview?.superview as! followingUserTableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        
        if followingOrNot[indexPath!.row] == true {
            followingOrNot[indexPath!.row] = false
            sender.setTitle("Following", for: .normal)
            
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = .orange
                       
        } else {
            followingOrNot[indexPath!.row] = true
            sender.setTitle("Unfollow", for: .normal)
           
            sender.backgroundColor = .white
            sender.setTitleColor(#colorLiteral(red: 1, green: 0.6430701613, blue: 0, alpha: 1), for: .normal)
            sender.layer.borderWidth = 2
            sender.layer.borderColor = #colorLiteral(red: 1, green: 0.6430701613, blue: 0, alpha: 1)
        }
        
        print(followingOrNot)
    }
}




extension FollowingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedFollowings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "followingUser") as? followingUserTableViewCell)!
        cell.delegate = self
        
        if followings.isEmpty {
            cell.userNameLabel.text = "no following"
        } else {
            cell.userID = searchedFollowings[indexPath.row].userID
            cell.userNameLabel.text = searchedFollowings[indexPath.row].name
        }
        
        if parentVC?.userID != Auth.auth().currentUser?.uid {
            cell.followingButton.isHidden = true
        } else {
        
            cell.followingButton.setTitle("Unfollow", for: .normal)
       
        }
        
        if followingsID.count == searchedFollowingsImages.count{
            cell.imgView.image = searchedFollowingsImages[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension FollowingViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "creatorProfile", bundle: nil).instantiateViewController(identifier: "creatorProfile") as! CreatorProfileViewController
        
        vc.id = searchedFollowings[indexPath.row].userID
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowingViewController: FolllowingFollowerDelegate {
    func assginFollowersFollowingsImages(image: UIImage, index: Int) {
        self.followingsImages[index] = image
        self.searchedFollowingsImages[index] = image
            self.tableView.reloadData()
    }
    
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        
    }
    
    func assignFollowersFollowings(users: [User]) {
        self.followings = users
        self.searchedFollowings = users
        self.tableView.reloadData()
    }
    
}

extension FollowingViewController: userManageDelegate {
    func pressedUserManageButton(uid: String) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "Block", style: .default, handler: { action in
            self.userDataManager.blockCreators(userID: uid)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}


extension FollowingViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        let pageController = self.children[0] as! SearchingPageViewController
        searchingWord = searchBar.text!
        
        if searchingWord == "" {
            searchedFollowings.removeAll()
            searchedFollowingsImages.removeAll()
          
            searchedFollowingsImages = followingsImages
            searchedFollowings = followings
            
            tableView.reloadData()
        }
        
         tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchingWord = searchBar.text!
        
        searchBar.resignFirstResponder()
    }
}
