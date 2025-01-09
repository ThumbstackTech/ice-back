//
//  SpecialAndVoucherData.swift
//  Iceback
//
//  Created by Admin on 23/01/24.
//

import Foundation

//MARK: - SpecialAndVoucherData
class SpecialAndVoucherData {
    
    var id: Int
    var name: String
    var storeId: Int
    var type: String
    var value: Int
    var code: String
    var store: StoreDetail?
    var expiryDate: String
    var redirectUrl: String

    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        storeId = jsonData["store_id"] as? Int ?? 0
        type = jsonData["type"] as? String ?? ""
        value = jsonData["value"] as? Int ?? 0
        code = jsonData["code"] as? String ?? ""
        expiryDate = jsonData["expiry_date"] as? String ?? ""
        redirectUrl = jsonData["redirectUrl"] as? String ?? ""
        if let storeData =  jsonData["store"] as? [String: Any] {
            let obj = StoreDetail(jsonData: storeData)
            store = obj
        }
    }
}

//MARK: - StoreDetail
class StoreDetail {
    var id: Int
    var name: String
    var logo: String
    var maxCashbackPercentage: Int
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        logo = jsonData["logo"] as? String ?? ""
        maxCashbackPercentage = jsonData["max_cashback_percentage"] as? Int ?? 0
    }
}
