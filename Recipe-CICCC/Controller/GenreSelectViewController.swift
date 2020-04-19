//
//  GenreSelectViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

protocol GenreSelectViewControllerDelegate: class {
    func assignGenres(genres: [String])
}

class GenreSelectViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var tags = ["Valentine's Day", "Cozy Spring", "Quick and Simple", "Home Cooking", "Appetizer",  "Main Dish", "Salad", "Dessert", "Beverage"]
    var isHighrights: [String:Bool] = [:]
    var isHighlightVIP = false
    
    var tagsSelected: [String] = []
    weak var delegate: GenreSelectViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if tagsSelected.isEmpty {
            for tag in tags {
                isHighrights[tag] = false
            }
        
        } else {
           print("passed tags \(tagsSelected)")
            for tag in tags {
                
                    for tagSelected in tagsSelected {
                        if tag == tagSelected {
                            isHighrights[tag] = true
                            break
                        }
                        else {  isHighrights[tag] = false }
                    }
               
            }
            
        }
        
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
            if isHighrights[tag]! {
                tagsSelected.append(tag)
            }
        }
        print(tagsSelected)
       
        self.delegate?.assignGenres(genres: tagsSelected)
        navigationController?.popViewController(animated: true)
    }
    
}

extension GenreSelectViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if indexPath.section == 0 {
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!
            
            
            cell.genreLabel.text = "VIP"
            cell.highlight(active: false)
            
            return cell
        }
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!
        
        cell.genreLabel.text = tags[indexPath.row]
        
        if isHighrights[tags[indexPath.row]]! {
            cell.highlight(active: true)
        } else {
            cell.highlight(active: false)
        }
        
        return cell
    }
    
    
}
extension GenreSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)!
                   
            isHighlightVIP =  !isHighlightVIP
            cell.highlight(active: isHighlightVIP)
        }
        let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)!
        
        isHighrights[tags[indexPath.row]]! =  !isHighrights[tags[indexPath.row]]!
        cell.highlight(active: isHighrights[tags[indexPath.row]]!)
    }
}
