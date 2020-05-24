//
//  CollectionViewInsideUserTableView.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-03-19.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation

protocol CollectionViewInsideProfileTableViewDelegate: class {
    func cellTaped(data:IndexPath)
    func beginDragging()
}
