//
//  iconItemTableViewCell.swift
//  RecipeTest
//
//  Created by 北島　志帆美 on 2019-11-28.
//  Copyright © 2019 北島　志帆美. All rights reserved.
//

import UIKit

protocol RecipeLikesManageDelegate: class{
    func increaseLike()
    func decreaseLike()
}

class iconItemTableViewCell: UITableViewCell {

    @IBOutlet weak var numLikeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: RecipeLikesManageDelegate?
    
    var isLiked: Bool? {
        
        didSet {
            if isLiked != true {
                likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            }
            
        }
    }
    
    @IBAction func increaseLike(_ sender: UIButton) {
       
        
        if sender.currentImage == UIImage(systemName: "suit.heart.fill") {
             sender.setImage(UIImage(systemName: "suit.heart"), for: .normal)
             self.delegate?.decreaseLike()
        } else {
             sender.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
             self.delegate?.increaseLike()
        }
       
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
