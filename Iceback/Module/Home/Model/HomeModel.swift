//
//  HomeModel.swift
//  Iceback
//
//  Created by Admin on 22/01/24.
//

import Foundation

//MARK: - HomeModel
class HomeModel {
    var data: [HomeData]
    var links: Links?
    var meta: Meta?
    
    init(jsonData: [String: Any]) {
        var arrData = [HomeData]()
        
        if let donationData = jsonData["data"] as? [[String: Any]] {
            for dict in donationData {
                let obj = HomeData(jsonData: dict)
                arrData.append(obj)
            }
        }
        
        data = arrData
        
        if let donationLinks = jsonData["links"] as? [String: Any] {
            let obj = Links(jsonData: donationLinks)
            links = obj
        }
        
        if let donationMeta = jsonData["meta"] as? [String: Any] {
            let obj = Meta(jsonData: donationMeta)
            meta = obj
        }
        
    }
}

//MARK: - HomeData
class HomeData {
    var ampUrl: String
    var apiUrl: String
    var collection: Collection?
    var content: [ContentData]
    var date: String
    var editUrl: String
    var id: Int
    var isEntry: Bool
    var lastModified, locale: String
    var mount, order, permalink: String
    var datumPrivate, published: Bool
    var slug, status: String
    var template: Template?
    var title, updatedAt: String
    var uri, url: String
    
    init(jsonData: [String: Any]) {
        var arrContentData = [ContentData]()
        ampUrl = jsonData["amp_url"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
        if let donationCollection = jsonData["collection"] as? [String: Any] {
            let obj = Collection(jsonData: donationCollection)
            collection = obj
        }
        if let contentData = jsonData["content"] as? [[String: Any]] {
            for dict in contentData {
                let obj = ContentData(jsonData: dict)
                arrContentData.append(obj)
            }
        }
        content = arrContentData
        date = jsonData["date"] as? String ?? ""
        editUrl = jsonData["edit_url"] as? String ?? ""
        id = jsonData["id"] as? Int ?? 0
        isEntry = jsonData["is_entry"] as? Bool ?? false
        lastModified = jsonData["last_modified"] as? String ?? ""
        locale = jsonData["locale"] as? String ?? ""
        mount = jsonData["mount"] as? String ?? ""
        order = jsonData["order"] as? String ?? ""
        permalink = jsonData["permalink"] as? String ?? ""
        datumPrivate = jsonData["private"] as? Bool ?? false
        published = jsonData["published"] as? Bool ?? false
        slug = jsonData["slug"] as? String ?? ""
        status = jsonData["status"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        uri = jsonData["uri"] as? String ?? ""
        url = jsonData["permalink"] as? String ?? ""
    }
}

//MARK: - Template
class Template {
    
}

//MARK: - ContentData
class ContentData {
    var primaryContent, secondaryContent, buttonText, buttonLink: String?
    var image: [ImageElement]?
    var videoUrl: String?
    var type: String
    var title: String?
    var howItWorksItems: [HowItWorksItem]?
    var numberOfItems: Int?
    var subtitle, content, primaryText, secondaryText: String?
    var button2_Text, button2_Link: String?
    var imagePosition: Template?
    var optionalTitle: String?
    var bard: [Bard]?
    var text: String?
    
    init(jsonData: [String: Any]) {
        var arrImage = [ImageElement]()
        var arrHowItWorksItems = [HowItWorksItem]()
        primaryContent = jsonData["primary_content"] as? String ?? ""
        secondaryContent = jsonData["secondary_content"] as? String ?? ""
        buttonText = jsonData["button_text"] as? String ?? ""
        buttonLink = jsonData["button_link"] as? String ?? ""
        button2_Text = jsonData["button_2_text"] as? String ?? ""
        content = jsonData["content"] as? String ?? ""
        if let contentData = jsonData["image"] as? [[String: Any]] {
            for dict in contentData {
                let obj = ImageElement(jsonData: dict)
                arrImage.append(obj)
            }
        }
        image = arrImage
        videoUrl = jsonData["video_url"] as? String ?? ""
        type = jsonData["type"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        
        if let howItWorksItemsData = jsonData["how_it_works_items"] as? [[String: Any]] {
            for dict in howItWorksItemsData {
                let obj = HowItWorksItem(jsonData: dict)
                arrHowItWorksItems.append(obj)
            }
        }
        howItWorksItems = arrHowItWorksItems
        
        numberOfItems = jsonData["number_of_items"] as? Int ?? 0
        text = jsonData["text"] as? String ?? ""
    }
    
}

//MARK: - ImageUnion
enum ImageUnion {
    case imageElement(ImageElement)
    case imageElementArray([ImageElement])
}

// MARK: - ImageElement
class ImageElement {
    var id: String
    var url, permalink, apiUrl: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? String ?? ""
        url = jsonData["url"] as? String ?? ""
        permalink = jsonData["permalink"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
        
    }
}

// MARK: - HowItWorksItem
class HowItWorksItem {
    var title, subtitle, type: String
    
    init(jsonData: [String: Any]) {
        title = jsonData["title"] as? String ?? ""
        subtitle = jsonData["subtitle"] as? String ?? ""
        type = jsonData["type"] as? String ?? ""
    }
}

// MARK: - Bard
class Bard {
    var size: Int?
    var content: [BardContent]?
    var type: String
    var text: String?
    
    init(jsonData: [String: Any]) {
        var arrContent = [BardContent]()

        size = jsonData["size"] as? Int ?? 0
        
        if let contentData = jsonData["data"] as? [[String: Any]] {
            for dict in contentData {
                let obj = BardContent(jsonData: dict)
                arrContent.append(obj)
            }
        }
        content = arrContent
        
        type = jsonData["type"] as? String ?? ""
        text = jsonData["text"] as? String ?? ""
    }
    
}


// MARK: - BardContent
class BardContent {
    var title, text: String?
    var type: String
    var numberOfItems: Int?
    
    init(jsonData: [String: Any]) {
        title = jsonData["title"] as? String ?? ""
        text = jsonData["text"] as? String ?? ""
        type = jsonData["type"] as? String ?? ""
        numberOfItems = jsonData["number_of_items"] as? Int ?? 0
    }
}
