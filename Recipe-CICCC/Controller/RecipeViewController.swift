//
//  RecipeViewController.swift
//  RecipeDiscovery
//
//  Created by fangyilai on 2019-10-29.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class RecipeViewController: UIViewController {
    
    let dataManager = RecipeViewControllerDataManager()
    let db = Firestore.firestore()
    
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var collectionRef: UICollectionView!
    
    //    var recipeImages = [UIImage]()
    var recipeLabels = [String]()
    
    var category:Int = 0
    var T_image = UIImage()
    var T_Name = ""
    var CollectionImage = [UIImage]()
    var CollectionLabel = [String]()
    var EdgeOfCollectionView: CGFloat = 0
    
    var recipes:[RecipeDetail] = []
    var searchedRecipes: [RecipeDetail] = []
    var searchedRecipesImages: [UIImage] = []
    var searchedCreators: [User] = []
    var recipesImages: [Int:UIImage] = [:]
    var creators: [User] = []
    
    var searching = false
    var searchNames = [String]()
    lazy  var SearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 600, height: 20))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.delegate = self
        SearchBar.placeholder = "Search Recipe "
        let RightNavBarButton = UIBarButtonItem(customView:SearchBar)
        self.navigationItem.rightBarButtonItem = RightNavBarButton
        
        TitleImage.image = T_image
        TitleLabel.text = T_Name
        self.view.sendSubviewToBack(TitleImage)
        
        collectionRef.delegate = self
        collectionRef.dataSource = self
        
        let width = (collectionRef.frame.size.width - 4) / 2
        let layout = collectionRef.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        //        setupCollection()
        
        dataManager.delegate = self
        let query = db.collection("recipe").whereField("genres.\(T_Name)", isEqualTo: true)
        dataManager.Data(queryRef: query)
        
    }

}


extension RecipeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text! == "" {
            searchedRecipes.removeAll()

            searching = false
            searchBar.showsCancelButton = true
            collectionRef.reloadData()
        } else {

            searchedRecipes.removeAll()
            searchedRecipesImages.removeAll()
            searchedCreators.removeAll()
            
            searching = true
            searchBar.showsCancelButton = true
            recipes.enumerated().map {
                
                if $0.1.title.lowercased().contains(searchBar.text!.lowercased()) {
                    searchedRecipes.append($0.1)
                    searchedRecipesImages.append(recipesImages[$0.0]!) 
                    searchedCreators.append(creators[$0.0])
                }
            }
            
       
        
        collectionRef.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        collectionRef.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.endEditing(true)
    }
    
}


extension RecipeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching{
            return searchedRecipes.count
        }
        else{ return recipes.count }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionRef.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! CollectionViewCell
        
        if searching{
            cell.collectionLabel.text = searchedRecipes[indexPath.row].title
            cell.collectionImage.image = searchedRecipesImages[indexPath.row]
        }
        else{
            cell.collectionImage.image = recipesImages[indexPath.row]
            cell.collectionLabel.text = recipes[indexPath.row].title
        }
        
        return cell
    }
    
    func roundCorners(view: UIView, cornerRadius: Double) {
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recipeDetailVC = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(identifier: "detailvc") as! RecipeDetailViewController
        
        if searching {
            recipeDetailVC.recipe = searchedRecipes[indexPath.row]
            recipeDetailVC.creator = searchedCreators[indexPath.row]
            recipeDetailVC.mainPhoto = searchedRecipesImages[indexPath.row]
        } else {
            recipeDetailVC.recipe = recipes[indexPath.row]
            recipeDetailVC.creator = creators[indexPath.row]
            recipeDetailVC.mainPhoto = recipesImages[indexPath.row]!
        }
        navigationController?.pushViewController(recipeDetailVC, animated: true)
    }
    
}

extension RecipeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-30) / 2, height: (collectionView.frame.size.width-30) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
}

extension RecipeViewController: RecipeViewControllerDelegate {
    func reloadRecipe(data: [RecipeDetail]) {
        self.recipes = data
        
        recipes = recipes.sorted(by: { $0.like > $1.like })
        
        for recipe in recipes {
            CollectionLabel.append(recipe.title)
        }
        
        self.recipes.enumerated().map {
            dataManager.getImage(uid: $0.1.userID, rid: $0.1.recipeID, index: $0.0)
            dataManager.getUserDetail(id: $0.1.userID)
        }
    }
    
    func reloadImg(image: UIImage, index: Int) {
        recipesImages[index] = image
        self.collectionRef.reloadData()
    }
    
    func gotUserData(user: User) {
        self.creators.append(user)
    }
    
    
}
