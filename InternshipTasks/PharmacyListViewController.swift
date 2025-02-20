//
//  PharmacyListViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 17.02.2025.
//

import UIKit

class PharmacyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCity: String?
    var selectedDistrict: String?
    private var pharmacies: [Pharmacy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchPharmacies()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    private func emptyPharmacyListAlert() {
        if pharmacies.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "There is no pharmacy on duty in \(selectedDistrict ?? "this area")."
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .systemGray
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
    }
    
    private func fetchPharmacies() {
        guard let city = selectedCity else { return }
        
        let urlString = "https://api.collectapi.com/health/dutyPharmacy?ilce=\(selectedDistrict ?? "")&il=\(city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue("apikey 6IHswvmmNV8wMvvBFn8dK1:6blzUWLi5Xy49y5aC8USSi", forHTTPHeaderField: "authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PharmacyResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self?.pharmacies = response.result
                    self?.tableView.reloadData()
                    self?.emptyPharmacyListAlert()
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pharmacies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PharmacyCell", for: indexPath)
        let pharmacy = pharmacies[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = pharmacy.name
        content.secondaryText = "\(pharmacy.address)\n\(pharmacy.phone)"
        content.secondaryTextProperties.numberOfLines = 0
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
