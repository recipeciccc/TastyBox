//
//  KeyManager.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-02-03.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

struct KeyManager {

    private let keyFilePath = Bundle.main.path(forResource: "apiKey", ofType: "plist")

    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }

    func getValue(key: String) -> AnyObject? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]! as AnyObject
    }
}
