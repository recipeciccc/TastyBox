//
//  GenreSelectViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-17.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Crashlytics

protocol MealTypeSelectViewControllerDelegate: class {
    func assignGenres(genres: [String], imagesLabels: [String], imagesLabelsSelected: [String], isVIP: Bool)
}

class MealTypeSelectViewController: UIViewController {
    
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var tags = ["Valentine's Day", "Cozy Spring", "Quick and Simple", "Home Cooking", "Appetizer",  "Main Dish", "Salad", "Dessert", "Beverage", "Healthy Diet"]
    var imageLabelingTags: [String] = []
    var imageLabelingTagsSelected: [String] = []
    var isHighlightsNotImageLabelsGenres: [String:Bool] = [:]
    var isHighlightsImageLabelsGenres = [String:Bool]()
    var isHighlightVIP = false
    var image: UIImage?
    let indicator = UIActivityIndicatorView()
    var uiView = UIView()
    
    var tagsSelected: [String] = []
    weak var delegate: MealTypeSelectViewControllerDelegate?
    let dataManager = GenreMLKitDataManager()
    
    private let spacing:CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        dataManager.delegate = self
        
        if tagsSelected.isEmpty {
            for tag in tags {
                isHighlightsNotImageLabelsGenres[tag] = false
            }
            doneButton.isEnabled = false
        } else {
            print("passed tags \(tagsSelected)")
            for tag in tags {
                
                for tagSelected in tagsSelected {
                    if tag == tagSelected {
                        isHighlightsNotImageLabelsGenres[tag] = true
                        break
                    }
                    else {  isHighlightsNotImageLabelsGenres[tag] = false }
                }
                
            }
            
        }
        
        if imageLabelingTagsSelected.isEmpty && image != nil {
            dataManager.labelingImage(image: image!)
            
            uiView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  self.view.frame.size.height))
            uiView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            uiView.tag = 100
            indicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            
            indicator.hidesWhenStopped = true
            indicator.color = .orange
            indicator.center = self.view.center
            
            uiView.addSubview(indicator)
            
            self.view.addSubview(uiView)
            
            
            DispatchQueue.global(qos: .default).async {
                
                // Do heavy work here
                
                DispatchQueue.main.async { [weak self] in
                    // UI updates must be on main thread
                    self?.indicator.startAnimating()
                }
            }
            
            doneButton.isEnabled = false
        }
        else if !imageLabelingTagsSelected.isEmpty {
            
            print("passed tags \(imageLabelingTagsSelected)")
            
            for tag in imageLabelingTags {
                
                for tagSelected in imageLabelingTagsSelected {
                    if tag == tagSelected {
                        isHighlightsImageLabelsGenres[tag] = Bool()
                        isHighlightsImageLabelsGenres[tag] = true
                        break
                    }
                    else {
                        isHighlightsImageLabelsGenres[tag] = Bool()
                        isHighlightsImageLabelsGenres[tag] = false
                        
                    }
                }
                
            }
            self.collectionView.reloadData()
        }
        
        `switch`.isOn = false
        `switch`.onTintColor = .orange
        if isHighlightVIP {
            `switch`.isOn = true
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
    
    @IBAction func VIPAction(_ sender: UISwitch) {
        
        if sender.isOn {
            doneButton.isEnabled = true
            isHighlightVIP = true
        } else {
            isHighlightVIP = false
            shouldDoneButtonEnabled()
        }
    }
    
    
    
    @IBAction func cancel(_ sender: Any) {
        
        self.delegate?.assignGenres(genres: tagsSelected, imagesLabels: imageLabelingTags, imagesLabelsSelected: imageLabelingTagsSelected, isVIP: isHighlightVIP)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        
        tagsSelected.removeAll()
        for tag in tags {
            if isHighlightsNotImageLabelsGenres[tag]! {
                tagsSelected.append(tag)
            }
        }
        print(tagsSelected)
        
        for tag in imageLabelingTags {
            if isHighlightsImageLabelsGenres[tag]! {
                imageLabelingTagsSelected.append(tag)
            }
        }
        
        print(imageLabelingTagsSelected)
        
        self.delegate?.assignGenres(genres: tagsSelected, imagesLabels: imageLabelingTags, imagesLabelsSelected: imageLabelingTagsSelected, isVIP: isHighlightVIP)
        
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func shouldDoneButtonEnabled() {
           
           doneButton.isEnabled = false

           for isHighLight in isHighlightsImageLabelsGenres {
               if isHighLight.value && doneButton.isEnabled == false{
                   doneButton.isEnabled = true
                   break
               }
               
               
           }
           
           if doneButton.isEnabled == false {
               
               for isHighLight in isHighlightsNotImageLabelsGenres {
                   if isHighLight.value && doneButton.isEnabled == false{
                       doneButton.isEnabled = true
                       break
                   }
               
               }
           }
           
           
       }
}

extension MealTypeSelectViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 { return imageLabelingTags.count}
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!

        if indexPath.section == 0 {
            
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell)!
            
            cell.genreLabel.text = imageLabelingTags[indexPath.row]
            
            if !imageLabelingTags.isEmpty && !isHighlightsImageLabelsGenres.isEmpty {
                if isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]]! {
                    cell.highlight(active: true)
                } else {
                    cell.highlight(active: false)
                }
            }
            return cell
            
        } else {
            
            cell.genreLabel.text = tags[indexPath.row]
            
            if isHighlightsNotImageLabelsGenres[tags[indexPath.row]]! {
                cell.highlight(active: true)
            } else {
                cell.highlight(active: false)
            }
            
            
        }
        
        return cell
    }
    
    
}


extension MealTypeSelectViewController: GenreMLKitDataManagerDelegate {
    func passLabeledArray(arr: [String]) {
        imageLabelingTags = arr
        
        //        if imageLabelingTags.isEmpty {
        for tag in imageLabelingTags {
            isHighlightsImageLabelsGenres[tag] = Bool()
            isHighlightsNotImageLabelsGenres[tag] = false
        }
        //        }
        
        self.collectionView.reloadData()
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        DispatchQueue.global(qos: .default).async {
            
            // Do heavy work here
            
            DispatchQueue.main.async { [weak self] in
                // UI updates must be on main thread
                self?.indicator.stopAnimating()
            }
        }
    }
}

extension MealTypeSelectViewController: UICollectionViewDelegate {
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)!
        
        if indexPath.section == 0{
            
            isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]] =  !isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]]!
            
            cell.highlight(active: isHighlightsImageLabelsGenres[imageLabelingTags[indexPath.row]]!)
        } else {
            
            
            isHighlightsNotImageLabelsGenres[tags[indexPath.row]]! =  !isHighlightsNotImageLabelsGenres[tags[indexPath.row]]!
            cell.highlight(active: isHighlightsNotImageLabelsGenres[tags[indexPath.row]]!)
        }
        
        shouldDoneButtonEnabled()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeaderGenreSelectCollectionReusableView{
            if indexPath.section == 0 {
                sectionHeader.titleLabel.text = "Top Suggested"
                sectionHeader.titleLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold", size: 20.0)
            } else {
                sectionHeader.titleLabel.text = "Others"
            }
        
            return sectionHeader
        }
        return UICollectionReusableView()
    }

}


