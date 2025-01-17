//
//  StoreDetailsModel .swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 22/01/24.
//

import Foundation

class StoreDetailsModel  {
    
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
    var payment_options: [PaymentOptionsInfo]
    var about: String
    var terms_and_conditions: String
    var awin_id: Int
    var awin_programmeInfo: String
    var status: String
    var affiliate_marketing: String
    var store_popularity: String
    var similar_stores: [SimilarStoresInfo]
    var redirectUrl: String
    var categories: [categoriesInfo]
    
    
    init(id: Int, name: String, category_id: String, logo: String, cashback_percentage: Int, max_cashback_percentage: Int, min_cashback_amount: Int, max_cashback_amount: Int, donated: String, shipping: String, delivery_time: String, website: String, clickThroughUrl: String, payment_options: [PaymentOptionsInfo], about: String, terms_and_conditions: String, awin_id: Int, awin_programmeInfo: String, status: String, affiliate_marketing: String, store_popularity: String, similar_stores: [SimilarStoresInfo], redirectUrl: String, categories: [categoriesInfo]) {
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
        self.payment_options = payment_options
        self.about = about
        self.terms_and_conditions = terms_and_conditions
        self.awin_id = awin_id
        self.awin_programmeInfo = awin_programmeInfo
        self.status = status
        self.affiliate_marketing = affiliate_marketing
        self.store_popularity = store_popularity
        self.similar_stores = similar_stores
        self.redirectUrl = redirectUrl
        self.categories = categories
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
        var payment_options                     = [PaymentOptionsInfo]()
        var about                               = ""
        var terms_and_conditions                = ""
        var awin_id                             = 0
        var awin_programmeInfo                  = ""
        var status                              = ""
        var affiliate_marketing                 = ""
        var store_popularity                    = ""
        var similar_stores                      = [SimilarStoresInfo]()
        var redirectUrl                         = ""
        var categories                          = [categoriesInfo]()
        
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
            
            if let paymentOptionsData = jsonDict["payment_options"] as? [[String: Any]] {
                for dict in paymentOptionsData {
                    guard let id = dict["id"] as? Int, let name = dict["name"] as? nameData, let logo = dict["logo"] as? String, let german_logo = dict["german_logo"] as? String, let slug = dict["slug"] as? String, let created_at = dict["created_at"] as? String, let updated_at = dict["updated_at"] as? String else {
                        
                       dPrint("payment_options not well")
                        continue
                    }
                    let object = PaymentOptionsInfo(id: id, name: name, logo: logo, german_logo: german_logo, slug: slug, created_at: created_at, updated_at: updated_at)
                    payment_options.append(object)
                }
            }
            
            if let similarStoresData = jsonDict["similar_stores"] as? [[String: Any]] {
                for dict in similarStoresData {
                    guard let id = dict["id"] as? Int, let name = dict["name"] as? String, let category_id = dict["category_id"] as? String, let logo = dict["logo"] as? String, let cashback_percentage = dict["cashback_percentage"] as? Int, let max_cashback_percentage = dict["max_cashback_percentage"] as? Int, let min_cashback_amount = dict["min_cashback_amount"] as? Int, let max_cashback_amount = dict["max_cashback_amount"] as? Int, let donated = dict["donated"] as? String, let shipping = dict["shipping"] as? String, let delivery_time = dict["delivery_time"] as? String, let website = dict["website"] as? String, let clickThroughUrl = dict["clickThroughUrl"] as? String, let about = dict["about"] as? String, let terms_and_conditions = dict["terms_and_conditions"] as? String,  let awin_id = dict["awin_id"] as? Int, let awin_programmeInfo = dict["awin_programmeInfo"] as? String, let status = dict["status"] as? String, let affiliate_marketing = dict["affiliate_marketing"] as? String, let store_popularity = dict["store_popularity"] as? String, let redirectUrl = dict["redirectUrl"] as? String else {
                       dPrint("similar_stores not well")
                        continue
                    }
                    let object = SimilarStoresInfo(id: id, name: name, category_id: category_id, logo: logo, cashback_percentage: cashback_percentage, max_cashback_percentage: max_cashback_percentage, min_cashback_amount: min_cashback_amount, max_cashback_amount: max_cashback_amount, donated: donated, shipping: shipping, delivery_time: delivery_time, website: website, clickThroughUrl: clickThroughUrl, about: about, terms_and_conditions: terms_and_conditions, awin_id: awin_id, awin_programmeInfo: awin_programmeInfo, status: status, affiliate_marketing: affiliate_marketing, store_popularity: store_popularity, redirectUrl: redirectUrl)
                    
                    similar_stores.append(object)
                }
            }

            if let categoriesData = jsonDict["categories"] as? [[String: Any]] {
                for dict in categoriesData {
                    guard let id = dict["id"] as? Int, let name = dict["name"] as? String, let logo = dict["logo"] as? String, let created_at = dict["created_at"] as? String, let updated_at = dict["updated_at"] as? String, let pivot = dict["pivot"] as? pivotData else {
                        
                       dPrint("categories not well")
                        continue
                    }
                    let object = categoriesInfo(id: id, name: name, logo: logo, created_at: created_at, updated_at: updated_at, pivot: pivot)
                    categories.append(object)
                }
            }
            
        }
        self.init(id: id, name: name, category_id: category_id, logo: logo, cashback_percentage: cashback_percentage, max_cashback_percentage: max_cashback_percentage, min_cashback_amount: min_cashback_amount, max_cashback_amount: max_cashback_amount, donated: donated, shipping: shipping, delivery_time: delivery_time, website: website, clickThroughUrl: clickThroughUrl, payment_options: payment_options, about: about, terms_and_conditions: terms_and_conditions, awin_id: awin_id, awin_programmeInfo: awin_programmeInfo, status: status, affiliate_marketing: affiliate_marketing, store_popularity: store_popularity, similar_stores: similar_stores, redirectUrl: redirectUrl, categories: categories)
    }
}
