//
//  FilterManager.swift
//  Iceback
//
//  Created by APPLE on 19/01/24.
//

import Foundation
import UIKit
import ObjectMapper

class FilterManager {
    
    static let sharedInstance = FilterManager()
    
    private init(){
    }
    
    let headerParam = ["Authorization": guestLoginBearerToken,
                       "accept-language": UserDefaultHelper.selectedLanguage]
    
    
    //MARK: - Region List API Call
    func getRegionList(successCompletion: @escaping([FilterRegionDataObject])->(), errorCompletion: @escaping(String)->()) {
        
        
        APIRequestManager.shared.GET(param: [:], header: headerParam, withTag: APIPoint().regionList) { response in
            guard let jsonData = response else{
                return
            }
            
            guard let status = jsonData[CJsonStatus] as? String, status == "OK" else{
                successCompletion([])
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else{
                successCompletion([])
                return
            }

            let arrRegionLists = Mapper<FilterRegionDataObject>().mapArray(JSONObject: responseData)
            successCompletion(arrRegionLists ?? [])
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Category List API Call
    func getCategoryList(successCompletion: @escaping([FilterCategoriesData])->(), errorCompletion: @escaping(String)->()){
        
        let dataParams: [String: Any] = ["language": UserDefaultHelper.selectedLanguage]
        
        APIRequestManager.shared.GET(param: dataParams, header: headerParam, withTag: APIPoint().categoryLists) { response in
            guard let jsonData = response else{
                successCompletion([])
                return
            }
            
            guard let status = jsonData[CJsonStatus] as? String, status == "OK" else{
                successCompletion([])
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else{
                successCompletion([])
                return
            }

            let categoriesListData = responseData.map { FilterCategoriesData(jsonData: $0) }
            successCompletion(categoriesListData)
          
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    
    //MARK: - Get All Store Name API Call
    func getAllStoreName(param: [String: Any],successCompletion: @escaping([AllStoreData])->(), errorCompletion: @escaping(String)->()){
        
        APIRequestManager.shared.POST(param: param, header: Global.sharedManager.headerParam, withTag: APIPoint().getAllStoreName) { response in
            
            guard let jsonData = response else{
                return
            }
            
            guard let status = jsonData[CJsonStatus] as? String, status == "OK" else{
                successCompletion([])
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else{
                successCompletion([])
                return
            }
         
            let arrGetAllStoreName = responseData.map {AllStoreData(jsonData: $0)}
            successCompletion(arrGetAllStoreName)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
}

