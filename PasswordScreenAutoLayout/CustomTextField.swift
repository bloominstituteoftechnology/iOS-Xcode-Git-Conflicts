//
//  CustomTextField.swift
//  PasswordScreenAutoLayout
//
//  Created by Paul Solt on 3/2/19.
//  Copyright © 2019 BloomTech. All rights reserved.
//

import UIKit


class CustomTextField: UITextField {
    
    // These insets move the cursor position inside a custom UITextField so it's
    // not on the leading edge
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 10)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 44)
    }
}
