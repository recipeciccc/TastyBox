//
//  DiscoveryViewController.swift
//  RecipeDiscovery
//
//  Created by fangyilai on 2019-10-24.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DiscoveryViewController: UIViewController {
    
    //    @IBOutlet weak var MonthlyContainerView: UIView!
    @IBOutlet weak var PopularContainerView: UIView!
    //    @IBOutlet weak var SubscribedContainerView: UIView!
    //    @IBOutlet weak var IngredientsContainerView: UIView!
    //    @IBOutlet weak var EditorContainerView: UIView!
    //    @IBOutlet weak var VIPContainerVIew: UIView!
    
    var pageControllView = MainPageViewController()
    
    let FollowingVC = UIStoryboard(name: "followingRecipe", bundle: nil).instantiateViewController(identifier: "followingRecipe") as! FollowingRecipeViewController
    let ingredientVC = UIStoryboard(name: "ingredientRecipe", bundle: nil).instantiateViewController(identifier: "ingredientRecipe") as! IngredientsViewController
    let poppularVC = UIStoryboard(name: "popularPage", bundle: nil).instantiateViewController(identifier: "popularPage") as! PopularRecipeViewController
    let editorChoiceVC = UIStoryboard(name: "EditorChoice", bundle: nil).instantiateViewController(identifier: "EditorChoice") as EditorChoiceViewController
    let monthlyVC = UIStoryboard(name: "Monthly", bundle: nil).instantiateViewController(identifier: "Monthly") as! MonthlyViewController
    let VIPVC = UIStoryboard(name: "VIP_page", bundle: nil).instantiateViewController(identifier: "VIP_page") as! VIPViewController
    
    var indexPathUserselectedBefore: IndexPath?
    
    @IBOutlet weak var MenuCollectionView: UICollectionView!
    @IBAction func SideMenuTapped(){
        print("Toggle side Menu")
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    @IBOutlet weak var SideMenuConstraint: NSLayoutConstraint!
    
    @IBAction func SearchBarItem() {
        print("Tab search Button")
        NotificationCenter.default.post(name: NSNotification.Name("ShowSearch"), object: nil)
    }
    
    @IBAction func AddNewRecipe(_ sender: Any) {
        print("Tab Add Button")
        NotificationCenter.default.post(name: NSNotification.Name("AddRecipe"), object: nil)
    }
    
    var arrayMenu = [String]()
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Discovery"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange ]
        CreateMenuLabel()
        
        let width = (MenuCollectionView.frame.size.width - 5) / 2
        let layout = MenuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        initialContentView()
        //        EditorContainerView.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSearch), name: NSNotification.Name("ShowSearch"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name("ShowProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddRecipe), name: NSNotification.Name("AddRecipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSetting), name: NSNotification.Name("ShowSetting"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showContact), name: NSNotification.Name("ShowContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAbout), name: NSNotification.Name("ShowAbout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLogout), name: NSNotification.Name("ShowLogout"), object: nil)
        
        pageControllView = self.children[0] as! MainPageViewController
        self.MenuCollectionView.showsHorizontalScrollIndicator = false
        
        
    }
    
    func initialContentView(){
        //        self.SubscribedContainerView.isHidden = true
        //        self.MonthlyContainerView.isHidden = true
        //        self.PopularContainerView.isHidden = true
        //        self.IngredientsContainerView.isHidden = true
        //        self.EditorContainerView.isHidden = true
        //        self.VIPContainerVIew.isHidden = true
        self.PopularContainerView.isHidden = false
        
    }
    func CreateMenuLabel() {
        
        let label1 = "Subscribed Creator"
        let label2 = "Your Ingredients Recipe"
        let label3 = "Most Popular"
        let label4 = "Editor Choice"
        let label5 = "Monthly Choice"
        let label6 = "VIP Only"
        arrayMenu.append(label1)
        arrayMenu.append(label2)
        arrayMenu.append(label3)
        arrayMenu.append(label4)
        arrayMenu.append(label5)
        arrayMenu.append(label6)
    }
    
    @objc func toggleSideMenu() {
        if sideMenuOpen{
            sideMenuOpen = false
            SideMenuConstraint.constant = -160
        }else{
            sideMenuOpen = true
            SideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func showProfile(){
        print("show Profile")
        performSegue(withIdentifier: "userProfile", sender: nil)
    }
    
    @objc func showSearch(){
        print("show Search")
        performSegue(withIdentifier: "searchPage", sender: nil)
    }
    
    @objc func AddRecipe(){
        print("Add Recipe")
        performSegue(withIdentifier: "addRecipe", sender: nil)
    }
    @objc func showSetting(){
        print("show Setting")
        performSegue(withIdentifier: "setting", sender: nil)
    }
    @objc func showContact(){
        print("show Contact")
        performSegue(withIdentifier: "contact", sender: nil)
    }
    @objc func showAbout(){
        print("show About")
        performSegue(withIdentifier: "about", sender: nil)
    }
    @objc func showLogout(){
        print("show Logout")
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                //                navigationController?.popViewController(animated: true)
                
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        let Storyboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "loginPage")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}



extension DiscoveryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPathUserselectedBefore == nil  && indexPath.row == 3 {
            indexPathUserselectedBefore = indexPath
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuCollectionViewCell)!
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        let cell = MenuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
        cell.MenuLabel.text = arrayMenu[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        0 = "Subscribed Creator"
        //        1 = "Your Ingredients Recipe"
        //        2 = "Most Popular"
        //        3 = "Editor Choice"
        //        4 = "Monthly Choice"
        //        5 = "VIP Only"
        
        let cellUserTapped = (collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell)!
        let cellUserTappedbefore = (collectionView.cellForItem(at: indexPathUserselectedBefore!) as? MenuCollectionViewCell)!
        
        
        var isPageCurlDirection:  UIPageViewController.NavigationDirection?
        
        if self.indexPathUserselectedBefore != nil {
            if indexPath.row < self.indexPathUserselectedBefore!.row {
                isPageCurlDirection = .reverse
            } else {
                isPageCurlDirection = .forward
            }
        } else {
            switch indexPath.row {
            case 0 ..< 3:
                isPageCurlDirection = .reverse
            case 4 ..< 6:
                isPageCurlDirection = .forward
            default:
                break
            }
        }
        
        switch indexPath.row{
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                
                self.initialContentView()
                
                self.indexPathUserselectedBefore = indexPath
                
                cellUserTapped.isUserInteractionEnabled = false
                cellUserTappedbefore.isUserInteractionEnabled = true
                
                
                self.pageControllView.setViewControllers([self.FollowingVC], direction: isPageCurlDirection!, animated: true,completion: nil)
                //                self.SubscribedContainerView.isHidden = false
            })
        case 1:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.indexPathUserselectedBefore = indexPath
                
                cellUserTapped.isUserInteractionEnabled = false
                cellUserTappedbefore.isUserInteractionEnabled = true
                
                self.pageControllView.setViewControllers([self.ingredientVC], direction: isPageCurlDirection!, animated: true,completion: nil)
                
                //                self.IngredientsContainerView.isHidden = false
            })
        case 2:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.indexPathUserselectedBefore = indexPath
                
                cellUserTapped.isUserInteractionEnabled = false
                cellUserTappedbefore.isUserInteractionEnabled = true
                
                self.pageControllView.setViewControllers([self.poppularVC], direction: isPageCurlDirection!, animated: true,completion: nil)
                //                self.PopularContainerView.isHidden = false
            })
        case 3:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                
                if self.indexPathUserselectedBefore == indexPath { return }
                
                self.indexPathUserselectedBefore = indexPath
                cellUserTapped.isUserInteractionEnabled = false
                cellUserTappedbefore.isUserInteractionEnabled = true
                
                self.pageControllView.setViewControllers([self.editorChoiceVC], direction: isPageCurlDirection!, animated: true,completion: nil)
                //                self.EditorContainerView.isHidden = false
            })
        case 4:
            UIView.animate(withDuration: 0.7, animations: {
                self.initialContentView()
                self.indexPathUserselectedBefore = indexPath
                
                cellUserTapped.isUserInteractionEnabled = false
                cellUserTappedbefore.isUserInteractionEnabled = true
                
                self.pageControllView.setViewControllers([self.monthlyVC], direction: isPageCurlDirection!, animated: true,completion: nil)
                //                self.MonthlyContainerView.isHidden = false
            })
        case 5:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.indexPathUserselectedBefore = indexPath
                
                cellUserTapped.isUserInteractionEnabled = false
                cellUserTappedbefore.isUserInteractionEnabled = true
                
                self.pageControllView.setViewControllers([self.VIPVC], direction: isPageCurlDirection!, animated: true,completion: nil)
                //                self.VIPContainerVIew.isHidden = false
            })
            
        default:
            initialContentView()
            //            self.EditorContainerView.isHidden = false
        }
        
        return
    }
    
    
}




class MenuCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var MenuLabel: UILabel!
    
    //test
    //        override var isSelected: Bool{
    //            didSet(newValue){
    //                contentView.backgroundColor = UIColor.brown
    //                MenuLabel.tintColor = UIColor.white
    //            }
    //        }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let OriginalView = UIView()
        let ChangeView = UIView()
        
        if OriginalView.isEqual(ChangeView){
            ChangeView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            self.selectedBackgroundView = ChangeView
        }else{
            ChangeView.backgroundColor = #colorLiteral(red: 0.9998212457, green: 0.9867780805, blue: 0.7689660192, alpha: 1)
            self.backgroundView = ChangeView
        }
    }
    
}
