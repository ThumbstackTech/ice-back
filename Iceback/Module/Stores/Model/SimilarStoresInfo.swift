//
//  SimilarStoresInfo.swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 23/01/24.
//

import Foundation

class SimilarStoresInfo {
    var id: Int
    var name: String
    var category_id: String
    var logo: String
    var cashback_percentage: Int
    var max_cashback_percentage: Int
    var min_cashback_amount: Int
    var max_cashback_amount: Int
    var donated: String
    var shipping: String
    var delivery_time: String
    var website: String
    var clickThroughUrl: String
    var about: String
    var terms_and_conditions: String
    var awin_id: Int
    var awin_programmeInfo: String
    var status: String
    var affiliate_marketing: String
    var store_popularity: String
    var redirectUrl: String
    
    init(id: Int, name: String, category_id: String, logo: String, cashback_percentage: Int, max_cashback_percentage: Int, min_cashback_amount: Int, max_cashback_amount: Int, donated: String, shipping: String, delivery_time: String, website: String, clickThroughUrl: String, about: String, terms_and_conditions: String, awin_id: Int, awin_programmeInfo: String, status: String, affiliate_marketing: String, store_popularity: String, redirectUrl: String) {
        self.id = id
        self.name = name
        self.category_id = category_id
        self.logo = logo
        self.cashback_percentage = cashback_percentage
        self.max_cashback_percentage = max_cashback_percentage
        self.min_cashback_amount = min_cashback_amount
        self.max_cashback_amount = max_cashback_amount
        self.donated = donated
        self.shipping = shipping
        self.delivery_time = delivery_time
        self.website = website
        self.clickThroughUrl = clickThroughUrl
        self.about = about
        self.terms_and_conditions = terms_and_conditions
        self.awin_id = awin_id
        self.awin_programmeInfo = awin_programmeInfo
        self.status = status
        self.affiliate_marketing = affiliate_marketing
        self.store_popularity = store_popularity
        self.redirectUrl = redirectUrl
    }
    
    convenience init(jsonDict: [String: Any]?) {
        var id                                  = 0
        var name                                = ""
        var category_id                         = ""
        var logo                                = ""
        var cashback_percentage                 = 0
        var max_cashback_percentage             = 0
        var min_cashback_amount                 = 0
        var max_cashback_amount                 = 0
        var donated                             = ""
        var shipping                            = ""
        var delivery_time                       = ""
        var website                             = ""
        var clickThroughUrl                     = ""
        var about                               = ""
        var terms_and_conditions                = ""
        var awin_id                             = 0
        var awin_programmeInfo                  = ""
        var status                              = ""
        var affiliate_marketing                 = ""
        var store_popularity                    = ""
        var redirectUrl                         = ""
        
        if let jsonDict = jsonDict {
             id                                  = (jsonDict["id"] as? Int) ?? 0
             name                                = (jsonDict["name"] as? String) ?? ""
             category_id                         = (jsonDict["category_id"] as? String) ?? ""
             logo                                = (jsonDict["logo"] as? String) ?? ""
             cashback_percentage                 = (jsonDict["cashback_percentage"] as? Int) ?? 0
             max_cashback_percentage             = (jsonDict["max_cashback_percentage"] as? Int) ?? 0
             min_cashback_amount                 = (jsonDict["min_cashback_amount"] as? Int) ?? 0
             max_cashback_amount                 = (jsonDict["max_cashback_amount"] as? Int) ?? 0
             donated                             = (jsonDict["donated"] as? String) ?? ""
             shipping                            = (jsonDict["shipping"] as? String) ?? ""
             delivery_time                       = (jsonDict["delivery_time"] as? String) ?? ""
             website                             = (jsonDict["website"] as? String) ?? ""
             clickThroughUrl                     = (jsonDict["clickThroughUrl"] as? String) ?? ""
             about                               = (jsonDict["about"] as? String) ?? ""
             terms_and_conditions                = (jsonDict["terms_and_conditions"] as? String) ?? ""
             awin_id                             = (jsonDict["awin_id"] as? Int) ?? 0
             awin_programmeInfo                  = (jsonDict["awin_programmeInfo"] as? String) ?? ""
             status                              = (jsonDict["status"] as? String) ?? ""
             affiliate_marketing                 = (jsonDict["affiliate_marketing"] as? String) ?? ""
             store_popularity                    = (jsonDict["store_popularity"] as? String) ?? ""
             redirectUrl                         = (jsonDict["redirectUrl"] as? String) ?? ""
        }
        
        self.init(id: id, name: name, category_id: category_id, logo: logo, cashback_percentage: cashback_percentage, max_cashback_percentage: max_cashback_percentage, min_cashback_amount: min_cashback_amount, max_cashback_amount: max_cashback_amount, donated: donated, shipping: shipping, delivery_time: delivery_time, website: website, clickThroughUrl: clickThroughUrl, about: about, terms_and_conditions: terms_and_conditions, awin_id: awin_id, awin_programmeInfo: awin_programmeInfo, status: status, affiliate_marketing: affiliate_marketing, store_popularity: store_popularity, redirectUrl: redirectUrl)
    }
}


class SimilarStoresData {
    var id: Int
    var name: String
    var logo: String
    var max_cashback_amount: Int
    
    init(jsonData: [String: Any]) {
        id                      = jsonData["id"] as? Int ?? 0
        name                    = jsonData["name"] as? String ?? ""
        logo                    = jsonData["logo"] as? String ?? ""
        max_cashback_amount     = jsonData["max_cashback_amount"] as? Int ?? 0
    }
}

class SimilarStoresModel {
    var id: Int
    var name: String
    var type: String
    var storeId: Int
    var store: SimilarStoresLogo?
    
    init(jsonData: [String: Any]) {
        id                      = jsonData["id"] as? Int ?? 0
        name                    = jsonData["name"] as? String ?? ""
        type                    = jsonData["type"] as? String ?? ""
        storeId                 = jsonData["store_id"] as? Int ?? 0
        
        if let storeData = jsonData["store"] as? [String: Any] {
            let id   = storeData["id"] as? Int ?? 0
            let logo   = storeData["logo"] as? String ?? ""
            store = SimilarStoresLogo(id: id, logo: logo)
        }
    }
}

class SimilarStoresLogo {
    var id: Int
    var logo: String

    init(id: Int,logo: String) {
        self.id = id
        self.logo = logo
    }
}
