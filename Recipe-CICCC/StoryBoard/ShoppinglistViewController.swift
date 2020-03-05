//
//  ShoppinglistViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-19.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class ShoppinglistViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchActive : Bool = false
    var shoppingList = ShoppingList()
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self as UITableViewDelegate
        tableView.dataSource = self as UITableViewDataSource
        
        searchBar.delegate = self as? UISearchBarDelegate
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

extension ShoppinglistViewController: UITableViewDelegate {
    
}

extension ShoppinglistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "searchStores") as? searchButtonTableViewCell)!
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "IngredientsInShoppingList") as? IngredietntShoppingListTableViewCell)!
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

}

extension ShoppinglistViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

