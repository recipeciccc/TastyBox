//
//  CreatorProfileViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-29.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

class CreatorProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //    var id: String?
    var id = "3AsWJvUdZkQNPX0pukMcNDabnK53"
    var userName:String = ""
    
    var recipeList = [RecipeDetail]()
    var imageList = [UIImage]()
    var urlList = [String]()
    var ridList = [String]()
    var followers:[User] = []
    var following:[User] = []
    
    let fetchData = FetchRecipeData()
    let fetchImage = FetchRecipeImage()
    let dataManager = UserdataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        fetchData.delegate = self
        fetchImage.delegate = self
        dataManager.delegate = self
        
        dataManager.getUserDetail(id: id)
        
        let db = Firestore.firestore()
        let queryRef = db.collection("recipe").whereField("userID", isEqualTo: id as Any).order(by: "time", descending: true)
        recipeList = fetchData.Data(queryRef: queryRef)
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
            
            cell.imageView!.layer.masksToBounds = false
            cell.imageView!.layer.cornerRadius = cell.imageView!.bounds.width / 2
            cell.imageView!.clipsToBounds = true
            
            
            cell.creatorNameLabel.text = userName
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "number", for: indexPath) as? NumOfCreatorhasTableViewCell)!
            cell.NumOfPostedButton.setTitle("\(recipeList.count) \nPosted", for: .normal)
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
            //        case 2:
        //            return 38
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
        
        //        recipeList.map {
        //            imageList.append($0.image!)
        //        }
        
        if imageList.count == 0 {
            
            get_url_rid()
            fetchImage.getImage(uid: id, rid: ridList, imageUrl: urlList)
            if imageList.count == 0{
                tableView.reloadData()
            }
        }
    }
    
    func reloadImg(img:[UIImage]){
        imageList = img
        self.tableView.reloadData()
    }
}

extension CreatorProfileViewController : getUserDataDelegate {
    //    func gotUsersData(users: [User]) {
    //        <#code#>
    //    }
    //
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
        vc.userProfile = true
        vc.recipe = recipeList[data.row]
        vc.mainPhoto = imageList[data.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CreatorProfileViewController: AddingFollowersDelegate {
    func increaseFollower(followerID: String) {
        self.dataManager.increaseFollower(userID: id, followerID: followerID)
        tableView.reloadData()
    }
}
