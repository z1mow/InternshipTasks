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
