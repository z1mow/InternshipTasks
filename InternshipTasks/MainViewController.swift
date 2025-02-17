//
//  MainViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 13.02.2025.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appNames: [String] = ["Pharmacy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
       
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
            let pharmacyVC = storyboard.instantiateViewController(withIdentifier: "PharmacyViewController")
            pharmacyVC.modalPresentationStyle = .fullScreen
            self.present(pharmacyVC, animated: true, completion: nil)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

