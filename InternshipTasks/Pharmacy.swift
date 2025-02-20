//
//  Pharmacy.swift
//  InternshipTasks
//
//  Created by Şakir Yılmaz ÖĞÜT on 17.02.2025.
//

import Foundation

struct Pharmacy: Codable {
    let name: String
    let address: String
    let phone: String
    let loc: String
    let dist: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case address = "address"
        case phone = "phone"
        case loc = "loc"
        case dist = "dist"
    }
}

struct PharmacyResponse: Codable {
    let success: Bool
    let result: [Pharmacy]
}
