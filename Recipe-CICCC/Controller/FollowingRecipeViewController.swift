//
//  FollowingRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-06.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class FollowingRecipeViewController: UIViewController {

    
    @IBOutlet weak var folowingTableView: UITableView!
    
    
    var creatorImageList = [UIImage]()
    var creatorNameList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatorImageList = [#imageLiteral(resourceName: "imageFile"),#imageLiteral(resourceName: "imageFile"),#imageLiteral(resourceName: "imageFile")]
        creatorNameList = ["Ruby Smith","Sherry Heni","Anne Casper"]
    }
    
}

extension FollowingRecipeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatorImageList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! FollowingRecipeTableViewCell
        cell.creatorImage.image = creatorImageList[indexPath.row]
        cell.createrName.text = creatorNameList[indexPath.row]
      
        //cell.recipeImage[indexPath.row][]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
//    func tableView(tableView: UITableView,
//        willDisplayCell cell: UITableViewCell,
//        forRowAtIndexPath indexPath: NSIndexPath) {
//
//        guard let tableViewCell = cell as? FollowingRecipeTableViewCell else { return }
//
//      //  FollowingRecipeTableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//    }
    
}
