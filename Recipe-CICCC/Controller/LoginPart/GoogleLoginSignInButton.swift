//
//  GoogleLoginSignInButton.swift
//  Recipe-CICCC
//
//  Created by 北島　志帆美 on 2020-05-13.
//  Copyright © 2020 Argus Chen. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleLoginSignInButton: GIDSignInButton {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        
        print("sdfahdsaigh;")
        guard let superViewCenterYAnchor = self.superview?.centerYAnchor else { return }
        guard let superViewLeadingAnchor = self.superview?.leadingAnchor else { return }
        guard let superViewTtrailingAnchor = self.superview?.trailingAnchor else { return }
        
        let centerYAnchor = self.centerYAnchor.constraint(equalToSystemSpacingBelow: superViewCenterYAnchor, multiplier: 0.0)
        let leadingAnchor = self.leadingAnchor.constraint(greaterThanOrEqualTo: superViewLeadingAnchor)
        let trailingAnchor = self.leadingAnchor.constraint(greaterThanOrEqualTo: superViewTtrailingAnchor)
        
        self.addConstraint(centerYAnchor)
        self.addConstraint(leadingAnchor)
        self.addConstraint(trailingAnchor)
    }

}
