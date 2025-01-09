//
//  DealsAndVoucherDetailData.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation

class DealsAndVoucherDetailData {
    var id: Int
    var name: String
    var logo: String
    var cashbackPercentage: Double
    var maxCashbackPercentage: Double
    var maxCashbackAmount: Double
    var storePopularity: String
    var clickThroughUrl: String

    var shipping: [String: Bool]
    var paymentOptions: [PaymentOptionsInfoData]
    var deliveryTime : DeliveryTime?
    
    init(jsonData: [String: Any]) {
        var arrData = [PaymentOptionsInfoData]()
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        logo = jsonData["logo"] as? String ?? ""
        storePopularity = jsonData["store_popularity"] as? String ?? ""
        cashbackPercentage = jsonData["cashback_percentage"] as? Double ?? 0.0
        maxCashbackPercentage = jsonData["max_cashback_percentage"] as? Double ?? 0.0
        maxCashbackAmount = jsonData["max_cashback_amount"] as? Double ?? 0.0
        clickThroughUrl = jsonData["clickThroughUrl"] as? String ?? ""
        
        if let paymentOptionsData = jsonData["payment_options"] as? [[String: Any]] {
            for dict in paymentOptionsData {
                let obj = PaymentOptionsInfoData(jsonData: dict)
                arrData.append(obj)
            }
        }
        
        paymentOptions = arrData
        shipping = jsonData["shipping"] as? [String: Bool] ?? [:]
        
        if let objDeliveryTime = jsonData["delivery_time"] as? [String: Any] {
            let obj = DeliveryTime(jsonData: objDeliveryTime)
            deliveryTime = obj
        }
        
    }
}

class DeliveryTime {
    var de: String?
    
    init(jsonData: [String: Any]) {
        de = jsonData["de"] as? String ?? ""
    }
}
