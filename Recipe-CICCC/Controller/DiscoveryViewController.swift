//
//  DiscoveryViewController.swift
//  RecipeDiscovery
//
//  Created by fangyilai on 2019-10-24.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController {
    
    @IBOutlet weak var MonthlyContainerView: UIView!
    @IBOutlet weak var PopularContainerView: UIView!
    @IBOutlet weak var SubscribedContainerView: UIView!
    @IBOutlet weak var IngredientsContainerView: UIView!
    @IBOutlet weak var EditorContainerView: UIView!
    @IBOutlet weak var VIPContainerVIew: UIView!

    @IBOutlet weak var MenuCollectionVIew: UICollectionView!
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
        
        let width = (MenuCollectionVIew.frame.size.width - 5) / 2
        let layout = MenuCollectionVIew.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        initialContentView()
        EditorContainerView.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSearch), name: NSNotification.Name("ShowSearch"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfile), name: NSNotification.Name("ShowProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddRecipe), name: NSNotification.Name("AddRecipe"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSetting), name: NSNotification.Name("ShowSetting"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showContact), name: NSNotification.Name("ShowContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAbout), name: NSNotification.Name("ShowAbout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLogout), name: NSNotification.Name("ShowLogout"), object: nil)
        
    }
    
    func initialContentView(){
        self.SubscribedContainerView.isHidden = true
        self.MonthlyContainerView.isHidden = true
        self.PopularContainerView.isHidden = true
        self.IngredientsContainerView.isHidden = true
        self.EditorContainerView.isHidden = true
        self.VIPContainerVIew.isHidden = true
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
            SideMenuConstraint.constant = -150
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
        
        let Storyboard: UIStoryboard = UIStoryboard(name: "shihomi", bundle: nil)
        let vc = Storyboard.instantiateViewController(withIdentifier: "profilePage") as! TableViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    
}


extension DiscoveryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MenuCollectionVIew.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
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
        
        switch indexPath.row{
        case 0:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.SubscribedContainerView.isHidden = false
            })
        case 1:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.IngredientsContainerView.isHidden = false
            })
        case 2:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.PopularContainerView.isHidden = false
            })
        case 3:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.EditorContainerView.isHidden = false
            })
        case 4:
            UIView.animate(withDuration: 0.7, animations: {
                self.initialContentView()
                self.MonthlyContainerView.isHidden = false
            })
        case 5:
            UIView.animate(withDuration: 0.5, animations: {
                self.initialContentView()
                self.VIPContainerVIew.isHidden = false
            })
            
        default:
            initialContentView()
            self.EditorContainerView.isHidden = false
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
