//
//  MainViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 13.02.2025.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appNames: [String] = ["Pharmacies On Duty",
                              "Youtube"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        try! Auth.auth().signOut()
        print("User signed out")
        if let storyboard = self.storyboard {
            let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController")
            authVC.modalPresentationStyle = .fullScreen
            self.present(authVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
        cell.textLabel?.text = appNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
        switch indexPath.row {
        case 0:
            let cityVC = storyboard.instantiateViewController(withIdentifier: "CitySelectionViewController")
            cityVC.modalPresentationStyle = .fullScreen
            self.present(cityVC, animated: true)
        case 1:
            let youtubeVC = storyboard.instantiateViewController(withIdentifier: "YouTubeViewController")
            youtubeVC.modalPresentationStyle = .fullScreen
            self.present(youtubeVC, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

