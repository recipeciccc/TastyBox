//
//  IngredientsViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-12.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

protocol stopPagingDelegate:  class {
    func stopPaging(isPaging: Bool)
}

class IngredientsViewController: UIViewController {
    @IBOutlet weak var TitleCollectionView: UICollectionView!
    @IBOutlet weak var ImageCollecitonView: UICollectionView!
    
    var ingredientArray: [String] = [] {
        didSet {
            
            searchingIngredient = ingredientArray[0]
            if showingIngredient == nil {
                showingIngredient = searchingIngredient
            }
        }
    }
    var searchingIngredient: String?
    var showingIngredient: String?
    var imageDictionary: [String:[UIImage]] = [:]
    var imageCount = 0
    
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
    var selectedIndexPath:IndexPath?
    
    weak var delegate: stopPagingDelegate?
    
    ///  スクロール開始地点
    var scrollBeginPoint: CGFloat = 0.0
    
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    fileprivate func showConnectingView() {
        let navigationBar = UINavigationBar()
        let height = UIScreen.main.bounds.height / 2 - navigationBar.frame.size.height - 50
        
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        indicator.center = CGPoint(x: UIScreen.main.bounds.width / 2 , y: height)
        indicator.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0.5)
        indicator.color = .white
        indicator.layer.cornerRadius = 10
        
        self.view.addSubview(indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refrigeratorDataManager.delegate = self
        dataManager.delegate = self
        ImageCollecitonView.delegate = self
        
        
        
        showConnectingView()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let uid = Auth.auth().currentUser?.uid
        
        if ingredientArray.isEmpty {
           
            refrigeratorDataManager.getRefrigeratorDetail(userID: uid!)
            showConnectingView()
            
            DispatchQueue.global(qos: .default).async {
                
                // Do heavy work here
                
                DispatchQueue.main.async { [weak self] in
                    // UI updates must be on main thread
                    self?.indicator.startAnimating()
                }
            }
        }
        
//        if lastNavigationBarIsHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if selectedIndexPath == nil {

            if let cell = TitleCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? IngredientTitleCollectionViewCell {
                
                self.TitleCollectionView.reloadData()
                self.TitleCollectionView.layoutIfNeeded()
                cell.focusCell(active: true)
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageCount = 0
        navigationController?.setNavigationBarHidden(false, animated: true)
        lastNavigationBarIsHidden = false
    }
    
    func isVIPAction(superView: UIView) {
        
        let imageView = UIImageView(image: UIImage(systemName: "lock.circle"))
        imageView.isOpaque = false
        imageView.tintColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        
        
        superView.addSubview(imageView)
        
        imageView.frame.size.width = superView.frame.size.width / 3 * 2
        imageView.frame.size.height = superView.frame.size.width / 3 * 2
        
        imageView.center = superView.center
    }
    
    func updateNavigationBarHiding(scrollDiff: CGFloat) {
        let boundaryValue: CGFloat = 100.0
        
        /// navigationBar表示
        if scrollDiff > boundaryValue {
            navigationController?.setNavigationBarHidden(false, animated: true)
            lastNavigationBarIsHidden = false
            return
        }
            
            /// navigationBar非表示
        else if scrollDiff < -boundaryValue {
            navigationController?.setNavigationBarHidden(true, animated: true)
            lastNavigationBarIsHidden = true
            return
        } 
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
            
            cell2.lockImageView.isHidden = recipes[showingIngredient!]![indexPath.row].isVIPRecipe! ? false : true
            
        }
        
        cell2.ingredientRecipeName.text = recipes[showingIngredient!]![indexPath.row].title
        return cell2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        if collectionView == TitleCollectionView {
            
            TitleCollectionView.reloadData()
            showingIngredient = ingredientArray[indexPath.row]
            
            tempCreators.removeAll()
            tempImages.removeAll()
            imageCount = 0
            
            if recipes[showingIngredient!] != nil{
                self.ImageCollecitonView.isHidden = false
                tempImages = Array(repeating: UIImage(), count: recipes[showingIngredient!]!.count)
                
                for (index ,recipe) in self.recipes[showingIngredient!]!.enumerated(){
                    dataManager.getImage(uid: recipe.userID, rid: recipe.recipeID, index: index)
                    dataManager.getUserDetail(id: recipe.userID)
                    
                }
            }
            
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
        let scrollDiff = scrollBeginPoint - scrollView.contentOffset.y
        updateNavigationBarHiding(scrollDiff: scrollDiff)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginPoint = scrollView.contentOffset.y
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        })
        
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
    
    func roundCorners(view: UIView, cornerRadius: Double) {
        view.layer.cornerRadius = CGFloat(cornerRadius)
        view.clipsToBounds = true
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
            
            let query = db.collection("recipe").order(by: "like", descending: true)
            let _ = dataManager.Data(queryRef: query)
            
            TitleCollectionView.reloadData()
        } else {
            
            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.stopAnimating()
            }
        }
    }
}

extension IngredientsViewController: fetchDataInIngredientsDelegate {
    
    // get the all recipe sorted by like
    func reloadRecipe(data: [RecipeDetail]) {
        
        self.allRecipes = data
        
        lastRecipeID = allRecipes.last!.recipeID
        
        // get ingredients of all recipes
        for recipe in self.allRecipes {
            
            dataManager.getIngredients(userId: recipe.userID, recipeId: recipe.recipeID)
            
        }
        
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
    
    func reloadImg(image: UIImage, index: Int) {
        
        tempImages.remove(at: index)
        tempImages.insert(image, at: index)
        imageDictionary[showingIngredient!] = tempImages
        imageCount += 1
        
        if imageCount ==  self.recipes[showingIngredient!]?.count {
            DispatchQueue.global(qos: .default).async {
                
                // Do heavy work here
                
                DispatchQueue.main.async { [weak self] in
                    // UI updates must be on main thread
                    self?.indicator.stopAnimating()
                }
            }
            
            UIView.transition(with: self.ImageCollecitonView, duration: 0.3, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
                self.ImageCollecitonView.reloadData()
                self.ImageCollecitonView.isHidden = false
            }, completion: nil)
        }
    }
    
    func gotUserData(user: User) {
        tempCreators.append(user)
        creators[showingIngredient!] = tempCreators
    }
    
    
}

