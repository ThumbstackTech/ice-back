//
//  ReportIssueModel.swift
//  Iceback
//
//  Created by apple on 15/04/24.
//

import Foundation


class CreateRportData {
    
    var userId : Int
    var issueNumber : Int
    var issueSubject : String
    var issueDetail : String
    var issueImage : String
    var createdAt : String
    var updatedAt : String
    
    required init(jsonDic:[String:Any]) {
    
        userId = jsonDic["user_id"] as? Int ?? 0
        issueNumber = jsonDic["issue_number"] as? Int ?? 0
        issueSubject = jsonDic["issue_subject"] as? String ?? ""
        issueDetail = jsonDic["issue_detail"] as? String ?? ""
        issueImage = jsonDic["issue_image"] as? String ?? ""
        createdAt = jsonDic["created_at"] as? String ?? ""
        updatedAt = jsonDic["updated_at"] as? String ?? ""
    }
}

class ReportListData {
    
    var issue_type: String
    var id : Int
    var issueNumber : Int
    var issueSubject : String
    var issueDetail : String
    var issueImage : String
    var created_at:String
    var updated_at: String
    
    
    required init(jsonDic:[String:Any]) {
        
        id = jsonDic["id"] as? Int ?? 0
        issueNumber = jsonDic["issue_number"] as? Int ?? 0
        issueSubject = jsonDic["issue_subject"] as? String ?? ""
        issueDetail = jsonDic["issue_detail"] as? String ?? ""
        issueImage = jsonDic["issue_image"] as? String ?? ""
        created_at = jsonDic["created_at"] as? String ?? ""
        updated_at = jsonDic["updated_at"] as? String ?? ""
        issue_type = jsonDic["issue_type"] as? String ?? ""
        
    }
}

