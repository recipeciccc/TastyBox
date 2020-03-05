//
//  AppUser.swift
//  Recipe-CICCC
//
//  Created by Argus Chen on 2020-02-27.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import Firebase

struct AppUser {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        self.uid = authData.uid
        self.email = authData.email!
    }
}
