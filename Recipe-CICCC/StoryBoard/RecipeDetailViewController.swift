//
//  RecipeDetailViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-12.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RecipeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailTableView: UITableView!
    var mainPhoto = UIImage()
    var userProfile = Bool()
    var ridList = [String]()
    var recipe: RecipeDetail?
    var creator: User?
    
    var ingredientList  = [Ingredient]()
    var instructionList = [Instruction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.tableFooterView = UIView()
        detailTableView.separatorStyle = .none
        
        let dbRef = Firestore.firestore().collection("recipe").document(recipe?.recipeID ?? "")
        
        let query_ingredient = dbRef.collection("ingredient").order(by: "ingredient", descending: false)
        let query_instruction = dbRef.collection("instruction").order(by: "index", descending: false)
      //  let query_comment = dbRef.collection("comment").order(by: "time", descending: true)
        
        getIngredientData(query: query_ingredient)
        getInstructionData(query: query_instruction)
    }
}

extension RecipeDetailViewController{
    func getIngredientData(query:Query){
        query.getDocuments { (snapshot, err) in
            if err != nil{
                print("Error: Can not fetch data.")
            }
            else{
                if let snap = snapshot?.documents{
                    for document in snap{
                        let ingredientData = document.data()
                        let name = ingredientData["ingredient"] as? String
                        let amount = ingredientData["amount"] as? String
                        self.ingredientList.append(Ingredient(name: name!, amount: amount!))
                    }
                    DispatchQueue.main.async {
                        self.detailTableView.reloadData()
                    }
                }
            }
        }
    }
    func getInstructionData(query:Query){
        query.getDocuments { (snapshot, err) in
            if err != nil{
                print("Error: Can not fetch data.")
            }
            else{
                if let snap = snapshot?.documents{
                    for document in snap{
                        let Data = document.data()
                        let url = Data["image"] as? String
                        let text = Data["text"] as? String
                        self.instructionList.append(Instruction(imageUrl: url!, text: text!))
                    }
                    DispatchQueue.main.async {
                        self.detailTableView.reloadData()
                    }
                }
            }
        }
    }
}


extension RecipeDetailViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 5:
            return ingredientList.count
        case 6:
            return instructionList.count
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "mainImage") as? MainImageRecipeTableViewCell)!
            cell.mainImageView?.image = mainPhoto
            
            return cell
        case 1:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "title") as? titleTableViewCell)!
            
            cell.titleLabel.text = recipe?.title
            
            return cell
        case 2:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "servingAndTime") as? ServingAndTimeTableViewCell)!
            cell.servingLabel.text = "\(recipe?.serving ?? 0) serving"
            cell.timeLabel.text = "\(recipe?.cookingTime ?? 0) mins"
            
            return cell
            
        case 3:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "icons") as? iconItemTableViewCell)!
            cell.numLikeLabel.text = "\(recipe?.like ?? 0)"
            cell.delegate = self as? iconItemTableViewCellDelegate
            
            return cell
        case 4:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creator") as? creatorCellRecpipeTableViewCell)!
<<<<<<< HEAD
            
            cell.delegate = self as? AddingFollowersDelegate
//            cell.imgCreator.setImage(creator.image, for: .normal)
=======
            if userProfile == true{
                cell.followBtn.isHidden = true
            }else{
                cell.followBtn.isHidden = false
            }
            cell.delegate = self as? creatorCellRecpipeTableViewCellDelegate
            //            cell.imgCreator.setImage(creator.image, for: .normal)
>>>>>>> 3d4e3ccf64b95563a9efc151d57a78387eee928d
            cell.labelCreator.setTitle(creator?.name, for: .normal)
            
            return cell
        case 5:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ingredientRecipe") as? IngredientsTableViewCell)!
            if ingredientList.count > 0{
                cell.nameIngredientsLabel.text = ingredientList[indexPath.row].name
                cell.amountIngredientsLabel.text = ingredientList[indexPath.row].amount
            }
            return cell
        case 6:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "instructionsRecipe") as? HowToCookTableViewCell)!
            if instructionList.count > 0{
                cell.howToCookLabel.text = instructionList[indexPath.row].text
            }
            //  cell.imageView?.image = recipe?.instructions[indexPath.row].image
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 350
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



// this extension tell firebase to increase this recipe's like
//
//extension RecipeDetailViewController: iconItemTableViewCellDelegate{
//    func increaseLike() {
//        <#code#>
//    }
//}

// this extension tell firebase to increase this user's follower.

//extension RecipeDetailViewController: creatorCellRecpipeTableViewCellDelegate{
//    func increaseFollower() {
//        <#code#>
//    }
//
//
// }
