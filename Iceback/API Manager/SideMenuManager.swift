//
//  SideMenuManager.swift
//  Iceback
//
//  Created by Admin on 29/01/24.
//

import Foundation
import UIKit
import ObjectMapper

class SideMenuManager {
    
    static let sharedInstance = SideMenuManager()
   
    private init() {
        
    }
    
    
    var isStoreTrending = false
    
    var PassEndPont = ""
    
    
    //MARK: - About-Us List API Call
    func aboutUsList(slug: String,  successCompletion:@escaping([PrivacyPolicyDataModel])->(),errorCompletion:@escaping(String)->()) {

        let dataParam: [String : Any] = ["filter[site]":UserDefaultHelper.selectedLanguage, "filter[slug]": slug]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().AboutUs) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let aboutUsListData = responseData.map { PrivacyPolicyDataModel(jsonData: $0) }
            successCompletion(aboutUsListData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
     
}
