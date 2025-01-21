//
//  NotificationData.swift
//  Iceback
//
//  Created by Admin on 24/05/24.
//

import Foundation



class NotifcationData {
    
    var id: Int
    var userId: Int
    var notificationType: String
    var title: String
    var description: String
    var isRead: Bool
    var createdAt: String
    var updatedAt: String
    var notificationData: NotificationDetail?
    
      init(jsonDic : [String:Any]) {
        
         id = jsonDic["id"]  as? Int ?? 0
         userId = jsonDic["user_id"] as? Int ?? 0
         notificationType = jsonDic["notification_type"]  as? String ?? ""
         title = jsonDic["title"] as? String ?? ""
         description = jsonDic["description"]  as? String ?? ""
         isRead = jsonDic["is_read"] as? Bool ?? false
         createdAt = jsonDic["created_at"]  as? String ?? ""
         updatedAt = jsonDic["updated_at"] as? String ?? ""
          
          if let dataNotification = jsonDic["notification_data"] as? [String: Any] {
              let obj = NotificationDetail(jsonDic: dataNotification)
              notificationData = obj
          }
    }
}


class NotificationDetail {
    var to : String
    var data: NotificationData?
    
    init(jsonDic : [String:Any]) {
        to = jsonDic["to"] as? String ?? ""
        
        if let dataNotification = jsonDic["data"] as? [String: Any] {
            let obj = NotificationData(jsonDic: dataNotification)
            data = obj
        }
    }
}


// MARK: - NotificationData
class NotificationData: Codable {
    var message: NotificationMessage?

    init(jsonDic : [String:Any]) {
        
        if let notificationMessage = jsonDic["message"] as? [String: Any] {
            let obj = NotificationMessage(jsonDic: notificationMessage)
            message = obj
        }
    }
}

// MARK: - NotificationMessage
class NotificationMessage: Codable {
    var body: String
    var badge: String
    var title: String
    var notificationType: String
    var voucherId: Int
    var storeId: Int
    var code: String
    var expiryDate: String
    var name: String
    var intReportId: Int
    
    init(jsonDic : [String:Any]) {
        body = jsonDic["body"] as? String ?? ""
        badge = jsonDic["badge"] as? String ?? ""
        title = jsonDic["title"]  as? String ?? ""
        notificationType = jsonDic["notification_type"] as? String ?? ""
        voucherId = jsonDic["voucher_id"] as? Int ?? 0
        storeId = jsonDic["store_id"] as? Int ?? 0
        code = jsonDic["code"] as? String ?? ""
        expiryDate = jsonDic["expiry_date"] as? String ?? ""
        name = jsonDic["name"] as? String ?? ""
        intReportId = jsonDic["report_issue"] as? Int ?? 0
    }
}

