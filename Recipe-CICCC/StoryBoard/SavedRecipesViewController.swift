//
//  SavedRecipesViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-15.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class SavedRecipesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var savedRecipes: [RecipeDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
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

extension SavedRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "savedRecipe", for: indexPath) as? SavedRecipesCollectionViewCell)
        
//        cell!.imageView.image = savedRecipes[indexPath.row].image
        
        return cell!
    }
    
    
}
