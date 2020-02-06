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
    
    
    var subscribed = [UIImage]()
    var recipeImage = [[UIImage]]()
    var recipeTitle = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribed = [#imageLiteral(resourceName: "download (1)"),#imageLiteral(resourceName: "download (1)"),#imageLiteral(resourceName: "download (1)")]
        recipeImage = [[#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "77d08f50-3ccc-4432-a86d-4dcfdd3d7cd4"),#imageLiteral(resourceName: "190411-potato-salad-horizontal-1-1555688422"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "08COOKING-POTATO2-articleLarge-v2")],[#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "77d08f50-3ccc-4432-a86d-4dcfdd3d7cd4"),#imageLiteral(resourceName: "190411-potato-salad-horizontal-1-1555688422"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "08COOKING-POTATO2-articleLarge-v2")],[#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "77d08f50-3ccc-4432-a86d-4dcfdd3d7cd4"),#imageLiteral(resourceName: "190411-potato-salad-horizontal-1-1555688422"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "08COOKING-POTATO2-articleLarge-v2")]]
        recipeTitle = [["Title","Title","Title","Title","Title","Title"],["Title","Title","Title","Title","Title","Title"],["Title","Title","Title","Title","Title","Title"]]
    }
    
}

extension FollowingRecipeViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribed.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! FollowingRecipeTableViewCell
        return cell
    }
    
}
