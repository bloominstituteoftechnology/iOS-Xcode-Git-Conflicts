//
//  LogInViewController.swift
//  PasswordScreenAutoLayout
//
//  Created by Paul Solt on 3/1/19.
//  Copyright © 2019 BloomTech. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    var expectedPassword = "password"
    var didValidatePassword: Bool = false
    var willShowKeyboard = false
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var fieldStackView: UIStackView!
    @IBOutlet weak var popupBackgroundView: UIView!

    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        view.backgroundColor = .systemRed
        hideError(animate: false)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        loginIfValidFormInput()
    }
    
    private func login(email: String, password: String) {
        print("login() email: \(email), password: \(password)")
        if email.isEmpty {
            // TODO: Verify email is of correct format (hello@example.com)
            showError(message: "Error: Email cannot be empty.",
                      forView: emailTextField,
                      animate: true)
            emailTextField.becomeFirstResponder()
        } else if password.isEmpty {
            showError(message: "Error: Password cannot be empty.",
                      forView: passwordTextField,
                      animate: true)
            
            passwordTextField.becomeFirstResponder()
        } else if password != expectedPassword {
            showError(message: "Error: Email and password do not match. Try again.",
                      forView: passwordTextField,
                      animate: true)
            passwordTextField.becomeFirstResponder()
        } else if password == expectedPassword { // good password
            self.hideError(animate: true)
            
            // Fake a web request delay before going to next screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Login successful!")
                self.didValidatePassword = true
                self.view.endEditing(true)
            }
        } else {
            // FIXME: what should we do if we get here?
        }
    }
    
    private func loginIfValidFormInput() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        login(email: email, password: password)
    }
    
    private func showError(message: String, forView activeView: UIView, animate: Bool) {
        errorLabel.text = message
        if animate {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [.beginFromCurrentState], animations: {
                self.errorLabel.isHidden = false
            })
            activeView.shake()
        } else {
            self.errorLabel.isHidden = false
        }
    }
    
    private func hideError(animate: Bool) {
        errorLabel.text = ""
        if animate {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: [.beginFromCurrentState], animations: {
                self.errorLabel.isHidden = true
            })
        } else {
            self.errorLabel.isHidden = true
        }
    }
    
    // MARK: -  Keyboard notifications
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        didValidatePassword = false
        
        // Scroll view won't scroll if view is visible
        scrollView.scrollRectToVisible(passwordTextField.frame, animated: true)
        
        let halfKeyboardHeight = -endFrame.size.height / 2
        let keyboardInset = UIEdgeInsets(top: halfKeyboardHeight, left: 0, bottom: -halfKeyboardHeight, right: 0)
        scrollView.contentInset = keyboardInset
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: NSNotification) {
        if let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if view.frame.height == endFrame.origin.y {
                // keyboard is offscreen
                view.frame.origin.y = 0
            } else {
                view.frame.origin.y = -endFrame.size.height / 2.0
            }
        }
    }
}

// MARK: UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    
    // Allows us to trigger an action when return is pressed, or move to
    // the next field in a form
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            advanceToPasswordTextField()
        } else if textField == passwordTextField {
            loginIfValidFormInput()
        }
        return didValidatePassword
    }
    
    private func advanceToPasswordTextField() {
        passwordTextField.becomeFirstResponder()
    }
}
