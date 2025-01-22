//
//  HomeManager.swift
//  Iceback
//
//  Created by Admin on 19/01/24.
//

import Foundation

class HomeManager {
    
    static let sharedInstance = HomeManager()
    let noOfData = 2
    
    private init(){
    }
        
    //MARK: - Home Detail API Call
    func homeDetails(successCompletion: @escaping(HomeModel)->(), errorCompletion: @escaping(String)->()) {
                
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,
                         "filter[slug]": "home-page"]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().home) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData as? [String: Any] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let homeData = HomeModel(jsonData: responseData)
            successCompletion(homeData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    
    //MARK: - Home Shop With Cashback List API Call
    func homeShopCashback(successCompletion: @escaping([ShopWithCashbackData])->(), errorCompletion: @escaping(String)->()) {
                
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,
                         "limit": noOfData]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().shopWithCashback) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let arrShopWithCashback = responseData.map { ShopWithCashbackData(jsonData: $0) }
            successCompletion(arrShopWithCashback)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
    
    //MARK: - Home Special Vouchers List API Call
    func homeSpecialVouchers(successCompletion: @escaping([SpecialAndVoucherData])->(), errorCompletion: @escaping(String)->()) {
                
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,
                         "limit": noOfData]
       
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().specialAndVouchers) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let arrSpecialAndvoucher = responseData.map { SpecialAndVoucherData(jsonData: $0) }
            successCompletion(arrSpecialAndvoucher)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Referal Program API Call
    func referalProgram(successCompletion: @escaping(ReferalProgramModel)->(), errorCompletion: @escaping(String)->()) {
                
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,
                         "filter[slug]": "referral-program"]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().home) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData as? [String: Any] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let homeData = ReferalProgramModel(jsonData: responseData)
            successCompletion(homeData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Cashback Program API Call
    func cashbackProgram(successCompletion: @escaping(ReferalProgramModel)->(), errorCompletion: @escaping(String)->()) {
                
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,
                         "filter[slug:is]": "was-ist-cashback"]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().cashbackProgram) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData as? [String: Any] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let homeData = ReferalProgramModel(jsonData: responseData)
            successCompletion(homeData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
}
