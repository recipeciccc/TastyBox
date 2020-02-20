//
//  MonthlyViewController.swift
//  RecipeProject_v2
//
//  Created by fangyilai on 2019-12-05.
//  Copyright © 2019 fangyilai. All rights reserved.
//

import UIKit

class MonthlyViewController: UIViewController {    
    
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
        let image1 = Image(title: "Valentine's Day", image: #imageLiteral(resourceName: "shenggeng-lin-XoN3v3Ge7EE-unsplash"))
        let image2 = Image(title: "Cozy Spring", image: #imageLiteral(resourceName: "images"))
        let image3 = Image(title: "Quick and Simple", image: #imageLiteral(resourceName: "190411-potato-salad-horizontal-1-1555688422"))
        let image4 = Image(title: "Healthy Diet", image: #imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"))
        let image5 = Image(title: "Home Cooking", image: #imageLiteral(resourceName: "images (1)"))
        
        imageArray.append(image1)
        imageArray.append(image2)
        imageArray.append(image3)
        imageArray.append(image4)
        imageArray.append(image5)
        
    }
}

extension MonthlyViewController: UITableViewDataSource, UITableViewDelegate{
    
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

