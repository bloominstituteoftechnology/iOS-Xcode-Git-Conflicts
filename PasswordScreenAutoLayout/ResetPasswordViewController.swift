//
//  ResetPasswordViewController.swift
//  PasswordScreenAutoLayout
//
//  Created by Paul Solt on 4/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var emailTextField: CustomTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: Any) {
        // TODO: Implement reset API call
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        
        // TODO: Jump back to previous view controller
    }
}
