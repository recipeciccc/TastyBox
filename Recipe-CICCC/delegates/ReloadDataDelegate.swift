//
//  ReloadDataDelegate.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-03-07.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
import UIKit

protocol ReloadDataDelegate: class {
    func reloadData(data:[RecipeDetail])
    func reloadImg(img:[UIImage])
}
