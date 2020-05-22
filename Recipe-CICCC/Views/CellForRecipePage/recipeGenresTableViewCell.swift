//
//  recipeGenresTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol PushSearchingGenres: class {
    func pushSearedResult(vc: ResultRecipesViewController)
}

class recipeGenresTableViewCell: UITableViewCell {

    @IBOutlet weak var genresCollectionView: UICollectionView!
    weak var delegate: PushSearchingGenres?
    var genres:[String] = []
    
    func configure(with arr: [String]) {
        self.genres = arr
       
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        
        self.genresCollectionView.reloadData()
        self.genresCollectionView.layoutIfNeeded()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
         self.contentView.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension recipeGenresTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeGenres", for: indexPath) as! recipeGenresCollectionViewCell
        cell.genreLabel.text = "#\(self.genres[indexPath.row])"
        cell.contentView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "resultRecipes") as! ResultRecipesViewController
        
        vc.searchingCategory = "genres"
        vc.searchingWord = self.genres[indexPath.row]
       
        delegate?.pushSearedResult(vc: vc)
       
    }
}
