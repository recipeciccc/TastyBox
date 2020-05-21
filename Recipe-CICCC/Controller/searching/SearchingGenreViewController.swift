//
//  SearchingGenreViewController.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//
import UIKit
import Crashlytics

class SearchingGenreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchingWord = ""
    var genresArray:[String] = []
    
    let dataManager = SearchingGenreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        dataManager.isGenreExistDelegate = self
        //        dataManager.getGenres()
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

extension SearchingGenreViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "searcingGenre") as? SearchingGenresTableViewCell)!
        
        cell.genresLabel.text = genresArray[indexPath.row]
        
        return cell
    }
    
    
}

extension SearchingGenreViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(identifier: "resultRecipes") as! ResultRecipesViewController
        
        vc.searchingCategory = "genres"
        vc.searchingWord = genresArray[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchingGenreViewController :isGenreExistDelegate {
    func gotGenres(getGenres: [String]) {
        genresArray = getGenres
        self.tableView.reloadData()
    }
    
}
