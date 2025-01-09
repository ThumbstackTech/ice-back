//
//  StoresManager.swift
//  Iceback
//
//  Created by APPLE on 23/01/24.
//

import Foundation
import UIKit
import ObjectMapper

class StoresManager {
    
    static let sharedInstance = StoresManager()
   
    private init() {
        
    }
    
    
    var isStoreTrending = false
    
    var PassEndPont = ""
    
    //MARK: - POST store List API call
    func storeListsAPICall(param: [String: Any],successCompletion: @escaping([storeDataListObject])->(), errorCompletion: @escaping(String)->()){
        
        PassEndPont = isStoreTrending == true ? APIPoint().StoreTrendingLists : APIPoint().StoreLists
        
        APIRequestManager.shared.POST(param: param, header: Global.sharedManager.headerParam, withTag: PassEndPont) { response in
            
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
            
         
            let arrstores = Mapper<storeDataListObject>().mapArray(JSONObject: responseData)
            successCompletion(arrstores ?? [])
            
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
        
        
    }

    
    //MARK: - Get Store Details API Call
    func StoreDetails(storeId: Int,
        successCompletion:@escaping(StoreDetailsNewModel)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: "\(APIPoint().getStoreDetails)\(storeId)") { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [String: Any] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let StoreDetailsData = StoreDetailsNewModel(jsonData: responseData)
            successCompletion(StoreDetailsData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    func specialDealsAndVouchers(specialId: Int,
        successCompletion:@escaping([DealsAndVouchersData])->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,"store_id": specialId,"limit": 50, "page": 1]
        
      
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().getSimilarStoresDetails) { response in
            
            guard let data = response else{
                successCompletion([])
                return
            }
            
            guard let responseData = data[CJsonData] as? [[String: Any]] else{
                successCompletion([])
                return
            }

            let arrSimilarStore = responseData.map {DealsAndVouchersData(jsonData: $0)}
            successCompletion(arrSimilarStore)
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    func favouriteStoreAdd(storeId: Int,
        successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["store_id": storeId]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().favouriteStoresAdd) { response in
            
            guard let data = response else{
                errorCompletion(DataNoFound)
                return
            }
            
            guard let status = data[CJsonStatus] as? String, status == "OK" else{
                errorCompletion(data[CJsonData] as! String)
                return
            }

            successCompletion(true)
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    func favouriteStoreRemove(storeId: Int,
        successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["store_id": storeId]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().favouriteStoresRemove) { response in
            
            guard let data = response else{
                errorCompletion(DataNoFound)
                return
            }
            
            guard let status = data[CJsonStatus] as? String, status == "OK" else{
                errorCompletion(data[CJsonData] as! String)
                return
            }

            successCompletion(true)
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
}
