//
//  RecipeViewController.swift
//  RecipeDiscovery
//
//  Created by fangyilai on 2019-10-29.
//  Copyright © 2019 fangyilai. All rights reserved.
//


//MARK: do not use same Data function as recipe detail view controller 

import UIKit
import Firebase
import Crashlytics

private let reuseIdentifier = "Cell"

class RecipeViewController: UIViewController {
    
    let dataManager = RecipeViewControllerDataManager()
    let db = Firestore.firestore()
    
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var collectionRef: UICollectionView!
    
    var isSearchingCuisine: Bool?

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
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.delegate = self
        SearchBar.placeholder = "Search Recipe"
        dataManager.delegate = self
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
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionRef.isHidden = true
        
        indicator.color = .white
        indicator.tag = 100
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        indicator.color = .white
        indicator.backgroundColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 0.8)
        indicator.layer.cornerRadius = 10.0
        indicator.hidesWhenStopped = true
        indicator.center = self.view.center
        TitleImage.addSubview(indicator)
        
        DispatchQueue.global(qos: .default).async {
            
            // Do heavy work here
            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.startAnimating()
            }
        }
        
        if let isSearchingCuisine = isSearchingCuisine {
        
        let query = isSearchingCuisine ?
            db.collection("recipe").whereField("genres.\(T_Name) cuisine", isEqualTo: true) : db.collection("recipe").whereField("genres.\(T_Name)", isEqualTo: true)
            
             dataManager.Data(queryRef: query)
        } else {
            
            let query = db.collection("recipe").whereField("genres.\(T_Name)", isEqualTo: true)
            dataManager.Data(queryRef: query)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.recipes.removeAll()
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
        else { return recipes.count }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionRef.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! CollectionViewCell
        var isVIP: Bool?
        
        if searching{
            cell.collectionLabel.text = searchedRecipes[indexPath.row].title
            cell.collectionImage.image = searchedRecipesImages[indexPath.row]
            
        }
        else{
            
            isVIP = recipes[indexPath.row].isVIPRecipe
            
            cell.collectionImage.image = recipesImages[indexPath.row]
            cell.collectionLabel.text = recipes[indexPath.row].title
        }
        
        if let isVIP = isVIP {
            if isVIP == true {
                cell.lockIconImageView.isHidden = false
            } else {
                cell.lockIconImageView.isHidden = true
            }
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
        
        guard self.navigationController?.topViewController == self else { return }
        
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
    func gotUserData(users: [User]) {
        self.creators = users
    }
    
    func reloadRecipe(data: [RecipeDetail]) {
        
        if data.isEmpty {
            DispatchQueue.global(qos: .default).async {
                
                // Do heavy work here
                
                DispatchQueue.main.async { [weak self] in
                    // UI updates must be on main thread
                    self?.indicator.stopAnimating()
                }
            }
            
            let noResultView = UIView()
            let label = UILabel()
            
            
            label.text = "Sorry.. No Result. \nLet's post \(T_Name) recipe!"
            label.textAlignment = .center
            
            noResultView.addSubview(label)
            
            self.view.addSubview(noResultView)
            
            let centerYAnchor = noResultView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            let centerXAnchor = noResultView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            
            centerYAnchor.isActive = true
            centerXAnchor.isActive = true
            
        } else {
            
            self.recipes = data
            
            recipes = recipes.sorted(by: { $0.like > $1.like })
            
            for recipe in recipes {
                CollectionLabel.append(recipe.title)
            }
            
            self.recipes.enumerated().map {
                
                if $0.1.recipeID == self.recipes.last!.recipeID {
                    dataManager.getUserDetail(id: $0.1.userID, isLast: true)
                } else {
                    dataManager.getUserDetail(id: $0.1.userID, isLast: false)
                }
                
                dataManager.getImage(uid: $0.1.userID, rid: $0.1.recipeID, index: $0.0)
                
            }
        }
    }
    
    func reloadImg(image: UIImage, index: Int) {
        recipesImages[index] = image
        
        if recipes.count == recipesImages.count {
            
            DispatchQueue.global(qos: .default).async {
                
                // Do heavy work here
                
                DispatchQueue.main.async { [weak self] in
                    // UI updates must be on main thread
                    self?.indicator.stopAnimating()
                }
            }
            
            UIView.transition(with: self.collectionRef, duration: 0.3, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
                self.collectionRef.isHidden = false
                
            }, completion: nil)
            
            self.collectionRef.reloadData()
        }
    }
    
    
}
