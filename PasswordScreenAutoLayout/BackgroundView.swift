//
//  BackgroundView.swift
//  PasswordScreenAutoLayout
//
//  Created by Paul Solt on 3/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadow(on: self)
    }
    
    func updateShadow(on background: UIView) {
        let layer = background.layer
        layer.shadowPath = UIBezierPath(rect: background.bounds).cgPath
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.22
    }
}
