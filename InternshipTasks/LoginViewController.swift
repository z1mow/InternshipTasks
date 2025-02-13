//
//  LoginViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 13.02.2025.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboardOnTap()
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        emailAddressTextField.tag = 1
        passwordTextField.tag = 2
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty,  let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        
        Auth.auth().signIn(withEmail: emailAddress, password: password) { [ weak self ] result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            
            self?.navigateToMain()
        }
    }

    private func navigateToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            mainVC.modalPresentationStyle = .fullScreen
            
            present(mainVC, animated: true) {
                self.view.window?.rootViewController = mainVC
            }
        }
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func initializeHideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
