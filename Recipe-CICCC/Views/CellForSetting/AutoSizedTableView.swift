//
//  PreferenceTableView.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-27.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import Foundation
class AutoSizedTableView: UITableView{
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
     
     override func reloadData() {
       super.reloadData()
       self.invalidateIntrinsicContentSize()
       self.layoutIfNeeded()
     }
     
     override var intrinsicContentSize: CGSize {
       let height = min(contentSize.height, maxHeight)
       return CGSize(width: contentSize.width, height: height)
     }
}
