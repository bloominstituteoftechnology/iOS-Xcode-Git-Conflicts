//
//  LogInViewController.swift
//  PasswordScreenAutoLayout
//
//  Created by Paul Solt on 3/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    var expectedPassword = "magic"
    var didValidatePassword: Bool = false
    var willShowKeyboard = false
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var popupBackground: UIView!
    @IBOutlet weak var fieldStackView: UIStackView!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        hideError(animate: false)
    }

    
    @IBAction func loginPressed(_ sender: Any) {
        loginIfValidFormInput()
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController")
        present(resetPasswordVC, animated: true)
    }
    
    func login(email: String, password: String) {
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
        } else { // good password
            self.hideError(animate: true)

            // Fake a web request delay before going to next screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Login successful!")
                self.didValidatePassword = true
                self.view.endEditing(true)
            }
        }
    }

    private func loginIfValidFormInput() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        login(email: email, password: password)
    }

    func showError(message: String, forView activeView: UIView, animate: Bool) {
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
    
    func hideError(animate: Bool) {
        errorLabel.text = ""
        if animate {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: [.beginFromCurrentState], animations: {
                self.errorLabel.isHidden = true
            })
        } else {
            self.errorLabel.isHidden = true
        }
    }
    
    // MARK: -  Keyboard notificaitons
        
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
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
    
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        if view.frame.height == endFrame.origin.y {
            // keyboard is offscreen
            view.frame.origin.y = 0
        } else {
            view.frame.origin.y = -endFrame.size.height / 2.0
        }
    }
}
