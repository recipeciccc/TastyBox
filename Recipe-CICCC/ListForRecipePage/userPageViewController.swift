//
//  userPageTableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-12-07.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class userPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var profileTableVIew: UITableView!
    let fetchData = FetchRecipeData()
    let fetchImage = FetchRecipeImage()
    let uid = Auth.auth().currentUser?.uid
    var recipeList = [RecipeDetail]()
    var imageList = [UIImage]()
    var urlList = [String]()
    var ridList = [String]()
   
    
    let buttons = ButtonsList()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
        profileTableVIew.delegate = self
        profileTableVIew.dataSource = self
        
        fetchData.delegate = self
        fetchImage.delegate = self
        
        let db = Firestore.firestore()
        let queryRef = db.collection("recipe").whereField("userID", isEqualTo: uid as Any).order(by: "time", descending: true)
        recipeList = fetchData.Data(queryRef: queryRef)
    }
    

    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 3 //4
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "Main User Page", for: indexPath) as? mainUserProfileTableViewCell)!
            cell.userImageView.layer.masksToBounds = false
            cell.userImageView.layer.cornerRadius = cell.userImageView.bounds.width / 2
            cell.userImageView.clipsToBounds = true
            return cell
        }
            
        else if section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "show the num", for: indexPath) as? NumberTableViewCell)!
            cell.numOfRecipeUserPostedButton.setTitle("\(recipeList.count) \nPosted", for: .normal)
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeItemForUser", for: indexPath) as? userRecipeItemTableViewCell)!
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
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 135
        case 1:
            return 60
            //        case 2:
        //            return 38
        case 2:
            return self.view.frame.height - ((self.view.frame.origin.y) * -1)
        //return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let buttonTitle = buttons.buttons[indexPath.row].titleButton
        //
        //        if buttonTitle == "Shopping List" {
        //            let segue = self.performSegue(withIdentifier: "to Shopping List", sender:nil)
        //            let distination =  segue.destination as! ShoppingListTableViewController
        //
        //        }
    }
    
    @IBAction func postedButtonTapped(_ sender: Any) {
        self.view.frame.origin.y = -195.0
    }
    
}

extension userPageViewController: ReloadDataDelegate{
    func reloadData(data:[RecipeDetail]) {
        recipeList = data
        get_url_rid()
        fetchImage.getImage(uid: uid!, rid: ridList, imageUrl: urlList)
        if imageList.count == 0{
           profileTableVIew.reloadData()
        }
    }
    func reloadImg(img:[UIImage]){
        imageList = img
        profileTableVIew.reloadData()
    }
    
    func get_url_rid(){
        if recipeList.count != 0{
            for data in recipeList{
                urlList.append(data.image)
                ridList.append(data.recipeID)
                print(data.recipeID)
            }
        }
    }
}

extension userPageViewController: CollectionViewInsideUserTableView{
    func cellTaped(data: IndexPath) {
        
        let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
        vc.userProfile = true
        vc.ridList = ridList
        vc.recipe = recipeList[data.row]
        vc.mainPhoto = imageList[data.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
