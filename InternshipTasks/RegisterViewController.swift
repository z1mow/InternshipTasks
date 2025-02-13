//
//  RegisterViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 13.02.2025.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboardOnTap()
        emailAddressTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailAddressTextField.tag = 1
        usernameTextField.tag = 2
        passwordTextField.tag = 3
        confirmPasswordTextField.tag = 4
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty,
//              let username = usernameTextField.text,
              let password = passwordTextField.text, !password.isEmpty,
              password == confirmPasswordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { [ weak self ] result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
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

extension RegisterViewController: UITextFieldDelegate {
    
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
