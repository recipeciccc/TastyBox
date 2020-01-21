//
//  RecipeViewController.swift
//  RecipeDiscovery
//
//  Created by fangyilai on 2019-10-29.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var collectionRef: UICollectionView!
    
    
    var category:Int = 0
    var T_image = UIImage()
    var T_Name = ""
    var CollectionImage = [UIImage]()
    var CollectionLabel = [String]()
    var EdgeOfCollectionView: CGFloat = 0
    
    var searching = false
    var searchNames = [String]()
    lazy  var SearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 600, height: 20))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchBar.delegate = self
        SearchBar.placeholder = "Search Recipe "
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
        
        //      roundCorners(view: UIView, cornerRadius: Double)
        
        switch category{
        case 0: setupCollection_1(); break
        case 1: setupCollection_2(); break
        case 2: setupCollection_3(); break
        case 3: setupCollection_4(); break
        case 4: setupCollection_5(); break
        case 5: setupCollection_6(); break
        default: print("no category"); break
        }
         
    }
    
    private func setupCollection_1() {
        let images = [#imageLiteral(resourceName: "appetizer"),#imageLiteral(resourceName: "appetizer"),#imageLiteral(resourceName: "appetizer"),#imageLiteral(resourceName: "appetizer"),#imageLiteral(resourceName: "appetizer"),#imageLiteral(resourceName: "appetizer")]
        let labels = ["Recipe1: ______\nCreator: ______","Recipe11: ______\nCreator: ______","Recipe2: ______\nCreator: ______","Recipe22: ______\nCreator: ______","Recipe3: ______\nCreator: ______","Recipe33: ______\nCreator: ______",]
        CollectionImage = images
        CollectionLabel = labels
    }
    
    private func setupCollection_2(){
        let images = [#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup")]
        let labels = ["Recipe: abc___\nCreator: ______","Recipe: bcf___\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______",]
        CollectionImage = images
        CollectionLabel = labels
    }
    
    private func setupCollection_3(){
        let images = [#imageLiteral(resourceName: "salad"),#imageLiteral(resourceName: "salad"),#imageLiteral(resourceName: "salad"),#imageLiteral(resourceName: "salad"),#imageLiteral(resourceName: "salad"),#imageLiteral(resourceName: "salad")]
        let labels = ["Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______"]
        CollectionImage = images
        CollectionLabel = labels
    }
    
    private func setupCollection_4(){
        let images = [#imageLiteral(resourceName: "cake"),#imageLiteral(resourceName: "cake"),#imageLiteral(resourceName: "cake"),#imageLiteral(resourceName: "cake"),#imageLiteral(resourceName: "cake"),#imageLiteral(resourceName: "cake")]
        let labels = ["Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______"]
        CollectionImage = images
        CollectionLabel = labels
    }
    
    private func setupCollection_5(){
        let images = [#imageLiteral(resourceName: "Pizza"),#imageLiteral(resourceName: "Pizza"),#imageLiteral(resourceName: "Pizza"),#imageLiteral(resourceName: "Pizza"),#imageLiteral(resourceName: "Pizza"),#imageLiteral(resourceName: "Pizza")]
        let labels = ["Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______"]
        CollectionImage = images
        CollectionLabel = labels
    }
    
    private func setupCollection_6(){
        let images = [#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),#imageLiteral(resourceName: "soup"),]
        let labels = ["Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______","Recipe: ______\nCreator: ______"]
        CollectionImage = images
        CollectionLabel = labels
    }
    
   
    
    
    
}


extension RecipeViewController: UISearchBarDelegate{
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchNames = CollectionLabel.filter({ $0.lowercased().contains(searchText.lowercased())})
        searching = true
        searchBar.showsCancelButton = true
        collectionRef.reloadData()
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
           return searchNames.count
        }
        else{ return CollectionImage.count }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionRef.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! CollectionViewCell
        
        if searching{
            cell.collectionLabel.text = searchNames[indexPath.row]
        }
        else{
            cell.collectionImage.image = CollectionImage[indexPath.row]
            cell.collectionLabel.text = CollectionLabel[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: EdgeOfCollectionView, left: EdgeOfCollectionView, bottom: EdgeOfCollectionView, right: EdgeOfCollectionView)
    }
    
    
    func roundCorners(view: UIView, cornerRadius: Double) {
           view.layer.cornerRadius = CGFloat(cornerRadius)
           view.clipsToBounds = true
    }
    
}
