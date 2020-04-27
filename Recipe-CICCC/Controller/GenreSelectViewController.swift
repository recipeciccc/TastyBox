//
//  GenreSelectViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol GenreSelectViewControllerDelegate: class {
    func assignGenres(genres: [String], isVIP: Bool)
}

class GenreSelectViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tags = ["Valentine's Day", "Cozy Spring", "Quick and Simple", "Home Cooking", "Appetizer",  "Main Dish", "Salad", "Dessert", "Beverage"]
    var imageLabelingTags: [String] = []
    var isHighrightsNotImageLabelsGenres: [String:Bool] = [:]
    var isHighlightsImageLabelsGenres: [String:Bool] = [:]
    var isHighlightVIP = false
    var image = UIImage()
    
    var tagsSelected: [String] = []
    weak var delegate: GenreSelectViewControllerDelegate?
    let dataManager = GenreMLKitDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        dataManager.delegate = self
        
        if tagsSelected.isEmpty {
            for tag in tags {
                isHighrightsNotImageLabelsGenres[tag] = false
            }
            
        } else {
            print("passed tags \(tagsSelected)")
            for tag in tags {
                
                for tagSelected in tagsSelected {
                    if tag == tagSelected {
                        isHighrightsNotImageLabelsGenres[tag] = true
                        break
                    }
                    else {  isHighrightsNotImageLabelsGenres[tag] = false }
                }
                
            }
            
        }
        
        dataManager.labelingImage(image: image)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        
        tagsSelected.removeAll()
        for tag in tags {
            if isHighrightsNotImageLabelsGenres[tag]! {
                tagsSelected.append(tag)
            }
        }
        print(tagsSelected)
        
        self.delegate?.assignGenres(genres: tagsSelected, isVIP: isHighlightVIP)
        navigationController?.popViewController(animated: true)
    }
    
}

extension GenreSelectViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else if section == 1 { return imageLabelingTags.count}
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!
        
        if indexPath.section == 0 {
            //            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!
            
            
            cell.genreLabel.text = "VIP"
            cell.highlight(active: false)
            
            return cell
        }
        else if indexPath.section == 1 {
            
            //            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!
            
            cell.genreLabel.text = imageLabelingTags[indexPath.row]
            
            if !isHighlightsImageLabelsGenres.isEmpty {
                if isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]]! {
                    cell.highlight(active: true)
                } else {
                    cell.highlight(active: false)
                }
            }
        } else {
            
            
            
            cell.genreLabel.text = tags[indexPath.row]
            
            if isHighrightsNotImageLabelsGenres[tags[indexPath.row]]! {
                cell.highlight(active: true)
            } else {
                cell.highlight(active: false)
            }
            
            
        }
        
        return cell
    }
    
    
}
extension GenreSelectViewController: GenreMLKitDataManagerDelegate {
    func passLabeledArray(arr: [String]) {
        imageLabelingTags = arr
        
        //        if imageLabelingTags.isEmpty {
        for tag in imageLabelingTags {
            isHighlightsImageLabelsGenres[tag] = Bool()
            isHighrightsNotImageLabelsGenres[tag] = false
        }
        //        }
        
        self.collectionView.reloadData()
    }
}

extension GenreSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)!
            
            isHighlightVIP =  !isHighlightVIP
            cell.highlight(active: isHighlightVIP)
        }
        else if indexPath.section == 1{
            let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)!
            
            isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]] =  !isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]]!
            cell.highlight(active: isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]]!)
        }
        
        let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)!
        
        isHighrightsNotImageLabelsGenres[tags[indexPath.row]]! =  !isHighrightsNotImageLabelsGenres[tags[indexPath.row]]!
        cell.highlight(active: isHighrightsNotImageLabelsGenres[tags[indexPath.row]]!)
    }
}


