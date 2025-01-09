//
//  DonationData.swift
//  Iceback
//
//  Created by Admin on 29/01/24.
//

import Foundation

//MARK: - DonationData
class DonationData {
    var projectId: Int
    var amount: Double
    var slug: String
    
    init(jsonData: [String: Any]) {
        projectId = jsonData["project_id"] as? Int ?? 0
        amount = jsonData["amount"] as? Double ?? 0.0
        slug = jsonData["slug"] as? String ?? ""
    }
}
