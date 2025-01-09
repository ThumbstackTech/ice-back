//
//  categoriesInfo.swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 23/01/24.
//

import Foundation

class categoriesInfo {
    
    var id: Int
    var name: String
    var logo: String
    var created_at: String
    var updated_at: String
    var pivot: pivotData?
    
    init(id: Int, name: String, logo: String, created_at: String, updated_at: String, pivot: pivotData) {
        self.id = id
        self.name = name
        self.logo = logo
        self.created_at = created_at
        self.updated_at = updated_at
        self.pivot = pivot
    }
    
    convenience init(jsonDict: [String: Any]?) {
        var id              = 0
        var name            = ""
        var logo            = ""
        var created_at      = ""
        var updated_at      = ""
        var pivot           = pivotData(store_id: 0, store_category_id: 0)
        
        if let jsonDict = jsonDict {
            id               = (jsonDict["id"] as? Int) ?? 0
            logo             = (jsonDict["logo"] as? String) ?? ""
            name             = (jsonDict["name"] as? String) ?? ""
            created_at       = (jsonDict["created_at"] as? String) ?? ""
            updated_at       = (jsonDict["updated_at"] as? String) ?? ""
            
            if let categoriesData = jsonDict["pivot"] as? [String: Any] {
                let store_id   = (categoriesData["store_id"] as? Int) ?? 0
                let store_category_id   = (categoriesData["store_category_id"] as? Int) ?? 0
                pivot = pivotData(store_id: store_id, store_category_id: store_category_id)
            }
        }
        self.init(id: id, name: name, logo: logo, created_at: created_at, updated_at: updated_at, pivot: pivot)
    }
}


class pivotData {
    var store_id: Int
    var store_category_id: Int
    
    init(store_id: Int, store_category_id: Int) {
        self.store_id = store_id
        self.store_category_id = store_category_id
    }
}
