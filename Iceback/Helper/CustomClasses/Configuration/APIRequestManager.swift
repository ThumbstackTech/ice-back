//
//  APIRequestManager.swift
//  HealthLayby
//
//  Created by CMR010 on 19/06/23.
//

import Foundation
import UIKit

//MARK: API EndPoints
struct APIPoint {
   
    //Account Module
    let donationProjects          = "/stat_api/collections/climate_projects/entries"
    let home                      = "/stat_api/collections/pages/entries/"
    let shopWithCashback          = "/api/stores_popularities"
    let specialAndVouchers        = "/api/stores/popular_deals"
    let customerSupport           = "/!/forms/contact_form"
    let dealsAndVoucherDetail     = "/api/stores/"
    let regionList                = "/api/stores-regions"
    let getStoreDetails           = "/api/stores/"
    let getSimilarStoresDetails   = "/api/stores/special_deals"
    let newDealsAndVoucher        = "/api/stores/special_deals"
    let trendingDealsAndVoucher   = "/api/stores/special_deals/trending_mobile"
    let categoryLists             = "/api/stores-categories"
    let StoreLists                = "/api/stores"
    let StoreTrendingLists        = "/api/stores/trending"
    let AboutUs                   = "/stat_api/collections/pages/entries"
    let projectDonation           = "/api/project_donations"
    let cashbackProgram           = "/stat_api/collections/blog_posts/entries"
    let notifications             = "/api/users/notifications"
    let notificationsList         = "/api/notification-list"
    let userProfile               = "/api/users/profile"
    let createReport              = "/api/create-report"
    let reportList                = "/api/report-list"
    let viewReport                = "/api/report-view"
    let userExist                 = "/api/user-exists"
    let mobileAwsTokens           = "/api/mobileAwsTokens"
    let favouriteStoresAdd        = "/api/users/favourite_stores/add"
    let favouriteStoresRemove     = "/api/users/favourite_stores/remove"
    let favouriteStores           = "/api/users/favourite_stores"
    let editProfilePicture        = "/api/users/profilePictureUrl"
    let profileUpdate             = "/api/users/profile/update"
    let userActivitiesDelete      = "/api/users/activities/delete"
    let registerDeviceToken       = "/api/store-device"
    let deRegisterDeviceToken     = "/api/remove-device"
    let userDeleteAccount         = "/api/user_delete"
    let getAllStoreName           = "/api/stores/getAllStoreName"
    let welcomeMail               = "/api/welcome-mail"
}

//MARK: APIRequest Class

class APIRequestManager {
    
    typealias ClosureCompletion = (_ response: AnyObject?, _ error: NSError?) -> Void
    typealias successCallBack = ((AnyObject?) -> ())
    typealias failureCallBack = ((String) -> ())
    
    var statusCode: Int = 0
    static let shared = APIRequestManager()
    
    private init(){}
    
    func appendStatusCodeToResponse(response: AnyObject?) -> [String : AnyObject]? {
        if let dicResponse = response as? [String: AnyObject] {
            return dicResponse
        }
        
        return [CJsonCode:statusCode as AnyObject]
    }
    
    func appendStatusCodeToArrResponse(response: AnyObject?) -> [[String : AnyObject]]? {
        if let dicResponse = response as? [[String: AnyObject]] {
            return dicResponse
        }
        
        return [[CJsonCode:statusCode as AnyObject]]
    }
    
    func appendStatusCodeToResponse(response: AnyObject?, statusCode: Int) -> [String : AnyObject]? {
        if var dicResponse = response as? [String: AnyObject]{
            dicResponse[CJsonCode] = statusCode as AnyObject
            return dicResponse
        }
        
        return [CJsonCode: statusCode as AnyObject]
    }
    
    //MARK: GET Method
    func GET(param: [String: Any]?, header: [String: String], withTag apiPoint: String, successCallBack: @escaping successCallBack, failureCallBack: @escaping failureCallBack){
        if Reachability.isConnectedToNetwork() == false {
            PPAlerts().showAlert(with: .adefault, withMessage: KNoInternet)
            GCDMainThread.async {
            }
            return
        }
        
        _ = Networking.sharedInstance.GET(param: param, header: header, tag: apiPoint, success: { (task, response, statusCode) in
            if let dictResponse = response {
                if let response = self.appendStatusCodeToResponse(response: dictResponse, statusCode: statusCode) {
                    successCallBack(dictResponse)
                }
            }
        }) { (task, error) in
            if error?.code == -1005 {
                self.GET(param: param, header: header, withTag: apiPoint, successCallBack: successCallBack, failureCallBack: failureCallBack)
                return
            }
            
            failureCallBack((error?.localizedDescription) ?? kSomethingWrongAlert)
        }
    }
    
    //MARK: POST Method
    func POST(param: [String: Any]?, header: [String: String], withTag apiPoint: String, successCallBack: @escaping successCallBack, failureCallBack: @escaping failureCallBack) {
        
        if Reachability.isConnectedToNetwork() == false {
            PPAlerts().showAlert(with: .adefault, withMessage: KNoInternet)
            GCDMainThread.async {
            }
            return
        }
        
        _ = Networking.sharedInstance.requestPOSTURL(param: param, header: header, tag: apiPoint, success: { (task, response, statusCode) in
            if let dictResponse = response {
                if let response = self.appendStatusCodeToResponse(response: dictResponse, statusCode: statusCode) {
                    successCallBack(dictResponse)
                }
            }
        }) { (task, error) in
            if error?.code == -1005 {
                self.POST(param: param, header: header, withTag: apiPoint, successCallBack: successCallBack, failureCallBack: failureCallBack)
                return
            }
            
            if let error = error {
                failureCallBack(error.localizedDescription)
//                failureCallBack(error)
            } else {
                failureCallBack(kSomethingWrongAlert)
            }
        }
    }
    
    func POSTMultipart(param: [String: Any]?, withTag apiPoint: String, headers: [String: String], imgData: [String: Data]?, successCallBack: @escaping successCallBack, failureCallBack: @escaping failureCallBack) {
        
        if Reachability.isConnectedToNetwork() == false {
            PPAlerts().showAlert(with: .adefault, withMessage: KNoInternet)
            GCDMainThread.async {
              //  LoadingOverlay.shared.hideOverlayView()
            }
            return
        }
        
        Networking.sharedInstance.requestPOSTImage(param: param, tag: apiPoint, imgData: imgData, headers: headers, multipartFormData: { (response) in
            print("POSTMultipart response -", response)
        }, success: { (task, response, statusCode) in
            if let dictResponse = response {
                if let response = self.appendStatusCodeToResponse(response: dictResponse, statusCode: statusCode) {
                    successCallBack(dictResponse)
                }
            }
        }) { (task, error) in
            if error?.code == -1005 {
                self.POSTMultipart(param: param, withTag: apiPoint, headers: headers, imgData: imgData, successCallBack: successCallBack, failureCallBack: failureCallBack)
                return
            }
            
            failureCallBack((error?.localizedDescription) ?? kSomethingWrongAlert)
        }
    }
    
    
    //MARK: DELETE Method
    func DELETE(param: [String: Any]?, header: [String: String], withTag apiPoint: String, successCallBack: @escaping successCallBack, failureCallBack: @escaping failureCallBack) {
        
        if Reachability.isConnectedToNetwork() == false {
            PPAlerts().showAlert(with: .adefault, withMessage: KNoInternet)
            GCDMainThread.async {
            }
            return
        }
        
        _ = Networking.sharedInstance.requestDELETEURL(param: param, header: header, tag: apiPoint, success: { (task, response, statusCode) in
            if let dictResponse = response {
                if let response = self.appendStatusCodeToResponse(response: dictResponse, statusCode: statusCode) {
                    successCallBack(dictResponse)
                }
            }
        }) { (task, error) in
            if error?.code == -1005 {
                self.DELETE(param: param, header: header, withTag: apiPoint, successCallBack: successCallBack, failureCallBack: failureCallBack)
                return
            }
            
            if let error = error {
                failureCallBack(error.localizedDescription)
            } else {
                failureCallBack(kSomethingWrongAlert)
            }
        }
    }

}

