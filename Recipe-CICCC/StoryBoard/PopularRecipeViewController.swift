//
//  PopularRecipeViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class PopularRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: RecipeDetail?
    var recipes = [RecipeDetail]()
    let db = Firestore.firestore()
    
    var recipeImages: [UIImage] = []
    
    var numberLikes = [110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
    var numberComments = [110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10]
    var titles = ["Courgette and durian salad", "Denjang and fontina cheese salad", "Coriander and duck korma", "Cheese and raisin cupcakes","Cavatelli and nutmeg salad", "Goji berry and arugula salad","Celeriac and spinach wontons", "Lamb and rhubarb pie", "Apricot and cheese cheesecake", "Goat and mushroom madras"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getReipeDetail()
        getImage(imageString: "test")
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        self.tableView.reloadData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension PopularRecipeViewController: UITableViewDelegate {
    
}

extension PopularRecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else  {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if recipes.isEmpty {
            let returnedRecipe = RecipeDetail(id: "none", title: "none", cookingTime: 0, like: 0, serving: 0)
            
            for _ in 0...9 {
                recipes.append(returnedRecipe)
                
            }
        }
        
        print(recipeImages)
        
        if !recipeImages.isEmpty {
            let returnedRecipe = #imageLiteral(resourceName: "vegan-valentines-day-recipe-950x950")
            
            for _ in 0...9 {
                recipeImages.append(returnedRecipe)
                
            }
        }
        
        if indexPath.section == 0 {
            
            let cell = (tableView.dequeueReusableCell(withIdentifier: "medal recipe", for: indexPath) as? Number123TableViewCell)!
            
//            cell.numberLikeLabel.text = "\(recipes[indexPath.row].like)" // 150
//            //                cell.numberLikeLabel.text = "\(numberLikes[indexPath.row]) Likes"
//            cell.numberCommentLabel.text = "\(recipes[indexPath.row].cookingTime)"
//            cell.titleLabel.text = recipes[indexPath.row].title
            
            cell.numberLikeLabel.text = "\(recipes[0].like)" // 150
            //                cell.numberLikeLabel.text = "\(numberLikes[indexPath.row]) Likes"
            cell.numberCommentLabel.text = "\(recipes[0].cookingTime)"
            cell.titleLabel.text = recipes[0].title
            
           
            
            switch indexPath.row {
            case 0:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 28")
//                cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
                cell.recipeImageView.image = recipeImages[indexPath.row]
               
            case 1:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 29")
//                cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
                cell.recipeImageView.image = recipeImages[indexPath.row]
               
            case 2:
                cell.badgeImageView.image = #imageLiteral(resourceName: "Group 30")
//                cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
                cell.recipeImageView.image = recipeImages[indexPath.row]
                
            default:
                break
            }
            
            
            
            return cell
        }
        
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "under no.4", for: indexPath) as? UnderNo4TableViewCell)!
        
//        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
//        cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
//        cell.numLikeLabel.text = "\(recipes[indexPath.row + 4].like)"
//        cell.numCommentLabel.text = "\(recipes[indexPath.row + 4].cookingTime)"
//        cell.titleLabel.text = recipes[indexPath.row + 4].title
        
        cell.rankingLabel.text = "No. \(indexPath.row + 4)"
        cell.recipeImageView.image = #imageLiteral(resourceName: "How-to-Make-the-Best-Juiciest-Turkey-Meatballs_055")
        cell.numLikeLabel.text = "\(recipes[1].like)"
        cell.numCommentLabel.text = "\(recipes[1].cookingTime)"
        cell.titleLabel.text = recipes[1].title
        
        
        print("recipes.count: \(recipes.count)")
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: getData


extension PopularRecipeViewController {
    
     func getReipeDetail() {
            
            // this cant be executed before put value to cell.textlabel
            //        db.collection("recipe").document("OfcILMhCh3LVMNhE60I7").getDocument(source: .cache) {
            //            (document, error) in
            //            if let document = document {
            //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            //                print("Cached document data: \(dataDescription)")
            //
            //                let data = document.data()
            //                 self.initRecipeDetail(data: data)
            //            } else {
            //                print("Document does not exist in cache")
            //              }
            //        }
            
        db.collection("recipe").getDocuments {
            (querysnapshot, error) in
            if error != nil {
                print("Error getting documents: \(String(describing: error))")
            } else {
                
                //For-loop
                for documents in querysnapshot!.documents
                {
                    self.recipes.removeAll()
                    let document = querysnapshot!.documents
                    
                    for (index, element) in document.enumerated() {
                        print("document count：\(document.count)")
                        let data = element.data()
                        
                        print("data count: \(data.count)")
                        
                       
                        let id = data["id"] as? String
                        let title = data["title"] as? String
                        let cookingTime = data["Cooking Time"] as? Int
                        let like = data["like"] as? Int
                        let serving = data["serving"] as? Int
                        
                        let recipe = RecipeDetail(id: id!, title: title!, cookingTime: cookingTime!, like: like!, serving: serving!)
                        self.recipes.append(recipe)
                    }
                }
            }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                   
                }
        }
    }
    
    func getImage(imageString: String) -> [UIImage] {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        var image: UIImage = #imageLiteral(resourceName: "foodiesfeed.com_pizza-ready-for-baking")
        
        // Create a child reference
        // imagesRef now points to "images"
//        let imagesRef = storageRef.child("recipeImages")

        // Child references can also take paths delimited by '/'
        // spaceRef now points to "images/space.jpg"
        // imagesRef still points to "images"
        let imagesRef = storageRef.child("recipeImages")

        // This is equivalent to creating the full reference
//        let storagePath = "\(your_firebase_storage_bucket)/images/space.jpg"
//        spaceRef = storage.reference(forURL: storagePath)
        
        
      // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
      imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if error != nil {
          // Uh-oh, an error occurred!
        } else {
          // Data for "images/island.jpg" is returned
            
            
            
            if !self.recipeImages.isEmpty{
                self.recipeImages.removeAll()
                image = UIImage(data: data!)!
                self.recipeImages.append(image)
            }
            
        }
      }
        
        recipeImages.append(image)
        return recipeImages
    }
}


