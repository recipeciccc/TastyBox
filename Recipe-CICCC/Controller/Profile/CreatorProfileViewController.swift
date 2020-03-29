//
//  CreatorProfileViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-29.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class CreatorProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var id: String?
    
    var recipeList = [RecipeDetail]()
    var imageList = [UIImage]()
    var followers:[User] = []
    var following:[User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creatorsProfie", for: indexPath) as? profieTableViewCell)!
            cell.imageView!.layer.masksToBounds = false
            cell.imageView!.layer.cornerRadius = cell.imageView!.bounds.width / 2
            cell.imageView!.clipsToBounds = true
            
            
            return cell
        }
            
        else if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "number", for: indexPath) as? NumOfCreatorhasTableViewCell)!
            cell.NumOfPostedButton.setTitle("\(recipeList.count) \nPosted", for: .normal)
            return cell
        }
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeItemForUser", for: indexPath) as? RecipeItemCollectionViewTableViewCell)!
//            cell.delegate = self
//        
//         if recipeList.count != 0{
//                   cell.recipeData = recipeList
//
//                   if imageList.count >= recipeList.count {
//                       cell.recipeImage = imageList
//                       cell.collectionView.reloadData()
//                   }
//               }
        return cell
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
