//
//  ShopWithCashbackModel.swift
//  Iceback
//
//  Created by Admin on 23/01/24.
//

import Foundation

//MARK: - ShopWithCashbackData
class ShopWithCashbackData {
    
    var id: Int
    var name: String
    var logo: String?
    var expiryDate: String
    var code: String
    var cashbackPercentage, maxCashbackPercentage, minCashbackAmount, maxCashbackAmount: Double
    var regionLogo: [String]
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        logo = jsonData["logo"] as? String ?? ""
        code = jsonData["code"] as? String ?? ""
        expiryDate = jsonData["expiry_date"] as? String ?? ""
        cashbackPercentage = jsonData["cashback_percentage"] as? Double ?? 0.0
        maxCashbackPercentage = jsonData["max_cashback_percentage"] as? Double ?? 0.0
        minCashbackAmount = jsonData["min_cashback_amount"] as? Double ?? 0.0
        maxCashbackAmount = jsonData["max_cashback_amount"] as? Double ?? 0.0
        regionLogo = jsonData["region_logo"] as? [String] ?? []
    }
}
