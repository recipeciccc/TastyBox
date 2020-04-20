//
//  SearchingViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol SearchingViewControllerDelegate: class {
    func segmentSetted(index:Int)
}

class SearchingViewController: UIViewController {
    
    lazy  var SearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 600, height: 20))
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    var pageController = SearchingPageViewController()
    var previousIndex = 0
    let underlineLayer = CALayer()
    var segmentItemWidth:CGFloat = 0
    
    let genreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "genreVC") as! SearchingGenreViewController
    let ingredientVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ingredientVC") as! SearchingIngredientsViewController
    let creatroVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "creatroVC") as! SearchingCreatorsViewController
    
    var VCs: [UIViewController] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SearchBar.delegate = self
        SearchBar.placeholder = "Search Recipe "
        let RightNavBarButton = UIBarButtonItem(customView:SearchBar)
        self.navigationItem.rightBarButtonItem = RightNavBarButton
        
        pageController = self.children[0] as! SearchingPageViewController
        pageController.dataSource = self
        
        VCs =  [ingredientVC, genreVC, creatroVC]
        
        setSegmentControl()
        let sortedViews = segmentControl.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        sortedViews[0].tintColor = UIColor.orange //Default Selection colo
    }
    
    fileprivate func setSegmentControl() {
        let titles = ["Ingredient", "Genre", "Creator"]
        for index in 0 ..< titles.count {
            segmentControl.setTitle(titles[index], forSegmentAt: index)
            
        }
    
        segmentControl.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func actionSegmentAction(sender:UISegmentedControl) {
        
        if segmentControl.selectedSegmentIndex > previousIndex || segmentControl.selectedSegmentIndex < previousIndex {
            
            segmentControl.changeUnderlinePosition()
            var direction: UIPageViewController.NavigationDirection?
            
            if segmentControl.selectedSegmentIndex > previousIndex  {
                direction = .forward
            }
            else {
                direction = .reverse
            }
            
            let sortedViews = sender.subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
                  
                  for (index, view) in sortedViews.enumerated() {
                      if index == sender.selectedSegmentIndex { //When selected
                          view.tintColor = UIColor.orange
                      } else {//Unselected
                          view.tintColor = nil
                      }
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
    
    func setSelectedSegmentColor(with foregroundColor: UIColor, and tintColor: UIColor) {
        
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
            currentVC = creatroVC
        default:
            return nil
        }
        
        guard let currentIndex = VCs.firstIndex(of: currentVC!) else {
            return nil
        }
        
        
        if currentIndex == 0 { return nil }
        
        segmentControl.selectedSegmentIndex = currentIndex - 1
        segmentControl.changeUnderlinePosition(index: currentIndex - 1)
        
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
            currentVC = creatroVC
        default:
            return nil
        }
        
        guard let currentIndex = VCs.firstIndex(of: currentVC!) else {
            return nil
        }
        
        if currentIndex == 2 { return nil }
        
        segmentControl.selectedSegmentIndex = currentIndex + 1
        segmentControl.changeUnderlinePosition(index: currentIndex + 1)
        
        return VCs[currentIndex + 1]
        
    }
    
}

extension SearchingViewController:UISearchBarDelegate {
    
}
