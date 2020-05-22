//
//  EditorChoiceViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

class EditorChoiceViewController: UIViewController {
    
    
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
    var selfNavigationController: UINavigationController?
    /// navigationBarが隠れているかどうか(詳細から戻った一覧に戻った際の再描画に使用)
    var lastNavigationBarIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateImageArray()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
         self.navigationController?.hidesBarsOnTap = false
        
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
    
    func CreateImageArray() {
        let image1 = Image(title: "Appetizer", image: #imageLiteral(resourceName: "Appetizer-1"))
        let image2 = Image(title: "Main Dish", image: #imageLiteral(resourceName: "meal-1"))
        let image3 = Image(title: "Salad", image: #imageLiteral(resourceName: "salad-1"))
        let image4 = Image(title: "Dessert", image: #imageLiteral(resourceName: "desert1"))
        let image5 = Image(title: "Beverage", image: #imageLiteral(resourceName: "beverage"))
        
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
            
             selfNavigationController = self.navigationController
            navigationController?.setNavigationBarHidden(true, animated: true)
            lastNavigationBarIsHidden = true
           
            return
        }
        
    }
    
    
}

extension EditorChoiceViewController: UITableViewDataSource, UITableViewDelegate{
    
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
        
        self.navigationController?.pushViewController(viewContoller!, animated: true)
    }
        
    // they and self.ispaging = false in pageviewcontroller prevent from paging when collection view is scrollings
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          
        mainViewController = self.parent as? MainPageViewController
        
        if  mainViewController!.dataSource == nil {
            
            mainViewController!.dataSource = mainViewController
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 下から５件くらいになったらリフレッシュ
        guard tableView.cellForRow(at: IndexPath(row: self.imageArray.count - 1, section: 0)) != nil else {
            return
        }
        // ここでリフレッシュのメソッドを呼ぶ
        
        print("HI")
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


