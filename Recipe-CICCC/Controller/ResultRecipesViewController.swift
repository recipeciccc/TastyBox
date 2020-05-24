//
//  ResultRecipesViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class ResultRecipesViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
//    var query: Query?
    var searchingWord: String?
    var searchingCategory: String?
    
    
    var dataManager = ResultRecipesDataManager()
    
    var resultRecipes:[RecipeDetail] = []
    var resultRecipesImages:[Int:UIImage] = [:]
    
    var uiView = UIView()
    let indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        uiView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  self.view.frame.size.height))
        uiView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        uiView.tag = 100
        indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        indicator.hidesWhenStopped = true
        indicator.color = .orange
        indicator.center = self.view.center
        
        uiView.addSubview(indicator)
        
        self.view.addSubview(uiView)
        
        
        DispatchQueue.global(qos: .default).async {
            
            // Do heavy work here
            
            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.startAnimating()
            }
        }
 
        collectionView.delegate = self
        collectionView.dataSource = self
        dataManager.delegate = self
        
        resultRecipesImages.removeAll()
        resultRecipes.removeAll()
        
        if searchingCategory! == "genres" {
            dataManager.searchingGenreRecipe(searchingWord: searchingWord!)
        } else if searchingCategory! == "ingredient" {
            dataManager.getAllRecipes(searchingWord: searchingWord!)
        }
        navigationItem.title = searchingWord!
        
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

extension ResultRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if resultRecipes.count == resultRecipesImages.count {
            return resultRecipes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "resultRecipe", for: indexPath) as? ResultRecipeCollectionViewCell)!
        
        if !resultRecipesImages.isEmpty {
            cell.imgView.image = resultRecipesImages[indexPath.row]!
        }
        
        cell.lockImageView.isHidden = resultRecipes[indexPath.row].isVIPRecipe! ? false : true
        
        return cell
    }
    
}

extension ResultRecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = (collectionView.cellForItem(at: indexPath) as? ResultRecipeCollectionViewCell)!
        
        let storyboard = UIStoryboard(name: "RecipeDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailvc") as! RecipeDetailViewController
        
        if resultRecipes[indexPath.row].userID == Auth.auth().currentUser!.uid {
            vc.userProfile = true
        } else {
            vc.userProfile = false
        }
        
        vc.recipe = resultRecipes[indexPath.row]
        vc.mainPhoto = resultRecipesImages[indexPath.row]!
        
        guard self.navigationController?.topViewController == self else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ResultRecipesViewController: UICollectionViewDelegateFlowLayout {
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3) / 3
        return CGSize(width: width, height: width)
    }
}


extension ResultRecipesViewController : ResultRecipesDataManagerDelegate {
    func passRecipesData(recipes: [RecipeDetail]) {
        resultRecipes.removeAll()
        resultRecipes = recipes
        self.collectionView.reloadData()
    }
    
    func reloadImg(img: UIImage, index: Int) {
        if resultRecipesImages.count != resultRecipes.count {
             resultRecipesImages[index] = img
            
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }else{
                print("No!")
            }
            
            DispatchQueue.global(qos: .default).async {
                
                // Do heavy work here
                
                DispatchQueue.main.async { [weak self] in
                    // UI updates must be on main thread
                    self?.indicator.stopAnimating()
                }
            }
        }
        
        UIView.transition(with: self.collectionView, duration: 0.3, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: {
           self.collectionView.reloadData()

        }, completion: nil)
        
    }
    
    func reloadIngredients(recipes:[RecipeDetail]) {
        self.resultRecipes = recipes
        for (index, recipe) in self.resultRecipes.enumerated() {
            dataManager.getImage(uid: recipe.userID, rid: recipe.recipeID, index: index)
        }
        self.collectionView.reloadData()
    }
    
}
