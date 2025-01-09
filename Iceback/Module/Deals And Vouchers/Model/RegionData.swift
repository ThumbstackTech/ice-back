//
//  RegionData.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation
// MARK: - RegionData
class RegionData {
    var id: Int
    var name: Name?
    var isAvailable = false
    var createdAt, updatedAt: String
    var regionLogo: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        createdAt = jsonData["created_at"] as? String ?? ""
        if let nameData = jsonData["name"] as? [String: Any] {
            let obj = Name(jsonData: nameData)
            name = obj
        }
        updatedAt = jsonData["updatedAt"] as? String ?? ""
        regionLogo = jsonData["region_logo"] as? String ?? ""
    }
}

// MARK: - Name
class Name {
    var en, de: String
    
    init(jsonData: [String: Any]) {
        en = jsonData["en"] as? String ?? ""
        de = jsonData["de"] as? String ?? ""
    }
}
