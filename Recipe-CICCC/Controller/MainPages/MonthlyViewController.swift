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
    
    var recipeImages = [UIImage]()
    var recipeLabels = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CategoryArray()
        RecipeArray()
    
    }
    

    func CategoryArray() {
        let image1 = Image(title: "Valentine's Day", image: #imageLiteral(resourceName: "Easy-strawberry-desserts-–-Greek-Yogurt-recipes-–-Valentines-desserts"))
        let image2 = Image(title: "Cozy Spring", image: #imageLiteral(resourceName: "Valentines-Day-Cookie-Bars-1-3-680"))
        let image3 = Image(title: "Quick and Simple", image: #imageLiteral(resourceName: "190411-potato-salad-horizontal-1-1555688422"))
        let image4 = Image(title: "Healthy Diet", image: #imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"))

        let image5 = Image(title: "Home Cooking", image: #imageLiteral(resourceName: "merlin_141075420_edfc0f4f-ba70-4542-a881-085a9dc162b9-articleLarge"))
        
        imageArray.append(image1)
        imageArray.append(image2)
        imageArray.append(image3)
        imageArray.append(image4)
        imageArray.append(image5)
    }
    
    func RecipeArray(){
        recipeImages = [#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "2018_Sweet-Sallty-Snack-Mix_5817_600x600"),#imageLiteral(resourceName: "Lemon-Garlic-Butter-Salmon-with-Zucchini-Noodles-recipes"),#imageLiteral(resourceName: "candied-yams-5"),#imageLiteral(resourceName: "best-salad-7"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723"),#imageLiteral(resourceName: "huevos-rancheros"),#imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055"),#imageLiteral(resourceName: "Intrepid-Travel-Taiwan-dumplings-Xiao-Long-Bao_577219075"),#imageLiteral(resourceName: "guacamole-foto-heroe-1024x723")]
        recipeLabels = ["Title:a1\nCreator:","Title:a2\nCreator:","Title:a3\nCreator:","Title:b1\nCreator:","Title:b2\nCreator:","Title:b3\nCreator:","Title:\nCreator:","Title:\nCreator:","Title:\nCreator:","It's a test for auto-shrink!!!!!!!!!!!!"]
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
        
        /* pseudo code:
            if indexPath.row == dataBase Category Number {
                fetch data from database;
                viewContoller?.recipeImages = Images data;
                viewContoller?.recipeLabels = labels data;
            }
        */
        switch indexPath.row{
        case 0: viewContoller?.recipeImages = self.recipeImages; viewContoller?.recipeLabels = self.recipeLabels; break
        case 1: viewContoller?.recipeImages = self.recipeImages; viewContoller?.recipeLabels = self.recipeLabels; break
        case 2: viewContoller?.recipeImages = self.recipeImages; viewContoller?.recipeLabels = self.recipeLabels; break
        case 3: viewContoller?.recipeImages = self.recipeImages; viewContoller?.recipeLabels = self.recipeLabels; break
        case 4: viewContoller?.recipeImages = self.recipeImages; viewContoller?.recipeLabels = self.recipeLabels; break
        case 5: viewContoller?.recipeImages = self.recipeImages; viewContoller?.recipeLabels = self.recipeLabels; break
        default: print("no category"); break
        }
        
        
       // viewContoller?.category = indexPath.row
        
        self.navigationController?.pushViewController(viewContoller!, animated: true)
    }
        
}

