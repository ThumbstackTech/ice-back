//
//  CMSVCDataModel.swift
//  Iceback
//
//  Created by Admin on 29/01/24.
//

import Foundation

class PrivacyPolicyDataModel {
    var content: [ContentInfoData]
    var title: String
    
    init(jsonData: [String: Any]) {
        var arrContentInfo = [ContentInfoData]()
        
        title = jsonData["title"] as? String ?? ""
        
        if let contentTag = jsonData["content"] as? [[String: Any]] {
            for dict in contentTag {
                let obj = ContentInfoData(jsonData: dict)
                arrContentInfo.append(obj)
            }
        }
        content = arrContentInfo
    }
}


class ContentInfoData {
    var text, type, content: String
    
    init(jsonData: [String: Any]) {
        text = jsonData["text"] as? String ?? ""
        type = jsonData["type"] as? String ?? ""
        content = jsonData["content"] as? String ?? ""
    }
}
