//
//  userRecipeItemTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-01-23.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class userRecipeItemTableViewCell: UITableViewCell {
    
    var recipeData = [RecipeDetail]()
    var recipeImage = [UIImage]()
    var delegate : CollectionViewInsideUserTableView?
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.dataSource = self as UICollectionViewDataSource
            collectionView.delegate = self as UICollectionViewDelegate
            
        }
    }
    
//  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      if segue.identifier == "RecipeUnit" {
//        if let controller = segue.destination as? RecipeDetailViewController{
//            let cell = sender as! UICollectionViewCell
//            let indexPath = controller.collectionView.indexPath(for: cell)
//            controller.mainImage = recipeImage[(indexPath?.row)!]
//        }
//      }
//  }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension userRecipeItemTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(recipeImage.count)
        return recipeImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeItemForUser", for: indexPath) as! userRecipeItemCollectionViewCell
        cell.imageView.tag = indexPath.row
        cell.imageView.image = recipeImage[indexPath.row]
       return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
       
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellTaped(data: indexPath)
//
//       let cell =  collectionView.visibleCells[indexPath.row]
//        let vc = RecipeDetailViewController()
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeItemForUser", for: indexPath) as! userRecipeItemCollectionViewCell
//        if let index = collectionView.indexPath(for: cell){
//            vc.mainImage = recipeImage[index.row]
//            let a:AnyClass = self.superclass ??
//
//           let vcRoot =  UIViewController(nibName: "userPageViewController", bundle: nil)
//            UINavigationController(rootViewController: vcRoot).pushViewController(vc, animated: true)
//            self.superclass.pushViewController(vc, animated: nil)
//        }
    }
  
}
