//
//  TableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-19.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreatorProfileTableViewController: UITableViewController {
    
    
    
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    var user: User?
    let recipeItemList = RecipeItemList()
    let images: [UIImage] = [#imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "images"), #imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "breakfast-450x310"), #imageLiteral(resourceName: "images")]
    let dataManager = UserdataManager()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "recipeItem")
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "creatorsProfie")
        
        let app = UINavigationBarAppearance()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3 //4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //        if section == 0 || section == 1 || section == 3{
        //            return 1
        //        }
        //        else if section == 2 {
        //            return recipeItemList.recipeItemList.count
        //        }
        //        else {
        //            return 0
        //        }
        return 1
    }
    
    
    
    // about deta the cell has
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creatorsProfie") as? profieTableViewCell)!
            
            cell.imgView.layer.masksToBounds = false
            cell.imgView.layer.cornerRadius = cell.imgView.bounds.width / 2
            cell.imgView.clipsToBounds = true
            cell.delegate = self
            cell.userID = user?.userID
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "number") as? NumOfCreatorhasTableViewCell)!
            
            return cell
        }
            //        else if indexPath.section == 2 {
            //
            //            let cell : recipeListCreatorItemTableViewCell =  (tableView.dequeueReusableCell(withIdentifier: "recipeItem") as? recipeListCreatorItemTableViewCell)!
            //
            ////            if cell==nil {
            ////                cell = UITableViewCell(style: .default, reuseIdentifier: "recipeItem")
            ////            }
            ////
            //
            //              let _ = recipeItemList.recipeItemList[indexPath.row]
            //
            ////              if let label1000 = cell!.viewWithTag(1000) as? UILabel {
            ////                  label1000.text = RecipeListCreator.creatorRecipeLists[indexPath.row].textTest
            ////              }
            //
            //            cell.nameRecipeLabel.text =  recipeItemList.recipeItemList[indexPath.row].recipeName
            //            cell.numLikesLabel.text = String(recipeItemList.recipeItemList[indexPath.row].numOfLike)
            //
            //
            //              //tableView.deselectRow(at: indexPath, animated: true)
            //            //cell.backgroundColor = .green
            //
            //            return cell
            //
            //
            //
            //        }
            
        else if indexPath.section == 2 { //3 {
            let cell : RecipeItemCollectionViewTableViewCell =  (tableView.dequeueReusableCell(withIdentifier: "collectionView") as? RecipeItemCollectionViewTableViewCell)!
            //            let collectionView: =
            
            
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView.cellForRow(at: indexPath) means it return the cell user tapped
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = recipeItemList.recipeItemList[indexPath.row]
            // tableView.deselectRow(at: indexPath, animated: true) stop highlighting the cell after user release finger.
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        //RecipeListCreator.creatorRecipeLists.remove(at: indexPath.row)
    //        let indexPaths = [indexPath]
    //        tableView.deleteRows(at: indexPaths, with: .automatic)
    //    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 135.0
        }
        else if indexPath.section == 1 { //2 {
            //return 150.0
            //            return 50.0
            return UITableView.automaticDimension
            
        }
        //        } else if indexPath.section == 3 {
        //            return 435 // it needs to be until the end of the screen and if the items inside are more than the border, it should become bigger.
        //        }
        // return tableView.frame.height - 135.0
        
        return self.view.frame.height - ((self.view.frame.origin.y) * -1)
    }
    
    
    
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
    //        tableView.bounds.size.width, height: 28))
    //        headerLabel.textColor = UIColor.black
    //
    //        headerLabel.textAlignment = .left
    //
    //
    //        let view:UIView = UIView(frame: CGRect(x: 0,y: 0,width: self.tableView.frame.size.width,height: 40.0))
    //        if section == 0 || section == 1{
    //            return view
    //        } else {
    //            view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.768627451, blue: 0.4431372549, alpha: 1)
    //            // how can I set color of text?
    //
    //            view.addSubview(headerLabel)
    //            headerLabel.text = "Recipe"
    //            headerLabel.sizeToFit()
    //            headerLabel.textColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    //            headerLabel.frame.origin.y = view.frame.size.height/2-headerLabel.frame.size.height/2
    //            //headerLabel.frame.origin.y = view.frame.size.height/2
    //            //view.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
    //            return view
    //        }
    //    }
    
    //    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
    //        if let headerView = view as? UITableViewHeaderFooterView {
    //            headerView.textLabel?.textColor = UIColor.red
    //        }
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipePage Segue" {
            if let recipeVC = segue.destination as? recipeItemTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let item = recipeItemList.recipeItemList[indexPath.row]
                    recipeVC.item = item
                    recipeVC.indexPath = indexPath
                }
            }
        }
    }
    
    
    
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        guard let tableViewCell = cell as? RecipeItemCollectionViewTableViewCell else { return }
    //
    //        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    //    }
    
    
    
}


extension CreatorProfileTableViewController: AddingFollowersDelegate {
    func increaseFollower(userID: String, followerID: String) {
        dataManager.increaseFollower(userID: userID, followerID: followerID)
        tableView.reloadData()
    }
    
}

//extension TableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    public func collectionView(_ collectionView: UICollectionView,
//        numberOfItemsInSection section: Int) -> Int {
//        print("item")
//        return images.count
//
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        print("numberof")
//        return 1
//    }
//
//    public func collectionView(_ collectionView: UICollectionView,
//                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("cell")
//        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "recipeItem", for: indexPath) as? TestCollectionViewCell)!
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout.minimumLineSpacing = 5.0
//        layout.minimumInteritemSpacing = 2.5
//        
//        let numberOfItemsPerRow: CGFloat = 2.0
//        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsPerRow
//        
//        return CGSize(width: itemWidth, height: itemWidth)
//    }

//}



/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */



