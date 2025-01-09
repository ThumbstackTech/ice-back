//
//  UserProfileManager.swift
//  Iceback
//
//  Created by Admin on 03/05/24.
//

import Foundation
import ObjectMapper

class MyProfileManager {
    
    static let sharedInstance = MyProfileManager()
    
    
    private init() {
        
    }
    
    func getUserProfile(successCompletion:@escaping(UserProfile)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = [:]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().userProfile) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [String: Any] else {
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            let objUserProfile = UserProfile(jsonData: responseData)
            successCompletion(objUserProfile)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }

    //MARK: - Profile PictureURL API call
    func profilePictureURL(param:[String:Any], successCompletion:@escaping(EditProfile)->(),errorCompletion:@escaping(String)->()) {
        
        APIRequestManager.shared.POST(param: param, header: Global.sharedManager.headerParam, withTag: APIPoint().editProfilePicture) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData["data"] as? [String: Any] else {
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            let aboutUsListData = EditProfile(jsonDic: responseData)
            successCompletion(aboutUsListData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Edit Profile API call
    func profileUpate(param:[String:Any], successCompletion:@escaping(String)->(),errorCompletion:@escaping(String)->()) {
        
        APIRequestManager.shared.POST(param: param, header: Global.sharedManager.headerParam, withTag: APIPoint().profileUpdate) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let status = jsonData["status"] as? String, status == "OK" else {
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }

            successCompletion(jsonData[CJsonMessage] as? String ?? AlertMsg.PROFILEUPDATEDSUCCESSFULLY)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    func favouriteStores(intPage: Int,
        successCompletion:@escaping([storeDataListObject])->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["page": intPage,"limit": Global.sharedManager.intStoreAndVouchersPageLimit]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().favouriteStores) { response in
            
            guard let jsonData = response else{
                errorCompletion(DataNoFound)
                return
            }
            
            
            guard let status = jsonData[CJsonStatus] as? String, status == "OK" else{
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else{
                successCompletion([])
                return
            }
            
         
            let arrstores = Mapper<storeDataListObject>().mapArray(JSONObject: responseData)
            successCompletion(arrstores ?? [])
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    func customerSupport(name: String, email: String, message: String, successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let headerParameter = ["Authorization": UserDefaultHelper.acessToken,
                           "accept-language": UserDefaultHelper.selectedLanguage,
                           "X-Requested-With": "XMLHttpRequest"]
        
        
        let dataParam: [String : Any] = ["name": name,
                                         "email": email,
                                         "message": message]
        
        APIRequestManager.shared.POSTMultipart(param: dataParam, withTag: APIPoint().customerSupport, headers: headerParameter, imgData: [:]) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[submissionCreated] as? Bool else {
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
           
            successCompletion(responseData)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
    
    func notificationsList(intPageLimit: Int, successCompletion:@escaping([NotifcationData])->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["limit": Global.sharedManager.intStoreAndVouchersPageLimit,
                                         "page" : intPageLimit]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().notificationsList) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let arrNotifcationData = responseData.map { NotifcationData(jsonDic: $0) }
            successCompletion(arrNotifcationData)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
    
    
    func userActivitiesDelete(successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = [:]
        
        APIRequestManager.shared.DELETE(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().userActivitiesDelete) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let status = jsonData[CJsonStatus] as? String, status == "OK" else{
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            successCompletion(true)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
    
    func userDeleteAccount(successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["user_id": UserDefaultHelper.user_id]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().userDeleteAccount) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let status = jsonData[CJsonStatus] as? String, status == "OK" else{
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            successCompletion(true)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
}
