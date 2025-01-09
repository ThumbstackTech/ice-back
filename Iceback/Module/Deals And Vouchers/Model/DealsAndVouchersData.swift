//
//  DealsAndVouchersData.swift
//  Iceback
//
//  Created by Admin on 25/01/24.
//

import Foundation
class DealsAndVouchersData {
    var id: Int
    var name: String
    var storeId: Int
    var categoryId: Int?
    var type: String?
    var value: Int
    var code: String
    var numTimesUsed, usageLimit: Int
    var startDate: String
    var expiryDate: String
    var image: String?
    var awinId: Int
    var deeplinkTracking, deeplink, redirectUrl: String
    var store: StoreData?
//    var categories: [Any?]
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        storeId = jsonData["store_id"] as? Int ?? 0
        categoryId = jsonData["category_id"] as? Int ?? 0
        type = jsonData["type"] as? String ?? ""
        value = jsonData["value"] as? Int ?? 0
        code = jsonData["code"] as? String ?? ""
        numTimesUsed = jsonData["num_times_used"] as? Int ?? 0
        usageLimit = jsonData["usage_limit"] as? Int ?? 0
        startDate = jsonData["start_date"] as? String ?? ""
        expiryDate = jsonData["expiry_date"] as? String ?? ""
        image = jsonData["image"] as? String ?? ""
        awinId = jsonData["awin_id"] as? Int ?? 0
        deeplinkTracking = jsonData["deeplink_tracking"] as? String ?? ""
        deeplink = jsonData["deeplink"] as? String ?? ""
        redirectUrl = jsonData["redirectUrl"] as? String ?? ""
        
        if let storeData = jsonData["store"] as? [String: Any] {
            let obj = StoreData(jsonData: storeData)
            store = obj
        }
    }
}

// MARK: - Store Data
class StoreData {
    var id: Int
    var name: String?
    var logo: String
    var storePopularity: String?
    var maxCashbackPercentage: Double
    var redirectUrl: String
    var isSelected = false

    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        logo = jsonData["logo"] as? String ?? ""
        storePopularity = jsonData["store_popularity"] as? String ?? ""
        maxCashbackPercentage = jsonData["max_cashback_percentage"] as? Double ?? 0
        redirectUrl = jsonData["redirectUrl"] as? String ?? ""
    }
}
