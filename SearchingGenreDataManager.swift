//
//  SearchingGenreDelegate.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-20.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol SearchingGenreDataManagerDelegate: class {
    func gotGenres(getGenres: [String])
}

class SearchingGenreDataManager {
    
    let db = Firestore.firestore()
    weak var delegate: SearchingGenreDataManagerDelegate?
     
    func getGenres() {
       
           var arr:[String] = []
        db.collection("genres").document("genre").addSnapshotListener() {
                          (querySnapshot, error) in
                          if error != nil {
                              print("Error getting documents: \(String(describing: error))")
                          } else {
                          
                           let data = querySnapshot!.data()
                            
                            let arrOfData = data!["genres"] as? [String:Bool]
                            for element in arrOfData! {
                               arr.append(element.key)
                           }
                           self.delegate?.gotGenres(getGenres: arr)
                   }
               }
           
       }
    
    func createQuery(searchingWord word: String) -> Query {
            let query = db.collection("recipe").whereField("genres.\(word)", isGreaterThanOrEqualTo: word)
           return query
       }
       
}
