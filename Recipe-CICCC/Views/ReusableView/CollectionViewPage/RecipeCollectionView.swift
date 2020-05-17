//
//  RecipeCollectionView.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol RecipeCollectionViewDelegate: class {
    func pushViewController(recipe: RecipeDetail?, image: UIImage?, creator: User?)
}

@IBDesignable
class RecipeCollectionView: UIView {
    
    @IBOutlet var R_view: UIView!
    @IBOutlet weak var R_collectionView: UICollectionView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
//    @IBOutlet weak var width: NSLayoutConstraint!
//    @IBOutlet weak var height: NSLayoutConstraint!
//    var width: NSLayoutConstraint?
//    var height: NSLayoutConstraint?
    
    weak var delegate: RecipeCollectionViewDelegate?
    
    var imageDictionary: [Int:UIImage] = [:] {
        didSet {
            R_collectionView.reloadData()
        }
    }
    var recipes = [RecipeDetail](){
        didSet {
            R_collectionView.reloadData()
        }
    }
    
    var users :[User] = []
    var isVIP: Bool? {
        didSet {
            R_collectionView.reloadData()
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    
    
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
        
        initCollectionView()
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "RecipeCollectionViewCell", bundle: nil)
        R_collectionView.register(nib, forCellWithReuseIdentifier: "RecipeCollectionViewCell")
        R_collectionView.dataSource = self
        R_collectionView.delegate = self
        width.constant = UIScreen.main.bounds.size.width
        height.constant = UIScreen.main.bounds.size.height
    }
}

extension RecipeCollectionView: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as! RecipeCollectionViewCell
       
        cell.lockImage.isHidden = isVIP ?? false
        
        cell.R_image.image = imageDictionary[indexPath.row]
        cell.R_Label.text = recipes[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if let isVIP = isVIP {
            
            if isVIP == true {
            delegate?.pushViewController(recipe: recipes[indexPath.row], image: imageDictionary[indexPath.row]!, creator: users[indexPath.row])
            } else {
                delegate?.pushViewController(recipe: nil, image: nil, creator: nil)
            }
        } else {
            
             delegate?.pushViewController(recipe: nil, image: nil, creator: nil)
        
        }
        }
    
}

extension RecipeCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-30) / 2, height: (collectionView.frame.size.width-30) / 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
}
