//
//  FollowingUserTableViewCell.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-03-14.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit

class FollowingUserTableViewCell: UITableViewCell {
    
    var user: User? {
        didSet {
            
            // now i dont have image for user.
            //            userImage.image = user.image
            label.text = user?.name
            
            
            
        }
    }
    
    var label: UILabel {
        let temp = UILabel(frame: CGRect(x: 450.0, y: 0, width: 150.0, height: UITableView.automaticDimension))
        temp.textColor = .black
        temp.textAlignment = .right
        
        //        let horizontalConstraint = temp.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        //        let verticalConstraint = temp.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        //
        //        self.contentView.addConstraints([horizontalConstraint, verticalConstraint])
        //
        return temp
    }
    
    var userImage: UIImageView {
        
        let imgView = UIImageView(frame: CGRect(x: 20.0, y: 10.0, width: 30.0 , height: 30.0))
        
        imgView.image = #imageLiteral(resourceName: "download1")
        imgView.contentMode = .scaleAspectFit
        
        
        //        let imgViewHorizontalConstraint = self.userImage.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        //        let imgViewVerticalConstraint = self.userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        //
        //        let imgViewWidthConstraint = NSLayoutConstraint(item: self.userImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10)
        //        let imgViewHeightConstraint = NSLayoutConstraint(item: self.userImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 10)
        //
        //        self.contentView.addConstraints([imgViewHorizontalConstraint, imgViewVerticalConstraint, imgViewWidthConstraint, imgViewHeightConstraint])
        
        return imgView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(userImage)
        //        let leadingConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: userImage, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 30.0)
        
        
       
        
        //        let imgeViewlandingConstraint = NSLayoutConstraint(item: userImage, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: label, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 0, constant: 10)
        
        //        imgViewWidthConstraint.isActive = true
        //        imgViewHeightConstraint.isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //            let widthConstraint = label.widthAnchor.constraint(equalToConstant: 100)
        //            let heightConstraint = label.widthAnchor.constraint(equalToConstant: UITableView.automaticDimension)
        
        
        
        
        //            let imgViewWidthConstraint = userImage.widthAnchor.constraint(equalToConstant: 10)
        //            let imgViewHeightConstraint = userImage.heightAnchor.constraint(equalToConstant: 10)
        
        
        //        self.userImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    
    
}
