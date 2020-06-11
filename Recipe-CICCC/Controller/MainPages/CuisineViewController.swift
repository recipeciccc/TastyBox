//
//  MonthlyViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-05.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit
import Crashlytics

class CuisineViewController: UIViewController {    
    
    var imageArray = [Image]()
    var arrayMenu = [String]()
    var searchIMageName = [Image]()
    var sideMenuOpen = false
    
    var recipeImages = [UIImage]()
    var recipeLabels = [String]()
    var mainViewController: MainPageViewController?
    var pageViewControllerDataSource: UIPageViewControllerDataSource?
    
    ///  スクロール開始地点
    var scrollBeginPoint: CGFloat = 0.0
    
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryArray()

        navigationController?.setNavigationBarHidden(false, animated: false)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if lastNavigationBarIsHidden {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        lastNavigationBarIsHidden = false
    }
    
    
    func CategoryArray() {
        let image1 = Image(title: "American", image: #imageLiteral(resourceName: "American"))
        let image2 = Image(title: "Mexican", image: #imageLiteral(resourceName: "mexican"))
        let image3 = Image(title: "Japanese", image: #imageLiteral(resourceName: "japanese"))
        let image4 = Image(title: "Chinese", image: #imageLiteral(resourceName: "chinese"))
        let image5 = Image(title: "Korean", image: #imageLiteral(resourceName: "korean"))
        
        imageArray.append(image1)
        imageArray.append(image2)
        imageArray.append(image3)
        imageArray.append(image4)
        imageArray.append(image5)
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

extension CuisineViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let image = imageArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImagesCell
        
        cell.setImage(UIimage: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewContoller = storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        let image = imageArray[indexPath.row]
        viewContoller?.T_image = image.image
        viewContoller?.T_Name = image.title
        viewContoller?.isSearchingCuisine = true

        switch indexPath.row{
               case 0: viewContoller?.recipeLabels = self.recipeLabels; break
               case 1: viewContoller?.recipeLabels = self.recipeLabels; break
               case 2:  viewContoller?.recipeLabels = self.recipeLabels; break
               case 3:  viewContoller?.recipeLabels = self.recipeLabels; break
               case 4:  viewContoller?.recipeLabels = self.recipeLabels; break
               case 5:  viewContoller?.recipeLabels = self.recipeLabels; break
               default: print("no category"); break
               }
         
        self.navigationController?.pushViewController(viewContoller!, animated: true)
    }
    
    
    // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings
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

