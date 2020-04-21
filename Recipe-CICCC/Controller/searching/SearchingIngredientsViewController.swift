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
    
    var ingredientArray: [String] = []
    var searchingWord = ""
    var searchedRecipes:[RecipeDetail] = []
    
    let dataManager = SearchingIngredientsDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        dataManager.delegate = self
        dataManager.delegateChild = self
        
        dataManager.getAllRecipes()
        dataManager.getIngredients()
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

extension SearchingIngredientsViewController: fetchRecipesDelegate {
    func reloadData(data: [RecipeDetail]) {
        
        for recipe in data {
            dataManager.getAllIngredients(recipe: recipe, searchingWord: searchingWord)
        }
    }
}

extension SearchingIngredientsViewController: SearchingIngredientsDelegate {
    func gotIngredients(ingredients: [String]) {
        ingredientArray = ingredients
        tableView.reloadData()
    }
    
    func reloadIngredients(recipe: RecipeDetail) {
        searchedRecipes.append(recipe)
        
    }
    
}

