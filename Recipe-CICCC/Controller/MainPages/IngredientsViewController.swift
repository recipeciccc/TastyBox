//
//  IngredientsViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-12.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase

protocol stopPagingDelegate:  class {
    func stopPaging(isPaging: Bool)
}

class IngredientsViewController: UIViewController {
    @IBOutlet weak var TitleCollectionView: UICollectionView!
    @IBOutlet weak var ImageCollecitonView: UICollectionView!
    
    var ingredientArray: [String] = [] {
        didSet {
            
            let query = db.collection("recipe").order(by: "like", descending: true)
            let _ = dataManager.Data(queryRef: query)
            searchingIngredient = ingredientArray[0]
            showingIngredient = searchingIngredient
        }
    }
    var searchingIngredient: String?
    var showingIngredient: String?
    var imageDictionary: [String:[UIImage]] = [:]
    
    
    var allRecipes:[RecipeDetail] = []
    var recipes: [String: [RecipeDetail]] = [:]
    
    var recipesImages: [String: [UIImage]] = [:]
    var ingredientsDictionary: [String: [Ingredient]] = [:]
    var creators: [String : [User]] = [:]
    var tempCreators:[User] = []
    var lastRecipeID = ""
    var lastIngredient = ""
    
    let db = Firestore.firestore()
    let dataManager = fetchDataInIngredients()
    let getRecipeImageDataManager = FetchRecipeImage()
    let refrigeratorDataManager = IngredientRefrigeratorDataManager()
    var tempImages: [UIImage] = []
    var mainViewController: MainPageViewController?
    var pageViewControllerDataSource: UIPageViewControllerDataSource?
    
    var viewBackgroundColor = UIColor()
    var viewTintColor = UIColor()
    var click = Bool()
    var selectedIndexPath = IndexPath()
    
    weak var delegate: stopPagingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refrigeratorDataManager.delegate = self
        dataManager.delegate = self
        ImageCollecitonView.delegate = self
        
        let uid = Auth.auth().currentUser?.uid
        refrigeratorDataManager.getRefrigeratorDetail(userID: uid!)
    }
    
}

extension IngredientsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == TitleCollectionView{
            return ingredientArray.count
        }
        
        if collectionView == ImageCollecitonView {
            if showingIngredient != nil{
                if recipes[showingIngredient!] != nil {
                    return recipes[showingIngredient!]!.count
                }
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == TitleCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientTitleCell", for: indexPath) as! IngredientTitleCollectionViewCell
            cell.titleLabel.text = ingredientArray[indexPath.row]
            cell.focusCell(active: indexPath == selectedIndexPath)
            if let view = cell.titleView{
                roundCorners(view: view, cornerRadius: 8.0)
            }
            
            return cell
        }
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientImageCell", for: indexPath) as! IngredientImageCollectionViewCell
        
        if imageDictionary[showingIngredient!]?.count == recipes[showingIngredient!]?.count  {
            cell2.ingredientRecipeImage.image = imageDictionary[showingIngredient!]![indexPath.row]
        }
        
        cell2.ingredientRecipeName.text = recipes[showingIngredient!]![indexPath.row].title
        return cell2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        if collectionView == TitleCollectionView {
            collectionView.reloadData()
            showingIngredient = ingredientArray[indexPath.row]
            
            tempCreators.removeAll()
            tempImages.removeAll()
            
            if recipes[showingIngredient!] != nil{
                tempImages = Array(repeating: UIImage(), count: recipes[showingIngredient!]!.count)
                
                for (index ,recipe) in self.recipes[showingIngredient!]!.enumerated(){
                    dataManager.getImage(uid: recipe.userID, rid: recipe.recipeID, index: index)
                    dataManager.getUserDetail(id: recipe.userID)
                    
                }
            }
            self.ImageCollecitonView.reloadData()
        }
        
        if collectionView == ImageCollecitonView {
            let vc = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(identifier: "detailvc") as! RecipeDetailViewController
            vc.creator = creators[showingIngredient!]![indexPath.row]
            vc.mainPhoto = imageDictionary[showingIngredient!]![indexPath.row]
            vc.recipe = recipes[showingIngredient!]![indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return self.ImageCollecitonView.isDecelerating || self.ImageCollecitonView.contentOffset.y < 0 || self.ImageCollecitonView.contentOffset.y > max(0, self.ImageCollecitonView.contentSize.height - self.ImageCollecitonView.bounds.size.height); // @Jordan edited - we don't need to always enable simultaneous gesture for bounce enabled tableViews
        
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            
            let velocity: CGPoint = gestureRecognizer.velocity(in: ImageCollecitonView)
            if (abs(velocity.y) * 2 < abs(velocity.x)) {
                return true
            }
        }
        return false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        mainViewController = self.parent as? MainPageViewController
        
        if  mainViewController!.dataSource == nil {
            
            mainViewController!.dataSource = mainViewController
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mainViewController = self.parent as? MainPageViewController
        pageViewControllerDataSource = mainViewController!.dataSource
        
        mainViewController!.dataSource = nil
        mainViewController?.isPaging = false
    }
    
}

extension IngredientsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == TitleCollectionView{
            return CGSize(width: 65, height: 30)
        }
        //return CGSize(width: (collectionView.bounds.width-20) / 2, height: 170)
        return CGSize(width: (collectionView.frame.size.width-30) / 2, height: (collectionView.frame.size.width-30) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //
    //        return 4
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //
    //        return 1
    //    }
    //
    
    // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings
    
    
    
    func roundCorners(view: UIView, cornerRadius: Double) {
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
    }
}

extension IngredientsViewController: fetchDataInIngredientsDelegate {
    func reloadImg(image: UIImage, index: Int) {
        
        tempImages.remove(at: index)
        tempImages.insert(image, at: index)
        imageDictionary[showingIngredient!] = tempImages
        
        
        self.ImageCollecitonView.reloadData()
    }
    
    func gotUserData(user: User) {
        tempCreators.append(user)
        creators[showingIngredient!] = tempCreators
    }
    
    func reloadIngredients(data: [Ingredient], recipeID: String) {
        ingredientsDictionary[recipeID] = data
        
        if recipeID == lastRecipeID {
            
            for (index, ingredient) in ingredientArray.enumerated() {
                
                
                if index != 0 { searchingIngredient = ingredient }
                
                haveSearchingIngredient(recipes: self.allRecipes, ingredients: ingredientsDictionary)
                print("\(index): \(recipes)")
            }
            
            if searchingIngredient == ingredientArray.last {
                tempImages = Array(repeating: UIImage(), count: recipes[showingIngredient!]!.count)
                for (index, recipe) in self.recipes[showingIngredient!]!.enumerated(){
                    
                    dataManager.getImage(uid: recipe.userID, rid: recipe.recipeID, index: index)
                    dataManager.getUserDetail(id: recipe.userID)
                    
                }
            }
        }
    }
    
    // get the all recipe sorted by like
    func reloadRecipe(data: [RecipeDetail]) {
        
        self.allRecipes = data
        
//        guard (self.allRecipes.last?.recipeID) != nil else {
//            return
//        }
        
        lastRecipeID = allRecipes.last!.recipeID
        
        // get ingredients of all recipes
        for recipe in self.allRecipes {
            
            dataManager.getIngredients(userId: recipe.userID, recipeId: recipe.recipeID)
            
        }
        
    }
    
    func haveSearchingIngredient(recipes: [RecipeDetail], ingredients: [String : [Ingredient]]) {
        var resultRecipes: [RecipeDetail] = []
        
        for recipe in allRecipes {
            for ingredient in ingredientsDictionary {
                
                if recipe.recipeID == ingredient.key {
                    
                    for element in ingredient.value {
                        let nameUppercased = element.name.capitalized
                        if nameUppercased == searchingIngredient! {
                            resultRecipes.append(recipe)
                            break
                        }
                    }
                    break
                }
            }
        }
        
        self.recipes[searchingIngredient!] = resultRecipes
    }
    
}

extension IngredientsViewController: getIngredientRefrigeratorDataDelegate{
    func gotData(ingredients: [IngredientRefrigerator]) {
        
        if !ingredients.isEmpty {
            var array = [String]()
            for item in ingredients{
                let name = item.name
                array.append(name)
            }
            ingredientArray = array
//            searchingIngredient = ingredientArray[0]
//            showingIngredient = searchingIngredient
//
                  
            TitleCollectionView.reloadData()
        }
    }
}
