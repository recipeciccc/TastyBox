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
    var getImg = FetchRecipeImage()
    var mainPhoto = UIImage()
    var userProfile = Bool()
    var recipe: RecipeDetail?
    var creator: User?
    
    var ingredientList  = [Ingredient]()
    var instructionList = [Instruction]()

//    var comment = [Comment]()
    
    let dataManager1 = RecipeDetailDataManager()
    let dataManager2 = FetchRecipeData()

    var instructionImgs = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.tableFooterView = UIView()
        detailTableView.separatorStyle = .none
        getImg.delegateImg = self
        
        let dbRef = Firestore.firestore().collection("recipe").document(recipe?.recipeID ?? "")
        
        let query_ingredient = dbRef.collection("ingredient").order(by: "ingredient", descending: false)
        let query_instruction = dbRef.collection("instruction").order(by: "index", descending: false)
        

        
        dataManager1.getIngredientData(query: query_ingredient, tableView: detailTableView)
        dataManager1.getInstructionData(query: query_instruction, tableView: detailTableView)
        dataManager1.getUserProvideRecipe(recipe: recipe!)

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
                        self.instructionList.append(Instruction(index: -1, imageUrl: url!, text: text!))
                    }
                    DispatchQueue.main.async {
                        self.detailTableView.reloadData()
                        
                        self.instructionImgs = self.getImg.getInstructionImg(uid: self.recipe?.userID ?? "",rid: self.recipe?.recipeID ?? "", count: self.instructionList.count)
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
            cell.servingLabel.text = "\(String(describing: recipe?.serving)) serving"
            cell.timeLabel.text = "\(String(describing: recipe?.cookingTime)) mins"
            
            return cell
            
        case 3:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "icons") as? iconItemTableViewCell)!
            cell.numLikeLabel.text = "\(recipe?.like ?? 0)"
            cell.delegate = self as iconItemTableViewCellDelegate
            
            return cell
        case 4:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creator") as? creatorCellRecpipeTableViewCell)!
            
            cell.delegate = self
            //            cell.imgCreator.setImage(creator.image, for: .normal)
            if userProfile == true{
                cell.followBtn.isHidden = true
            }else{
                cell.followBtn.isHidden = false
            }
            cell.delegate = self
            //            cell.imgCreator.setImage(creator.image, for: .normal)
            cell.labelCreator.setTitle(creator?.name, for: .normal)
            cell.userID = recipe?.userID
            
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
            if instructionList.count == instructionImgs.count && instructionList.count > 0{
                cell.stepNum.text = "\(String(indexPath.row + 1)):"
                cell.howToCookLabel.text = instructionList[indexPath.row].text
                cell.instructionImg.image = instructionImgs[indexPath.row]
            }
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
        case 6:
            return 350
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RecipeDetailViewController: ReloadDataDelegate{
    func reloadData(data: [RecipeDetail]) {
        
    }
    func reloadImg(img:[UIImage]){
        instructionImgs = img
        detailTableView.reloadData()
    }
}

// this extension tell firebase to increase this recipe's like

extension RecipeDetailViewController: iconItemTableViewCellDelegate{
    func increaseLike() {
        recipe?.like += 1
        self.dataManager1.increaseLike(recipe: recipe!)
        detailTableView.reloadData()
    }
}

// this extension tell firebase to increase this user's follower.

extension RecipeDetailViewController: AddingFollowersDelegate{
    func increaseFollower(followerID: String) {
        self.dataManager1.increaseFollower(followerID: followerID)
        detailTableView.reloadData()
    }
 }

extension RecipeDetailViewController: RecipeDetailDelegate {
    func getCreator(creator: User) {
        self.creator = creator
    }

}
