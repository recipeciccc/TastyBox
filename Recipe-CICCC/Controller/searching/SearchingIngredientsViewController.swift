//
//  SearchingIngredientsViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//
import UIKit
import Crashlytics

class SearchingIngredientsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ingredientArray: [String] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }

        }
    }
    
    var searchingWord = ""
    
    var searchedRecipes:[RecipeDetail] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        
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
        vc.searchingCategory = "ingredient"
        
        tableView.deselectRow(at: indexPath, animated: true)

        navigationController?.pushViewController(vc, animated: true)
    }
}
