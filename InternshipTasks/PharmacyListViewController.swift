//
//  PharmacyListViewController.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 17.02.2025.
//

import UIKit
import MapKit

class PharmacyListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    
    private var isShowingMap = false
    
    var selectedCity: String?
    var selectedDistrict: String?
    private var pharmacies: [Pharmacy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
        fetchPharmacies()
        mapView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        isShowingMap.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.mapView.isHidden = !self.isShowingMap
            self.tableView.isHidden = self.isShowingMap
            
            let buttonImage = self.isShowingMap ? UIImage(systemName: "list.bullet") : UIImage(systemName: "map")
            self.mapButton.setImage(buttonImage, for: .normal)
        }
    }
    
    private func geocodeAddress(for pharmacy: Pharmacy, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        let fullAddress = "\(pharmacy.address), \(selectedCity ?? "")"
        
        geocoder.geocodeAddressString(fullAddress) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let location = placemarks?.first?.location?.coordinate else {
                completion(nil)
                return
            }
            
            completion(location)
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
                
                print("API Response:")
                print(String(data: data, encoding: .utf8) ?? "Invalid data")
                
                DispatchQueue.main.async {
                    self?.pharmacies = response.result
                    self?.tableView.reloadData()
                    self?.updateMapAnnotations()
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        let group = DispatchGroup()
        var annotations: [MKPointAnnotation] = []
        
        for pharmacy in pharmacies {
            group.enter()
            geocodeAddress(for: pharmacy) { coordinate in
                defer { group.leave() }
                
                guard let coordinate = coordinate else { return }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = pharmacy.name
                annotation.subtitle = pharmacy.address
                annotations.append(annotation)
            }
        }
        
        group.notify(queue: .main) {
            self.mapView.addAnnotations(annotations)
            
            if let firstAnnotation = annotations.first {
                let region = MKCoordinateRegion(
                    center: firstAnnotation.coordinate,
                    latitudinalMeters: 5000,
                    longitudinalMeters: 5000
                )
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "PharmacyPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = view.annotation?.coordinate else { return }
        
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = view.annotation?.title ?? "Eczane"
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
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
