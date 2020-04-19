//
//  iconItemTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

protocol iconItemTableViewCellDelegate: class{
    func increaseLike()
}

class iconItemTableViewCell: UITableViewCell {

    @IBOutlet weak var numLikeLabel: UILabel!
    
    weak var delegate: iconItemTableViewCellDelegate?
    
    @IBAction func increaseLike(_ sender: UIButton) {
        self.delegate?.increaseLike()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = #colorLiteral(red: 0.9959775805, green: 0.9961397052, blue: 0.7093081474, alpha: 1)
        numLikeLabel.textColor = #colorLiteral(red: 0.6666666667, green: 0.4745098039, blue: 0.2588235294, alpha: 1)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
               // Configure the view for the selected state
    }

}
