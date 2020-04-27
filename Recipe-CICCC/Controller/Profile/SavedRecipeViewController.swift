//
//  SavedRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-15.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class SavedRecipeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let reuseIdentifier = "Cell"
    
    var savedIDs: [String] = []
    var savedRecipes:[RecipeDetail] = []
    var savedRecipesImages:[Int:UIImage] = [:]
    var users:[User] = []
    
    var isSavingRecipe: Bool?
    var savingRecipeID: String?
    let dataManger = savingRecipesDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataManger.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.title = "Saved"
        
        if isSavingRecipe == nil { isSavingRecipe = false }
        
        if isSavingRecipe! {
           
            let alertController = UIAlertController(title: "Save it?", message: "", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dataManger.saveRecipe(recipeID: self.savingRecipeID!)
                // call the fucntions to retrieve recipeId and recipeimage
                self.collectionView.reloadData()
            })
            alertController.addAction(yesAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            })
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        
    }
         dataManger.Data(recipeID: savedIDs)
        
        
        
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

extension SavedRecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return savedRecipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "savedRecipes", for: indexPath) as? SavedRecipesCollectionViewCell)!
    
        // Configure the cell
        cell.imageView.image = savedRecipesImages[indexPath.row]
        
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
        
        vc.recipe = savedRecipes[indexPath.row]
        vc.mainPhoto = savedRecipesImages[indexPath.row]!
        vc.creator = self.users[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2) / 3
        let height = width
        return CGSize(width: width, height: height)
    }
    
}

extension SavedRecipeViewController: SavedRecipeDelegate {
    func gotUserData(user: User) {
        users.append(user)
    }
    
    func reloadData(data: [RecipeDetail]) {
        self.savedRecipes = data
    }
    
    func reloadImg(img: UIImage, index: Int) {
        self.savedRecipesImages[index] = img
        self.collectionView.reloadData()
    }
}

