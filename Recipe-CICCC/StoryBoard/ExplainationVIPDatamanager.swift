//
//  File.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-04-24.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

protocol ExplainationVIPDatamanagerDelegate: class {
    func registerVIP()
}

class ExplainationVIPDatamanager {
    
    weak var delegate: ExplainationVIPDatamanagerDelegate?
    let uid = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    
    func registerVIP(expiredDate: Date) {

        db.collection("user").document(uid!).setData([
        
            "isVIP": true,
            "registrationDate": Timestamp(),
            "expiredDate": expiredDate
            
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
