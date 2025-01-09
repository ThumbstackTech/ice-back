//
//  DonationProjectModel.swift
//  Iceback
//
//  Created by Admin on 10/01/24.
//

import Foundation

//MARK: - DonationProjectsModel
class DonationProjectsModel {
    var data: [DonationProjectsData]
    var links: Links?
    var meta: Meta?
    
    init(jsonData: [String: Any]) {
    var arrData = [DonationProjectsData]()
        
        if let donationData = jsonData["data"] as? [[String: Any]] {
            for dict in donationData {
                let obj = DonationProjectsData(jsonData: dict)
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

//MARK: - DonationProjectsData
class DonationProjectsData {
    var ampUrl: String
    var apiUrl: String
    var bannerImage: Image?
    var collection: Collection?
    var content: [ContentData]?
    var date: String
    var donated: String?
    var editUrl: String
    var iban: String?
    var id: Int
    var isEntry: Bool
    var lastModified: String
    var locale: String
    var mainImage: Image?
    var mount: String
    var order: String
    var permalink: String
    var datumPrivate: Bool
    var projectCost, projectSummary: String
    var projectTags: [ProjectTag]
    var published: Bool
    var slug: String
    var status: String
    var title: String
    var updatedAt: String
    var updatedBy: UpdatedBy?
    var uri: String
    var url: String
    
    init(jsonData: [String: Any]) {
        var arrProjectTags = [ProjectTag]()
        var arrContentData = [ContentData]()
        ampUrl = jsonData["amp_url"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
        if let donationBannerImage = jsonData["banner_image"] as? [String: Any] {
            let obj = Image(jsonData: donationBannerImage)
            bannerImage = obj
        }
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
        donated = jsonData["donated"] as? String ?? "0"
        editUrl = jsonData["edit_url"] as? String ?? ""
        iban = jsonData["iban"] as? String ?? ""
        id = jsonData["id"] as? Int ?? 0
        isEntry = jsonData["is_entry"] as? Bool ?? false
        lastModified = jsonData["last_modified"] as? String ?? ""
        locale = jsonData["locale"] as? String ?? ""
        if let donationMainImage = jsonData["main_image"] as? [String: Any] {
            let obj = Image(jsonData: donationMainImage)
            mainImage = obj
        }
        mount = jsonData["mount"] as? String ?? ""
        order = jsonData["order"] as? String ?? ""
        permalink = jsonData["permalink"] as? String ?? ""
        datumPrivate = jsonData["private"] as? Bool ?? false
        projectCost = jsonData["project_cost"] as? String ?? "0"
        projectSummary = jsonData["project_summary"] as? String ?? ""
            if let donationProjectTags = jsonData["project_tags"] as? [[String: Any]] {
                for dict in donationProjectTags {
                    let obj = ProjectTag(jsonData: dict)
                    arrProjectTags.append(obj)
                }
            }
        projectTags = arrProjectTags
        published = jsonData["published"] as? Bool ?? false
        slug = jsonData["slug"] as? String ?? ""
        status = jsonData["status"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        updatedAt = jsonData["updated_at"] as? String ?? ""
        if let donationUpdatedBy = jsonData["updated_by"] as? [String: Any] {
            let obj = UpdatedBy(jsonData: donationUpdatedBy)
            updatedBy = obj
        }
        uri = jsonData["uri"] as? String ?? ""
        url = jsonData["url"] as? String ?? ""
    }
}

// MARK: - Image
class Image {
    var id: String
    var url: String
    var permalink: String
    var apiUrl: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? String ?? ""
        url = jsonData["url"] as? String ?? ""
        permalink = jsonData["permalink"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
    }
}

// MARK: - Collection
class Collection {
    var id: String?
    var title: String
    var apiUrl: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
    }
}

// MARK: - ProjectTag
class ProjectTag {
    var id: String
    var title: String
    var slug: String
    var url: String
    var permalink: String
    var apiUrl: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? String ?? ""
        title = jsonData["title"] as? String ?? ""
        slug = jsonData["slug"] as? String ?? ""
        url = jsonData["url"] as? String ?? ""
        permalink = jsonData["permalink"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
    }
}

// MARK: - UpdatedBy
class UpdatedBy {
    var id: Int
    var name: String
    var email: String
    var apiUrl: String
    
    init(jsonData: [String: Any]) {
        id = jsonData["id"] as? Int ?? 0
        name = jsonData["name"] as? String ?? ""
        email = jsonData["email"] as? String ?? ""
        apiUrl = jsonData["api_url"] as? String ?? ""
    }
}

// MARK: - Links
class Links {
    var last: String
    var first: String
    var prev: String
    var next: String
    
    init(jsonData: [String: Any]) {
        last = jsonData["last"] as? String ?? ""
        first = jsonData["first"] as? String ?? ""
        prev = jsonData["prev"] as? String ?? ""
        next = jsonData["next"] as? String ?? ""
    }
    
}

// MARK: - Meta
class Meta {
    var currentPage: Int
    var from: Int
    var lastPage: Int
    var links: [Link]
    var path: String
    var perPage, to, total: Int
    
    init(jsonData: [String: Any]) {
        currentPage = jsonData["current_page"] as? Int ?? 0
        from = jsonData["from"] as? Int ?? 0
        lastPage = jsonData["last_page"] as? Int ?? 0
        links = jsonData["next"] as? [Link] ?? []
        path = jsonData["path"] as? String ?? ""
        perPage = jsonData["per_page"] as? Int ?? 0
        to = jsonData["to"] as? Int ?? 0
        total = jsonData["total"] as? Int ?? 0
    }
    
}


// MARK: - Link
class Link {
    var url: String
    var label: String
    var active: Bool
    
    init(jsonData: [String: Any]) {
        url = jsonData["url"] as? String ?? ""
        label = jsonData["label"] as? String ?? ""
        active = jsonData["active"] as? Bool ?? false
    }
}
