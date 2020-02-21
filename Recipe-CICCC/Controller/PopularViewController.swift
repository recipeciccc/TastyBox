//
//  PopularViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {

    @IBOutlet weak var collectionView: RecipeCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.imageArray = [#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "Lemon-Garlic-Butter-Salmon-with-Zucchini-Noodles-recipes"),#imageLiteral(resourceName: "candied-yams-5"),#imageLiteral(resourceName: "best-salad-7"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055"),#imageLiteral(resourceName: "Intrepid-Travel-Taiwan-dumplings-Xiao-Long-Bao_577219075"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723")]
        collectionView.recipeName = ["Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:"]
        // Do any additional setup after loading the view.
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
