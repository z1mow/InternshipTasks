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

        // Do any additional setup after loading the view.
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
