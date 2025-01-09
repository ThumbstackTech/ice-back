//
//  StoreModel.swift
//  Iceback
//
//  Created by Admin on 25/01/24.
//

import Foundation
import ObjectMapper

class StoreModel : NSObject,Mappable {
    
    var status = ""
    var storeDataList = [storeDataListObject]()
    
    override init() {
         
    }
    
    required init?(map: Map) {
        status <- map["status"]
        storeDataList <- map["data"]
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        storeDataList <- map["data"]
    }
}

class storeDataListObject : NSObject,Mappable {
    
    var storeId = 0
    var name = ""
    var categoryId = 0
    var logo = ""
    var cashbackPercentage = 0.0
    var maxCashbackPercentage = 0.0
    var minCashbackAmount = 0.0
    var maxCashbackAmount = 0.0
    var donated = 0
    var isFavourite = 0
    var shipping = [String: Bool]()
    var deliveryTime = deliveryTimeObject()
    var website = ""
    var clickThroughUrl = ""
    var paymentOptions = [paymentOptionsDataObject]()
    var about = ""
    var termsAndConditions = ""
    var awinid = 0
    var awinProgramInfo = ""
    var awinKpi = ""
    var awinCommissionRange = ""
    var status = ""
    var affiliateMarketing = ""
    var storePopularity = ""
    var redirectUrl = ""
    var categories = [CategoriesData]()
    var regionLogo = [String]()
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
        storeId <- map["id"]
        name <- map["name"]
        categoryId <- map["category_id"]
        logo <- map["logo"]
        cashbackPercentage <- map["cashback_percentage"]
        maxCashbackPercentage <- map["max_cashback_percentage"]
        minCashbackAmount <- map["min_cashback_amount"]
        maxCashbackAmount <- map["max_cashback_amount"]
        donated <- map["donated"]
        shipping <- map["shipping"]
        isFavourite <- map["is_favourite"]
        deliveryTime <- map["delivery_time"]
        website <- map["website"]
        clickThroughUrl <- map["clickThroughUrl"]
        paymentOptions <- map["payment_options"]
        about <- map["about"]
        termsAndConditions <- map["terms_and_conditions"]
        awinid <- map["awin_id"]
        awinProgramInfo <- map["awin_programmeInfo"]
        awinKpi <- map["awin_kpi"]
        awinCommissionRange <- map["awin_commissionRange"]
        status <- map["status"]
        affiliateMarketing <- map["affiliate_marketing"]
        storePopularity <- map["store_popularity"]
        redirectUrl <- map["redirectUrl"]
        categories <- map["categories"]
        regionLogo <- map["region_logo"]
    }
    
    func mapping(map: Map) {
        
        storeId <- map["id"]
        name <- map["name"]
        categoryId <- map["category_id"]
        logo <- map["logo"]
        cashbackPercentage <- map["cashback_percentage"]
        maxCashbackPercentage <- map["max_cashback_percentage"]
        minCashbackAmount <- map["min_cashback_amount"]
        maxCashbackAmount <- map["max_cashback_amount"]
        donated <- map["donated"]
        shipping <- map["shipping"]
        deliveryTime <- map["delivery_time"]
        website <- map["website"]
        clickThroughUrl <- map["clickThroughUrl"]
        paymentOptions <- map["payment_options"]
        about <- map["about"]
        termsAndConditions <- map["terms_and_conditions"]
        awinid <- map["awin_id"]
        awinProgramInfo <- map["awin_programmeInfo"]
        awinKpi <- map["awin_kpi"]
        awinCommissionRange <- map["awin_commissionRange"]
        status <- map["status"]
        affiliateMarketing <- map["affiliate_marketing"]
        storePopularity <- map["store_popularity"]
        redirectUrl <- map["redirectUrl"]
        categories <- map["categories"]
        regionLogo <- map["region_logo"]
    }
}

class ShippingObject : NSObject,Mappable {
    
    var str1 = false
    var str2 = false
    var str3 = false
    var str4 = false
    
    override init() {
        
    }
    
    required init?(map: Map) {
        str1 <- map["1"]
        str2 <- map["2"]
        str3 <- map["4"]
        str4 <- map["6"]
    }
    
    func mapping(map: Map) {
        str1 <- map["1"]
        str2 <- map["2"]
        str3 <- map["4"]
        str4 <- map["6"]
    }
}


class deliveryTimeObject : NSObject,Mappable {
    
    var de = ""
    
    override init() {
        
    }
    
    required init?(map: Map) {
        de <- map["de"]
    }
    
    func mapping(map: Map) {
        de <- map["de"]
    }
}

class paymentOptionsDataObject : NSObject,Mappable {
    
    var paymentId = 0
    var paymentNameData = [paymentNameDataObject]()
    var logo = ""
    var germanLogo = ""
    var slug = ""
    var createdAt = ""
    var updatedAt = ""
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
        paymentId <- map["id"]
        paymentNameData <- map["name"]
        logo <- map["logo"]
        germanLogo <- map["german_logo"]
        slug <- map["slug"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        
    }
    
    func mapping(map: Map) {
        
        paymentId <- map["id"]
        paymentNameData <- map["name"]
        logo <- map["logo"]
        germanLogo <- map["german_logo"]
        slug <- map["slug"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        
    }
}


class paymentNameDataObject : NSObject,Mappable {
    
    
    var en = ""
    var de = ""
    
    override init() {
        
    }
    
    required init?(map: Map) {
        en <- map["en"]
        de <- map["de"]
    }
    
    func mapping(map: Map) {
        en <- map["en"]
        de <- map["de"]
    }
}



class CategoriesData : NSObject,Mappable {
    
    override init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
