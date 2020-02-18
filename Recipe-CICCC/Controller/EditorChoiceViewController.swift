//
//  EditorChoiceViewController.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class EditorChoiceViewController: UIViewController {
    
    
    
    
    var imageArray = [Image]()
    var arrayMenu = [String]()
    var searchIMageName = [Image]()
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CreateImageArray()
        // Do any additional setup after loading the view.
    }
    
    func CreateImageArray() {
        let image1 = Image(title: "Appetizer", image: #imageLiteral(resourceName: "elli-o-XoByiBymX20-unsplash"))
        let image2 = Image(title: "Main Dish", image: #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055"))
        let image3 = Image(title: "Salad", image: #imageLiteral(resourceName: "Image"))
        let image4 = Image(title: "Dessert", image: #imageLiteral(resourceName: "vegan-valentines-day-recipe-950x950"))
        let image5 = Image(title: "Beverage", image: #imageLiteral(resourceName: "shenggeng-lin-XoN3v3Ge7EE-unsplash"))
        
        imageArray.append(image1)
        imageArray.append(image2)
        imageArray.append(image3)
        imageArray.append(image4)
        imageArray.append(image5)
        
    }
}

extension EditorChoiceViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let image = imageArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as! ImagesCell
        
        cell.setImage(UIimage: image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewContoller = storyboard?.instantiateViewController(withIdentifier: "RecipeViewController") as? RecipeViewController
        let image = imageArray[indexPath.row]
        viewContoller?.T_image = image.image
        viewContoller?.T_Name = image.title
        viewContoller?.category = indexPath.row
        self.navigationController?.pushViewController(viewContoller!, animated: true)
    }
        
}


