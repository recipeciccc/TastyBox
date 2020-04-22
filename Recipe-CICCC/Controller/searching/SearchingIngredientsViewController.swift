//
//  SearchingIngredientsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class SearchingIngredientsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ingredientArray: [String] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
//            dataManager.getAllRecipes(searchingWord: searchingWord)
        }
    }
    
    var searchingWord = ""
    
    var searchedRecipes:[RecipeDetail] = []
    
    
//    let dataManager = SearchingIngredientsDataManager()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
//        dataManager.delegate = self
        
//        dataManager.getAllRecipes(searchingWord: searchingWord)
       
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

extension SearchingIngredientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "searchingIngredient") as? SearchingIngredientsTableViewCell)!
        
        cell.ingredientLabel.text = ingredientArray[indexPath.row]
        
        return cell
    }
    
}

extension SearchingIngredientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "resultRecipes") as! ResultRecipesViewController
        let cell = tableView.cellForRow(at: indexPath) as! SearchingIngredientsTableViewCell
       
        vc.searchingWord = cell.ingredientLabel.text
        
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
}


