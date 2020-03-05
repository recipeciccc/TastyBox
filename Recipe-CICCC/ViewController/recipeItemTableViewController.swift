//
//  recipeItemTableViewController.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-27.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


class recipeItemTableViewController: UITableViewController {
    

    
    var item = RecipeItem()
    var indexPath = IndexPath()
    
    let db = Firestore.firestore()

//    let identifiers = [1: "recipeMainCell", 2:"iconItem", 3:"creatorCellRecpipe", 4:"ingredients", 5: "how to cook"]

    var numImg = CGFloat(2.0) // depends on how many pictures user want to use, it is gonna change.
    
    let ingredients = IngredientsList()
    let HowToCookList = howToCookList()
    
    var currentPage:Int = 0
    var recipeDetail: RecipeDetail?
   
       
       override func viewDidLoad() {
           super.viewDidLoad()
//        getRecipeDetailFireStore()
//        let cell: recipeMainTableViewCell = (tableView.dequeueReusableCell(withIdentifier:"recipeMainCell") as? recipeMainTableViewCell)!
        
           // Do any additional setup after loading the view.
       }
    
       

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0, 1, 2, 3, 4:
            return 1
        case 5:
            return  ingredients.ingredientsList.count// this is for the number of ingredients
        case 6:
            return HowToCookList.howToCookList.count // this shows how to cook.
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400
        case 3:
            return 45  // this is for the number of ingredients
        case 4:
            return 78 // this shows how to cook.
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 || section == 2 || section == 3 || section == 4 {
            return 0.0
        }
        else {
            return 40.0
        }
    }
    
//    @objc fileprivate func didChangePage(_ currentProgress: Int, _ numberOfPages: Int, _ direction: recipeItemTableViewController.Direction) {
//        if currentProgress == numberOfPages - 1 {
//            direction = .left
//        }
//        else if currentProgress == 0 {
//            direction = .right
//        }
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let cell : recipeMainTableViewCell =  (tableView.dequeueReusableCell(withIdentifier:"recipeMainCell") as? recipeMainTableViewCell)!
            
            return cell
            
        }
        else if indexPath.section == 1 {
            let cell: titleTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "title") as? titleTableViewCell)!
           
            
            cell.titleLabel.text = recipeDetail?.title //item.recipeName
            
            return cell
        }
            
        else if indexPath.section == 2 {
            
            let cell: explanationTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "explanation") as? explanationTableViewCell)!
            
            cell.timeLabel.text = "\(recipeDetail?.cookingTime) mins"
            cell.servingLabel.text = "\(recipeDetail?.serving) serving"
            
            
//            cell.explanationLabel.sizeToFit()
//                       cell.heightForLabel.constant =  cell.explanationLabel.frame.size.height
            return cell
        }
        else if indexPath.section == 3 {
            let cell: iconItemTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "iconItem") as? iconItemTableViewCell)!
        
            cell.numLikeLabel.text = "\(recipeDetail?.like)"
            
            return cell
            
        }
        else if indexPath.section == 4 {
            let cell: creatorCellRecpipeTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "creatorCellRecpipe") as? creatorCellRecpipeTableViewCell)!
            
//            cell.creatorNameLabel.text = recipeDetail.creator
            return cell
        }
        else if indexPath.section == 5 {
            let cell: IngredientsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "ingredients") as? IngredientsTableViewCell)!
//
//            cell.ingredientsNameLabel.text = recipeDetail?.ingredient.name
//            cell.amountIngredientsLabel.text = recipeDetail?.ingredient.amount
            
//            cell.ingredientsNameLabel.text =  ingredients.ingredientsList[indexPath.row].ingredientName
//            cell.amountIngredientsLabel.text = ingredients.ingredientsList[indexPath.row].amountIngredient
            
            return cell
            
        } else {
        
            let cell: HowToCookTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "how to cook") as? HowToCookTableViewCell)!
            
            let _ = HowToCookList.howToCookList[indexPath.row]
            
            cell.howToCookLabel.text =  HowToCookList.howToCookList[indexPath.row].howToCook
            cell.howToCookLabel.numberOfLines = 0
            
            
            return cell
        
    }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 0, width:
        tableView.bounds.size.width, height: 28))
        headerLabel.textColor = UIColor.black
        
        headerLabel.textAlignment = .left
        
        
        let view:UIView = UIView(frame: CGRect(x: 0,y: 0,width: self.tableView.frame.size.width,height: 40.0))
        if section == 0 || section == 1 || section == 2 || section == 3 || section == 4{
            return view
        }
        else if section == 5 {
            view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.768627451, blue: 0.4431372549, alpha: 1)
            // how can I set color of text?
        
            view.addSubview(headerLabel)
            headerLabel.text = "Ingredients"
            headerLabel.sizeToFit()
            headerLabel.textColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            headerLabel.frame.origin.y = view.frame.size.height/2-headerLabel.frame.size.height/2
            //headerLabel.frame.origin.y = view.frame.size.height/2
            //view.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
            return view
        }
        else if section == 6 {
            view.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.768627451, blue: 0.4431372549, alpha: 1)
            // how can I set color of text?
        
            view.addSubview(headerLabel)
            headerLabel.text = "How to Cook"
            headerLabel.sizeToFit()
            headerLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            headerLabel.frame.origin.y = view.frame.size.height/2-headerLabel.frame.size.height/2
            //headerLabel.frame.origin.y = view.frame.size.height/2
            //view.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
            return view
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension recipeItemTableViewController {
    
//    func getRecipeDetailFireStore(){
//
//         var recipe: RecipeDetail?
//
//        db.collection("recipe").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//
//
//                    let docId = document.documentID
//                    let title = document.get("title") as! String
//                    let cookingTime = document.get("Cooking Time") as! Int
////                    let image = document.get("image") as! String
//                    let like = document.get("like") as! Int
//                    let serving = document.get("serving") as! Int
////                    let ingredientName =
//
////                    let db = Firestore.firestore()
////
////                    db.collection("reciepe").getDocuments() {(querySnapshot, error) in
////
////                        if let querySnapshot = querySnapshot {
////                            for document in querySnapshot.documents {
////                                print("\n\(document.data()) SUCCESS!!\n")
////
////                            }
////                            print(querySnapshot.documents.count)
////                        }
////                    }
//                    let ingredient =
////                    let ingredient = Ingredient(name: (document.get("ingredient/name") as? String?)!!, amount: (document.get("ingredient/amount") as? String)!)
////                    let instruction = Instruction(image: <#T##UIImage#>, text: <#T##String#>)
//                    print(docId, cookingTime, like, serving, title)
//
//                    //recipe = RecipeDetail(id: docId, title: title, cookingTime: cookingTime, like: like, serving: serving, ingredient: ingredient)
////                    self.recipeDetail = recipe
//                    self.tableView.reloadData()
//                }
//            }
//           }
//
//    }
}
