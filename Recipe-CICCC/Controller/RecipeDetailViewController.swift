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
import MessageUI
import Crashlytics

class RecipeDetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailTableView: UITableView!
    var getImg = FetchRecipeImage()
    var mainPhoto = UIImage()
    var userProfile = Bool()
    var recipe: RecipeDetail?
    var creator: User?
    var creatorImage: UIImage?
    
    var ingredientList  = [Ingredient]()
    var instructionList = [Instruction]()
    var instructionImages: [Int: UIImage] = [:]
    var genres = [String]()
    
    //    var comment = [Comment]()
    
    let dataManager1 = RecipeDetailDataManager()
    let userDataManager = UserdataManager()
    
    var instructionImgs = [UIImage]()
    let uid = Auth.auth().currentUser?.uid
    var isliked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        
        detailTableView.tableFooterView = UIView()
        detailTableView.separatorStyle = .none
        detailTableView.isHidden = true
        
        userDataManager.delegate = self
        userDataManager.recipeDetailDelegate = self
        dataManager1.delegate = self
        
        view.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        
        if recipe!.isVIPRecipe! && recipe?.userID != uid {
            userDataManager.checkVIP()
        } else {
            askRecipeDetails()
        }
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if recipe!.isVIPRecipe! && recipe?.userID != uid {
            userDataManager.checkVIP()
        }
    }
    
    
    fileprivate func askRecipeDetails() {
        
         let dbRef = Firestore.firestore().collection("recipe").document(recipe?.recipeID ?? "")
         let query_ingredient = dbRef.collection("ingredient").order(by: "ingredient", descending: false)
         let query_instruction = dbRef.collection("instruction").order(by: "index", descending: false)
         
         getIngredientData(query: query_ingredient)
         getInstructionData(query: query_instruction)
         
         userDataManager.getUserDetail(id: recipe?.userID)
         userDataManager.getUserImage(uid: recipe!.userID)
        dataManager1.isFollowingCreator(userID: recipe!.userID)
        
         dataManager1.isLikedRecipe(recipeID: recipe!.recipeID)
        dataManager1.getGenres(tableView: self.detailTableView, recipe: recipe!)

     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savingRecipe" {
            if let vc = segue.destination as? SavedRecipeViewController {
                vc.isSavingRecipe = true
                vc.savingRecipeID = recipe?.recipeID
            }
        }
        
        if segue.identifier == "commentSegue" {
            if let vc = segue.destination as? CommentsViewController {
                vc.recipe = recipe
            }
        }
    }
    
    @IBAction func report(_ sender: Any) {
        reportAlert()
    }
    
    private func reportAlert(){
        let alertController = UIAlertController(title: "Report Issue", message: "Do you think this recipe includes objectionable content? ", preferredStyle: .alert)
        
        let agreeAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        let disagreeAction = UIAlertAction(title: "Agree", style: .default, handler: { action in
            self.emailComposer()
        })
        alertController.addAction(agreeAction)
        alertController.addAction(disagreeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func emailComposer(){
        if MFMailComposeViewController.canSendMail() == true {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["recipeciccc@gmail.com"])
            
            let rid = String(recipe?.recipeID ?? "")
            composer.setSubject("Report recipe - ID:\(rid)")
            composer.setMessageBody("What kinds of objectionable content are included in this recipe? (sexual/ violent/ harmful/ spam/ infringes rights)\n\n\nPlease write down your concerns, we will review it to determine whether it violate community guidlines. By TastyBox Team", isHTML: false)
            present(composer,animated:true)
        }else{
            return
        }
        
    }
    
    @IBAction func goToUserProfile(_ sender: Any) {
        
        if creator?.name == Auth.auth().currentUser?.displayName {
            let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
            let profileVC = storyboard.instantiateViewController(identifier: "User profile") as! MyPageViewController
            
            guard self.navigationController?.topViewController == self else { return }
            
            navigationController?.pushViewController(profileVC, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "creatorProfile", bundle: nil)
            let profileVC = storyboard.instantiateViewController(identifier: "creatorProfile") as! CreatorProfileViewController
            
            profileVC.id = self.creator!.userID
            
            guard self.navigationController?.topViewController == self else { return }
            
            navigationController?.pushViewController(profileVC, animated: true)
        }
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
                        
                        guard let userID = self.recipe?.userID else { return }
                        guard let recipeID = self.recipe?.recipeID else { return }
                        self.dataManager1.getInstructionImg(uid: userID,rid: recipeID, count: self.instructionList.count)
                    }
                }
            }
        }
        
    }
}

extension RecipeDetailViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 6:
            return ingredientList.count
        case 7:
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
            cell.servingLabel.text = "\(String(describing: recipe?.serving ?? 0)) serving"
            cell.timeLabel.text = "\(String(describing: recipe?.cookingTime ?? 0)) mins"
            
            return cell
            
        case 3:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "icons") as? iconItemTableViewCell)!
            cell.numLikeLabel.text = "\(recipe?.like ?? 0)"
            cell.delegate = self as RecipeLikesManageDelegate
            
            cell.isLiked = self.isliked
            
            
            return cell
            
        case 4:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "recipeGenres") as? recipeGenresTableViewCell)!
            
//            cell.genresCollectionView.dataSource = self
            cell.configure(with: self.genres)
            cell.delegate = self
            
            return cell
        case 5:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "creator") as? creatorCellRecpipeTableViewCell)!
            
            
            cell.delegate = self
            
            if creator?.userID == uid {
                cell.followBtn.isHidden = true
            } else {
                cell.followBtn.isHidden = false
            }
            
            if userProfile == true{
                let creatorName = Auth.auth().currentUser?.displayName
                cell.creatorNameButton.setTitle(creatorName!, for: .normal)
                cell.imgCreator.setBackgroundImage(creatorImage, for: .normal)
            }else{
                cell.creatorNameButton.setTitle(creator?.name, for: .normal)
                cell.imgCreator.setBackgroundImage(creatorImage, for: .normal)
            }
            
            cell.userID = recipe?.userID
            
            return cell
        case 6:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "ingredientRecipe") as? IngredientsTableViewCell)!
            
            if ingredientList.count > 0{
                
                cell.nameIngredientsLabel.text = ingredientList[indexPath.row].name
                cell.amountIngredientsLabel.text = ingredientList[indexPath.row].amount
            }
            
            return cell
            
        case 7:
            let cell = (tableView.dequeueReusableCell(withIdentifier: "instructionsRecipe") as? HowToCookTableViewCell)!
            if instructionList.count == instructionImages.count && instructionList.count > 0{
                cell.stepNum.text = "\(String(indexPath.row + 1)):"
                cell.howToCookLabel.text = instructionList[indexPath.row].text
                
                cell.instructionImg.image = instructionImages[indexPath.row]
                
            }
            return cell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
}

// this extension tell firebase to increase this recipe's like

extension RecipeDetailViewController: RecipeLikesManageDelegate{
    
    func decreaseLike() {
        recipe?.like -= 1
        dataManager1.manageNumOfLikes(recipe: recipe!, isIncreased: false)
        
        dataManager1.isLikedRecipe(recipeID: recipe!.recipeID)
        
    }
    
    func increaseLike() {
        recipe?.like += 1
        dataManager1.manageNumOfLikes(recipe: recipe!, isIncreased: true)
        dataManager1.isLikedRecipe(recipeID: recipe!.recipeID)
    }
}

// this extension tell firebase to manage this user's follower.

extension RecipeDetailViewController: ManageFollowersDelegate{
    func decreaseFollower(followerID: String) {
        self.dataManager1.manageFollowing(followerID: followerID, isfollow: false)
    }
    
    func increaseFollower(followerID: String) {
        self.dataManager1.manageFollowing(followerID: followerID, isfollow: true)
    }
}

extension RecipeDetailViewController: RecipeDetailDelegate {
    
    func gotInstructionImages(images: [Int : UIImage]) {
        self.instructionImages = images
        
        UIView.transition(with: detailTableView, duration: 0.7, options: [UIView.AnimationOptions.transitionCrossDissolve], animations: { [weak self] in
            
            self?.detailTableView.reloadData()
            self?.detailTableView.isHidden = false
            
            }, completion: nil)
        
    }
    
    func isFollowingCreator(isFollowing: Bool) {
        guard let cell = self.detailTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? creatorCellRecpipeTableViewCell else { return }
        cell.followingButtonUIManagement(isFollowing: isFollowing)
    }
    
    func UnfollowedAction() {
        guard let cell = self.detailTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? creatorCellRecpipeTableViewCell else { return }
        
        cell.followingButtonUIManagement(isFollowing: false)
    }
    
    func FollowedAction() {
        
        guard let cell = self.detailTableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? creatorCellRecpipeTableViewCell else { return }
        
        cell.followingButtonUIManagement(isFollowing: true)
    }
    
    func gotGenres(genres: [String]) {
        self.genres = genres
    }
    
    func isLikedRecipe(isLiked: Bool) {
        self.isliked = isLiked
        
        guard detailTableView.cellForRow(at: IndexPath(row: 0, section: 3)) != nil else { return }
        
        self.detailTableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
    }
    
    func getCreator(creator: User) {
        self.creator = creator
    }
    
    fileprivate func showsRegisterVIPOptions() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.backgroundColor = #colorLiteral(red: 0.9977325797, green: 0.9879661202, blue: 0.7689270973, alpha: 1)
        view.tag = 100
        self.view.addSubview(view)
        
        let alertController = UIAlertController(title: "Register VIP member", message: "This recipe is VIP only. You need to be VIP member.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        let registerAction = UIAlertAction(title: "Sign up VIP membership", style: .default, handler: { action in
            let registerVC = UIStoryboard(name: "VIP_page", bundle: nil).instantiateViewController(identifier: "registerVIP") as! ExplainationVIPViewController
            
            guard self.navigationController?.topViewController == self else { return }
            
            self.navigationController?.pushViewController(registerVC, animated: true)
        })
        
        alertController.addAction(registerAction)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func isVIP(isVIP: Bool) {
        if isVIP {
            
            askRecipeDetails()
            
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            } else{
                print("No!")
            }
            
        } else {
            
            showsRegisterVIPOptions()
            
        }
    }
    
}

extension RecipeDetailViewController: getUserDataDelegate {
    
    func assignUserImage(image: UIImage) {
        self.creatorImage = image
        self.detailTableView.reloadData()
    }
    
    func gotUserData(user: User) {
        self.creator = user
    }
    
}

extension RecipeDetailViewController: PushSearchingGenres {
    func pushSearedResult(vc: ResultRecipesViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension RecipeDetailViewController: MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        @unknown default:
            print("default")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
