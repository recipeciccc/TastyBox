//
//  SearchingViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

protocol SearchingViewControllerDelegate: class {
    func segmentSetted(index:Int)
}

class SearchingViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var pageController = SearchingPageViewController()
    var previousIndex = 0
    let underlineLayer = CALayer()
    var segmentItemWidth:CGFloat = 0
    var startOffset = CGFloat(0)
    
    let genreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "genreVC") as! SearchingGenreViewController
    let ingredientVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ingredientVC") as! SearchingIngredientsViewController
    let creatorVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "creatroVC") as! SearchingCreatorsViewController
    
    var VCs: [UIViewController] = []
    
    lazy  var SearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 600, height: 20))
    
    let CreatorDataManager = SearchingDataManager()
    let IngredientDataManager = SearchingIngredientsDataManager()
    let GenreDataManager = SearchingGenreDataManager()
    let db = Firestore.firestore()
    
    var searchingWord : String = "" {
        didSet {
            
            guard searchingWord != "" else {
                return
            }
            
            let query = db.collection("user")
            CreatorDataManager.delegateChild = self
            CreatorDataManager.getSearchedCreator(query: query, searchingWord: searchingWord)
            
            IngredientDataManager.getIngredientDelegate = self
            IngredientDataManager.getIngredients(searchingWord: searchingWord)
            ingredientVC.searchingWord = searchingWord
            
            GenreDataManager.isGenreExistDelegate = self
            GenreDataManager.getIngredients(searchingWord: searchingWord)
        }
    }
    
    var searchedResults:[User] = [] {
        didSet {
            creatorVC.searchedCreators = searchedResults
            //            creatroVC.tableView.reloadData()
        }
    }
    
    var searchedUsersImages: [Int: UIImage] = [:] {
        didSet {
            creatorVC.searchedCreatorsImage = searchedUsersImages
        }
    }
    
    var searchedIngredient: [String] = [] {
        didSet {
            ingredientVC.ingredientArray = searchedIngredient
            if segmentControl.selectedSegmentIndex == 0 {
                pageController.setViewControllers([ingredientVC], direction: .forward, animated: false, completion: nil)
            }
            
        }
    }
    
    var searchedIngredientRecipe:[RecipeDetail] = [] {
        didSet {
            ingredientVC.searchedRecipes = searchedIngredientRecipe
            //            ingredientVC.loadView()
            //            ingredientVC.viewDidLoad()
        }
    }
    
    var searchedGenre:[String] = [] {
        didSet {
            genreVC.genresArray = searchedGenre
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        pageController = self.children[0] as! SearchingPageViewController
        pageController.dataSource = self
        
        
        VCs =  [ingredientVC, genreVC, creatorVC]
        
        setSegmentControl()
        let sortedViews = segmentControl.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        sortedViews[0].tintColor = UIColor.orange //Default Selection colo
        
        SearchBar.delegate = self
        SearchBar.becomeFirstResponder()
        SearchBar.returnKeyType = .done
        SearchBar.placeholder = "Search Recipe"
        let RightNavBarButton = UIBarButtonItem(customView:SearchBar)
        self.navigationItem.rightBarButtonItem = RightNavBarButton
        
        // tapによるページめくりを担当するインスタンスを取得
        let tapGestureRecognizer = self.pageController.gestureRecognizers.filter{ $0 is UITapGestureRecognizer }.first as! UITapGestureRecognizer
        
        tapGestureRecognizer.isEnabled = false
    }
    
    fileprivate func setSegmentControl() {
        let titles = ["Ingredient", "Meal Type", "Creator"]
        for index in 0 ..< titles.count {
            segmentControl.setTitle(titles[index], forSegmentAt: index)
            
        }
        
        segmentControl.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func actionSegmentAction(sender:UISegmentedControl) {
        segmentControl.changeUnderlinePosition()
        
//        if segmentControl.selectedSegmentIndex > previousIndex || segmentControl.selectedSegmentIndex < previousIndex {
            
        if segmentControl.selectedSegmentIndex != previousIndex {
            var direction: UIPageViewController.NavigationDirection?
            
            if segmentControl.selectedSegmentIndex > previousIndex  {
                direction = .forward
            }
            else {
                direction = .reverse
            }
            
            switch segmentControl.selectedSegmentIndex {
            case 0:
                
                self.pageController.setViewControllers([VCs[0]], direction: direction!, animated: true, completion: nil)
                previousIndex = 0
            case 1:
                self.pageController.setViewControllers([VCs[1]], direction: direction!, animated: true, completion: nil)
                previousIndex = 1
            case 2:
                self.pageController.setViewControllers([VCs[2]], direction: direction!, animated: true, completion: nil)
                previousIndex = 2
                
            default:
                return
            }
        }
        
        
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


extension SearchingViewController:UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var currentVC:UIViewController?
        
        switch viewController {
        case is SearchingGenreViewController:
            currentVC = genreVC
            
        case is SearchingIngredientsViewController:
            currentVC = ingredientVC
            
        case is SearchingCreatorsViewController:
            currentVC = creatorVC
        default:
            return nil
        }
        
        guard let currentIndex = VCs.firstIndex(of: currentVC!) else {
            return nil
        }
        
        if currentIndex == 0 {
            segmentControl.selectedSegmentIndex = 0
            segmentControl.changeUnderlinePosition(index: 0)
            return nil
            
        }
        
        
        segmentControl.selectedSegmentIndex = segmentControl.selectedSegmentIndex - 1
        segmentControl.changeUnderlinePosition(index: segmentControl.selectedSegmentIndex)
        
        
        return VCs[currentIndex - 1]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        var currentVC:UIViewController?
        
        switch viewController {
        case is SearchingGenreViewController:
            currentVC = genreVC
            
        case is SearchingIngredientsViewController:
            currentVC = ingredientVC
            
        case is SearchingCreatorsViewController:
            currentVC = creatorVC
        default:
            return nil
        }
        
        guard let currentIndex = VCs.firstIndex(of: currentVC!) else {
            return nil
        }
        
        if currentIndex == 2 {
            
            segmentControl.selectedSegmentIndex = 2
            segmentControl.changeUnderlinePosition(index:2)
            
            return nil
        }
        
        segmentControl.selectedSegmentIndex = segmentControl.selectedSegmentIndex + 1
        segmentControl.changeUnderlinePosition(index: segmentControl.selectedSegmentIndex)
        
        return VCs[currentIndex + 1]
        
    }
    
    
    
}

extension SearchingViewController:UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //        let pageController = self.children[0] as! SearchingPageViewController
        searchingWord = searchBar.text!
        
        if searchingWord == "" {
            searchedResults.removeAll()
            searchedUsersImages.removeAll()
            
            creatorVC.searchedCreators.removeAll()
            creatorVC.searchedCreatorsImage.removeAll()
            ingredientVC.ingredientArray.removeAll()
            
            genreVC.genresArray.removeAll()
            
            if ingredientVC.tableView != nil {
                //                creatorVC.tableView.reloadData()
                ingredientVC.tableView.reloadData()
            }
            
            if genreVC.tableView != nil {
                genreVC.tableView.reloadData()
            }
            
            if creatorVC.tableView != nil {
                self.creatorVC.tableView.reloadData()
            }
        }
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchingWord = searchBar.text!
        
        searchBar.resignFirstResponder()
    }
}


