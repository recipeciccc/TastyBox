//
//  RecipeCollectionView.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

@IBDesignable
class RecipeCollectionView: UIView {

    @IBOutlet var R_view: UIView!
    @IBOutlet weak var R_collectionView: UICollectionView!
    
        var imageArray = [UIImage]()
        var recipeName = [String]()
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        private func commonInit() {
            let bundle = Bundle(for: type(of: self))
            bundle.loadNibNamed("RecipeCollectionView", owner: self, options: nil)
            addSubview(R_view)
            
            imageArray = [#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "Lemon-Garlic-Butter-Salmon-with-Zucchini-Noodles-recipes"),#imageLiteral(resourceName: "candied-yams-5"),#imageLiteral(resourceName: "best-salad-7"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055"),#imageLiteral(resourceName: "Intrepid-Travel-Taiwan-dumplings-Xiao-Long-Bao_577219075"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723")]
            recipeName = ["Title","Title","Title","Title","Title","Title","Title","Title","Title","It's a test for auto-shrink!!!!!!!!!!!!"]
            initCollectionView()
        }
        
        private func initCollectionView() {
            let nib = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
            R_collectionView.register(nib, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
            R_collectionView.dataSource = self
            R_collectionView.delegate = self
        }
    
    
        
    }

    extension RecipeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return imageArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
            cell.R_image.image = imageArray[indexPath.row]
            cell.R_Label.text = recipeName[indexPath.row]
            return cell
        }
        
    }

    extension RecipeCollectionView: UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 10, bottom: 200, right: 10)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (collectionView.bounds.width - 30) / 2, height: 170)
        }
        
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                
            return 5
        }
            
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                
            return 10
        }

}
