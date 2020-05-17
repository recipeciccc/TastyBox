//
//  CreatorProfileViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-29.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import Crashlytics

class CreatorProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var id: String?
    var userName:String = ""
    var creatorImage: UIImage?
    var isFollowing: Bool?
    var isBlocked: Bool?
    var isBlocking: Bool?
    
    var recipeList = [RecipeDetail]()
    var imageList = [UIImage]()
    var urlList = [String]()
    var ridList = [String]()
    var followers:[String] = []
    var following:[String] = []
    
    let fetchData = FetchRecipeData()
    let fetchImage = FetchRecipeImage()
    let userDataManager = UserdataManager()
    let dataManager = CreatorProfileDataManager()
    var detailBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // table view settings
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        
        // navigation bar button item settings
        detailBarButton = UIBarButtonItem(title: "∙∙∙", style: .plain, target: self, action: #selector(showsChoice))
        
        self.navigationItem.rightBarButtonItem = detailBarButton
        
        // during fetching data
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = #colorLiteral(red: 0.9977325797, green: 0.9879661202, blue: 0.7689270973, alpha: 1)
        view.tag = 100
        
        let  indicator = UIActivityIndicatorView()
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        indicator.color = .orange
        indicator.startAnimating()
        
        view.addSubview(indicator)
        indicator.center = self.view.center
        
        self.view.addSubview(view)
        
        
        // fetching data settings
        fetchData.delegate = self
        fetchImage.delegate = self
        userDataManager.delegate = self
        userDataManager.delegateFollowerFollowing = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userDataManager.checkUserStatus(ID: id!)
        
        userDataManager.getUserDetail(id: id!)
        
        userDataManager.findFollowerFollowing(id: id!)
        
        userDataManager.getUserImage(uid: id!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.navigationController == nil {
            //view controller was dismissed
            
            if let isFollowing = isFollowing {
                if isFollowing == false {
                    dataManager.unfollowing(userID: id!)
                }
            }
            
            self.following.removeAll()
            self.followers.removeAll()
            self.isFollowing = nil
            self.isBlocked = nil
        }
    }
    
    @objc func showsChoice() {
        var alertStyle = UIAlertController.Style.actionSheet
        if (UIDevice.current.userInterfaceIdiom == .pad) {
          alertStyle = UIAlertController.Style.alert
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: alertStyle)
        
        let alert = UIAlertController(title: "Are you sure?", message: "This acount wouldn't be able to follow you and would be disabled when several people block it. Do you really block this account?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.userDataManager.blockCreators(userID: self.id!)
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! profieTableViewCell
            cell.followingManagement(isFollowing: false)
            self.isBlocking = true
            self.isFollowing = false
            print(self.followers)
            self.userDataManager.findFollowerFollowing(id: self.id!)
            //            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        let blockingAction = UIAlertAction(title: "Block", style: .destructive, handler: { action in
            
            self.present(alert, animated: true, completion: nil)
        })
        
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: { action in
            self.reportAlert()
        })
        
        
        actionSheet.addAction(blockingAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
                
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func reportAlert(){
        let alertController = UIAlertController(title: "Report Issue", message: "You can report this user with email if you judge this user is abusive.", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        let disagreeAction = UIAlertAction(title: "Agree", style: .default, handler: { action in
            self.emailComposer()
        })
        alertController.addAction(agreeAction)
        alertController.addAction(disagreeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func emailComposer(){
        if MFMailComposeViewController.canSendMail() == true {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["recipeciccc@gmail.com"])
            
            
            composer.setSubject("Report recipe - ID:\(id!)")
            composer.setMessageBody("Why do you think this user is abusive or objectionable? (sexual/ violent/ harmful/ spam/ infringes rights)\n\n\nPlease write down your concerns, we will review it to determine whether it violate community guidlines. By TastyBox Team", isHTML: false)
            present(composer,animated:true)
        }else{
            return
        }
        
    }
    
    @IBAction func postedButtonAction(_ sender: Any) {
        
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let nextVC = segue.destination as? followerFollowingPageViewController {
            
            nextVC.userID = id
            nextVC.followersID = followers
            nextVC.followingsID = following
            
            if segue.identifier == "following" {
                
                nextVC.titleVC = "Following"
                
            }
            if segue.identifier == "follower" {
                
                nextVC.titleVC = "Follower"
                
            }
        }
        
    }
    
    
}

extension CreatorProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creatorsProfie", for: indexPath) as? profieTableViewCell)!
            cell.delegate = self
            
            cell.creatorImageView!.image = self.creatorImage
            cell.creatorNameLabel.text = userName
    
            
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "number", for: indexPath) as? NumOfCreatorhasTableViewCell)!
            cell.NumOfPostedButton.setTitle("\(recipeList.count) \nPosted", for: .normal)
            
            cell.NumOffollowingButton.setTitle("\(following.count) \nfollowing", for: .normal)
            
            cell.NumOFFollwerButton.setTitle("\(followers.count) \nfollower", for: .normal)
            
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "collectionView", for: indexPath) as? RecipeItemCollectionViewTableViewCell)!
        cell.delegate = self
        
        if recipeList.count != 0{
            cell.recipeData = recipeList
            
            if imageList.count >= recipeList.count {
                cell.recipeImage = imageList
                cell.collectionView.reloadData()
            }
        }
        
        return cell
    }
    
    
}

extension CreatorProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 135
        case 1:
            return 60
        default:
            
            if recipeList.isEmpty {
                return self.view.frame.size.height - 195.0
            }
            
            return self.view.frame.height - ((self.view.frame.origin.y) * -1)
        }
    }
}

extension CreatorProfileViewController: ReloadDataDelegate{
    
    func reloadData(data:[RecipeDetail]) {
        
        recipeList = data
        
        if imageList.count == 0 {
            
            get_url_rid()
            fetchImage.getImage(uid: id!, rid: ridList)
            
            if imageList.count == 0{
                tableView.reloadData()
            }
        }
    }
    
    func reloadImg(img:[UIImage]){
        imageList = img
        
        UIView.transition(with:self.tableView, duration: 0.3, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
           self.tableView.reloadData()

        }, completion: nil)
        
       
    }
}

extension CreatorProfileViewController : getUserDataDelegate {
    func assignUserImage(image: UIImage) {
        self.creatorImage = image
        self.tableView.reloadData()
    }
    
    func gotUserData(user: User) {
        
        userName = user.name
        self.tableView.reloadData()
        
    }
    
    func get_url_rid(){
        if recipeList.count != 0{
            for data in recipeList{
                urlList.append(data.image!)
                ridList.append(data.recipeID)
                print(data.recipeID)
            }
        }
    }
}

extension CreatorProfileViewController: CollectionViewInsideUserTableView {
    func cellTaped(data: IndexPath) {
        let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
        vc.userProfile = false
        vc.recipe = recipeList[data.row]
        vc.mainPhoto = imageList[data.row]
        
        guard self.navigationController?.topViewController == self else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CreatorProfileViewController: FolllowingFollowerDelegate {
    func statusUsers(isBlocked: Bool, isBlocking: Bool, isFollowing: Bool) {
        print("status users isFollowing:\(isFollowing)")
        print("status users isBlocking:\(isBlocking)")
        self.isBlocked = isBlocked
        self.isBlocking = isBlocking
        
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! profieTableViewCell
        
        if !isBlocked  {
            
            let db = Firestore.firestore()
            let queryRef = db.collection("recipe").whereField("userID", isEqualTo: id! as Any).order(by: "time", descending: true)
            recipeList = fetchData.Data(queryRef: queryRef)
            
            
            cell.followingManagement(isFollowing: isFollowing)
            self.isFollowing = isFollowing
            
        } else {
            
            cell.followMeButton.isHidden = true
        }
        
        
    }
    
    
    func passFollowerFollowing(followingsIDs: [String], followersIDs: [String]) {
        self.following.removeAll()
        self.followers.removeAll()
        
        self.following = followingsIDs
        self.followers = followersIDs
        
        self.tableView.reloadData()
    }
}


extension CreatorProfileViewController: followingManageDelegate {
    func unfollow() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "Do you really unfollow this account?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Unfollow", style: .destructive, handler: { action in
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! profieTableViewCell
            cell.followingManagement(isFollowing: false)
            self.isFollowing = false
//            self.userDataManager.findFollowerFollowing(id: self.id!)
            //            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func increaseFollower() {
        //
        if let isBlocking = self.isBlocking {
            if isBlocking {
                
                let alert = UIAlertController(title: "You are blocking this user.", message: "This user will be deleted from your block users list. Do you really follow this account?", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Follow", style: .default, handler: { action in
                    
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! profieTableViewCell
                    cell.followingManagement(isFollowing: true)
                    self.isFollowing = true
                    self.isBlocking = false
                    self.userDataManager.increaseFollower(followingID: self.id!)
                    self.userDataManager.findFollowerFollowing(id: self.id!)
                    //            self.tableView.reloadData()
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                })
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.userDataManager.increaseFollower(followingID: self.id!)
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! profieTableViewCell
                cell.followingManagement(isFollowing: true)
                self.isFollowing = true
                self.isBlocking = false
            }
        }
    
    }
}

extension CreatorProfileViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        @unknown default:
            print("default")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
