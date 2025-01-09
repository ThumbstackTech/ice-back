//
//  StoreDetailsNewModel.swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 23/01/24.
//

import Foundation

class StoreDetailsNewModel {
    
    var name: String
    var logo: String
    var cashback_percentage: Double
    var max_cashback_percentage: Double
    var max_cashback_amount: Double
    var minCashbackAmount: Double
    var isFavourite: Int
    var shipping: [String: Bool]
    var payment_options: [PaymentOptionsInfoData]
    var similar_stores: [SimilarStoresData]
    var deliveryTime : DeliveryTime?
    var termsAndCondition: TermsAndConditions?
    var clickThroughUrl: String
    var redirectUrl: String

    init(jsonData: [String: Any]) {
        var arrPaymentOptionsInfo = [PaymentOptionsInfoData]()
        var arrSimilarStoresData = [SimilarStoresData]()
        clickThroughUrl = jsonData["clickThroughUrl"] as? String ?? ""
        redirectUrl = jsonData["redirectUrl"] as? String ?? ""
        name = jsonData["name"] as? String ?? ""
        logo = jsonData["logo"] as? String ?? ""
        minCashbackAmount = jsonData["min_cashback_amount"] as? Double ?? 0.0
        isFavourite = jsonData["is_favourite"] as? Int ?? 0
        cashback_percentage = jsonData["cashback_percentage"] as? Double ?? 0.0
        max_cashback_percentage = jsonData["max_cashback_percentage"] as? Double ?? 0.0
        max_cashback_amount = jsonData["max_cashback_amount"] as? Double ?? 0.0
        
        shipping = jsonData["shipping"] as? [String: Bool] ?? [:]
        
      
        
        if let paymentOptionsTag = jsonData["payment_options"] as? [[String: Any]] {
            for dict in paymentOptionsTag {
                let obj = PaymentOptionsInfoData(jsonData: dict)
                arrPaymentOptionsInfo.append(obj)
            }
        }
        payment_options = arrPaymentOptionsInfo
        
        if let similarStoresTag = jsonData["similar_stores"] as? [[String: Any]] {
            for dict in similarStoresTag {
                let obj = SimilarStoresData(jsonData: dict)
                arrSimilarStoresData.append(obj)
            }
        }
        similar_stores = arrSimilarStoresData
        
        if let objDeliveryTime = jsonData["delivery_time"] as? [String: Any] {
            let obj = DeliveryTime(jsonData: objDeliveryTime)
            deliveryTime = obj
        }
        
        let temp = jsonData["terms_and_conditions"] as? String ?? ""
        
        // Convert JSON array string to Data
        guard let jsonData = temp.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to data.")
        }

        do {
            // Decode JSON data into an array of TermsAndConditions structs
            let termsAndConditionsArray = try JSONDecoder().decode([TermsAndConditions].self, from: jsonData)
            
            // Loop through each item in the array and access title and content
            for termsAndConditions in termsAndConditionsArray {
                let title = termsAndConditions.attributes.title
                let content = termsAndConditions.attributes.content
                termsAndCondition = termsAndConditions
                print("Title: \(title)")
                print("Content: \(content)")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}


 
// MARK: - TermsAndConditions
struct TermsAndConditions: Codable {
    let layout: String
    let key: String
    let attributes: Attributes
}

// MARK: - Attributes
struct Attributes: Codable {
    let title: String
    let content: String
    let titlede: String?
    let contentde: String?
}
