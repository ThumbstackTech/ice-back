//
//  PaymentOptionsInfo.swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 23/01/24.
//

import Foundation

class PaymentOptionsInfo {
    
    var id: Int
    var name: nameData?
    var logo: String
    var german_logo: String
    var slug: String
    var created_at: String
    var updated_at: String
    
    init(id: Int, name: nameData, logo: String, german_logo: String, slug: String, created_at: String, updated_at: String) {
        self.id = id
        self.name = name
        self.logo = logo
        self.german_logo = german_logo
        self.slug = slug
        self.created_at = created_at
        self.updated_at = updated_at
    }
    
    convenience init(jsonDict: [String: Any]?) {
        var id              = 0
        var name            = nameData(en: "", de: "")
        var logo            = ""
        var german_logo     = ""
        var slug            = ""
        var created_at      = ""
        var updated_at      = ""
        
        if let jsonDict = jsonDict {
            id               = (jsonDict["id"] as? Int) ?? 0
            logo             = (jsonDict["logo"] as? String) ?? ""
            german_logo      = (jsonDict["german_logo"] as? String) ?? ""
            slug             = (jsonDict["slug"] as? String) ?? ""
            created_at       = (jsonDict["created_at"] as? String) ?? ""
            updated_at       = (jsonDict["updated_at"] as? String) ?? ""
            
            if let nameLanguageData = jsonDict["name"] as? [String: Any] {
                let en   = (nameLanguageData["en"] as? String) ?? ""
                let de   = (nameLanguageData["de"] as? String) ?? ""
                name = nameData(en: en, de: de)
            }
        }
        self.init(id: id, name: name, logo: logo, german_logo: german_logo, slug: slug, created_at: created_at, updated_at: updated_at)
    }
}

class nameData {
    
    var en: String
    var de: String
    
    init(en: String, de: String) {
        self.en = en
        self.de = de
    }
}

class PaymentOptionsInfoData {
    var id: Int
    var name: nameData?
    var logo: String
    var german_logo: String
    var slug: String
    var created_at: String
    var updated_at: String
    
    init(jsonData: [String: Any]) {
        id               = jsonData["id"] as? Int ?? 0
        logo             = jsonData["logo"] as? String ?? ""
        german_logo      = jsonData["german_logo"] as? String ?? ""
        slug             = jsonData["slug"] as? String ?? ""
        created_at       = jsonData["created_at"] as? String ?? ""
        updated_at       = jsonData["updated_at"] as? String ?? ""
        
        if let nameLanguageData = jsonData["name"] as? [String: Any] {
            let en   = nameLanguageData["en"] as? String ?? ""
            let de   = nameLanguageData["de"] as? String ?? ""
            name = nameData(en: en, de: de)
        }
    }
}
