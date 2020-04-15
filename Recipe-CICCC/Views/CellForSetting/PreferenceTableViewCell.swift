//
//  AllergiesTableViewCell.swift
//  Recipe-CICCC
//
//  Created by fangyilai on 2020-04-01.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class PreferenceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pickerTextfield: UITextField!
    var row : Int?
    
    override func awakeFromNib() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ClickTextField(_ sender: Any) {
        let tb = self.superview as? UITableView
        row = tb?.indexPath(for: self)?.row
        print("row is \(String(describing: row))")
    }
}


