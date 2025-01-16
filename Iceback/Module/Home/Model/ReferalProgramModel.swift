//
//  ReferalProgramModel.swift
//  Iceback
//
//  Created by Admin on 29/01/24.
//

import Foundation

//MARK: - ReferalProgramModel
class ReferalProgramModel {
    var data: [ReferalProgramData]
    var links: Links?
    var meta: Meta?
    
    init(jsonData: [String: Any]) {
        var arrData = [ReferalProgramData]()
        if let referalData = jsonData["data"] as? [[String: Any]] {
            for dict in referalData {
                let obj = ReferalProgramData(jsonData: dict)
                arrData.append(obj)
            }
        }
        
        data = arrData
        
        if let referalLinks = jsonData["links"] as? [String: Any] {
            let obj = Links(jsonData: referalLinks)
            links = obj
        }
        
        if let referalMeta = jsonData["meta"] as? [String: Any] {
            let obj = Meta(jsonData: referalMeta)
            meta = obj
        }
    }
}

//MARK: - ReferalProgramData
class ReferalProgramData {
    var ampUrl: String?
    var apiUrl: String
    var collection: Collection?
    var content: [ReferalProgramContent]?
    var date: String
    var editUrl: String
    var id: Int
    var isEntry: Bool
    var lastModified, locale: String
    var mount, order, permalink: String?
    var datumPrivate, published: Bool
    var slug, status: String
    var template: Template?
    var title, updatedAt: String
    var updatedBy: UpdatedBy?
    var uri, url: String?
    var primaryImage: Image?
    
    init(jsonData: [String: Any]) {
        var arrContentData = [ReferalProgramContent]()
        ampUrl = jsonData["amp_url"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
        
        if let referalCollection = jsonData["collection"] as? [String: Any] {
            let obj = Collection(jsonData: referalCollection)
            collection = obj
        }
        
        if let contentData = jsonData["content"] as? [[String: Any]] {
            for dict in contentData {
                let obj = ReferalProgramContent(jsonData: dict)
                arrContentData.append(obj)
            }
        }
        
        if let primaryImageData = jsonData["primary_image"] as? [String: Any] {
            let obj = Image(jsonData: primaryImageData)
            primaryImage = obj
        }
        
        content = arrContentData
        date = jsonData["date"] as? String ?? ""
        editUrl = jsonData["edit_url"] as? String ?? ""
        id = jsonData["id"] as? Int ?? 0
        isEntry = jsonData["is_entry"] as? Bool ?? false
        lastModified = jsonData["last_modified"] as? String ?? ""
        locale = jsonData["locale"] as? String ?? ""
        datumPrivate = jsonData["private"] as? Bool ?? false
        published = jsonData["published"] as? Bool ?? false
        slug = jsonData["slug"] as? String ?? ""
        status = jsonData["status"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        
        if let referalUpdatedBy = jsonData["updated_by"] as? [String: Any] {
            let obj = UpdatedBy(jsonData: referalUpdatedBy)
            updatedBy = obj
        }
        
        
    }
}

//MARK: - ReferalProgramContent
class ReferalProgramContent {
    var text: String?
    var type: String
    var title: String?
    var howItWorksItems: [HowItWorksItem]?
    var referralCode: String?
    
    init(jsonData: [String: Any]) {
        var arrHowItWorksItems = [HowItWorksItem]()
        text = jsonData["text"] as? String ?? ""
        type = jsonData["type"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        if let howItWorksItemsData = jsonData["how_it_works_items"] as? [[String: Any]] {
            for dict in howItWorksItemsData {
                let obj = HowItWorksItem(jsonData: dict)
                arrHowItWorksItems.append(obj)
            }
        }
       dPrint("howItWorksItems: \(arrHowItWorksItems.count)")
        howItWorksItems = arrHowItWorksItems
        referralCode = jsonData["referral_code"] as? String ?? ""
    }
}


