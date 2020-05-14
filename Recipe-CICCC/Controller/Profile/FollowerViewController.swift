//
//  FollowerViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-09.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class FollowerViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var followersIDs: [String] = []
    var followers:[User] = []
    var followersImages: [Int:UIImage] = [:]
    let userDataManager = UserdataManager()
    let dataManager = FollowingFollowerDataManager()
    var searchedFollowers:[User] = []
    var searchedFollowersImages:[Int:UIImage] = [:]
    var parentVC: followerFollowingPageViewController?
    
    var searchingWord : String = "" {
                didSet {
                    var count = 0
                    guard searchingWord != "" else {
                        return
                    }
                    
                   searchedFollowersImages.removeAll()
                   searchedFollowers.removeAll()
                   
                   for (index, user) in followers.enumerated() {
                       
                       if user.name.lowercased().contains(searchingWord.lowercased()) {
                           searchedFollowers.append(user)
                           searchedFollowersImages[count] = followersImages[index]
                            count += 1
                       }
                   }
                  
                }
            }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        userDataManager.delegateFollowerFollowing = self
//        userDataManager.delegate = self
        dataManager.delegate = self
        
        parentVC = self.parent as? followerFollowingPageViewController
        followersIDs = parentVC!.followersID
        dataManager.getFollowersFollowings(IDs: self.followersIDs, followerOrFollowing: "follower")
        
        followersIDs.enumerated().map {
            dataManager.getFollwersFollowingsImage(uid: $0.1, index: $0.0)
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




extension FollowerViewController: FollowingFollowerManagerDelegate {
    func assginFollowersFollowingsImages(image: UIImage, index: Int) {
        self.followersImages[index] = image
        self.searchedFollowersImages[index] = image
        self.tableView.reloadData()
    }
    
    func assignFollowersFollowings(users: [User]) {
        self.followers = users
        searchedFollowers = users
        self.tableView.reloadData()
    }
    
}


extension FollowerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedFollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "followerUser") as? follwerUserTableViewCell)!
        
        cell.delegate = self
        
        if followersIDs.isEmpty {
            cell.userNameLabel.text = "no follower"
        } else {
            cell.userID = searchedFollowers[indexPath.row].userID
            cell.userNameLabel.text = searchedFollowers[indexPath.row].name
        }
        
        
               if parentVC?.userID != Auth.auth().currentUser?.uid {
                   cell.userManageButton.isHidden = true
               } else {
               
                  cell.userManageButton.isHidden = false
              
               }
        
        cell.imgView?.contentMode = .scaleAspectFit
        cell.imgView.layer.masksToBounds = false
        cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
        cell.imgView.clipsToBounds = true
        
        if followersIDs.count == followersImages.count {
            cell.imgView.image = searchedFollowersImages[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension FollowerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "creatorProfile", bundle: nil).instantiateViewController(identifier: "creatorProfile") as! CreatorProfileViewController

        vc.id = followers[indexPath.row].userID
        tableView.deselectRow(at: indexPath, animated: true)

//        guard self.navigationController?.topViewController == self else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FollowerViewController: userManageDelegate {
    
    func pressedUserManageButton(uid: String) {
        
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            alertStyle = UIAlertController.Style.alert
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        let blockAction = UIAlertAction(title: "Block", style: .default, handler: { action in
            self.userDataManager.blockCreators(userID: uid)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        actionSheet.modalPresentationStyle = .popover

        self.present(actionSheet, animated: true, completion: nil)
    }
}


extension FollowerViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        let pageController = self.children[0] as! SearchingPageViewController
        searchingWord = searchBar.text!
        
        if searchingWord == "" {
            searchedFollowers.removeAll()
            searchedFollowersImages.removeAll()
          
            searchedFollowersImages = followersImages
            searchedFollowers = followers
            
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
