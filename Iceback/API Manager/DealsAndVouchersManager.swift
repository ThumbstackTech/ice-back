//
//  DealsAndVouchersManager.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation

class DealsAndVouchersManager {
    
    static let sharedInstance = DealsAndVouchersManager()
    
    private init(){
    }
    
    //MARK: - Deals And Voucher Details API Call
    func dealsAndVoucherDetails(storeId: Int, successCompletion: @escaping(DealsAndVoucherDetailData)->(), errorCompletion: @escaping(String)->()) {
        
        let dataParam: [String : Any] = [:]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: "\(APIPoint().dealsAndVoucherDetail)\(storeId)") { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [String: Any] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let dealsAndVoucherDetailData = DealsAndVoucherDetailData(jsonData: responseData)
            successCompletion(dealsAndVoucherDetailData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    
    //MARK: - Region List API Call
    func regionList(successCompletion: @escaping([RegionData])->(), errorCompletion: @escaping(String)->()) {
        
        let dataParam: [String : Any] = [:]
        let headerParameter = ["Authorization": guestLoginBearerToken]
        
        APIRequestManager.shared.GET(param: dataParam, header: headerParameter, withTag: APIPoint().regionList) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let regionListData = responseData.map { RegionData(jsonData: $0) }
            successCompletion(regionListData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - New Deals And Vouchers List API Call
    func newDealsAndVouchers(categories: String, currentPage: Int, search: String, storeId: Int, successCompletion: @escaping([DealsAndVouchersData])->(), errorCompletion: @escaping(String)->()) {
        
        let dataParam: [String : Any] = ["categories": categories,
                                         "limit": Global.sharedManager.intStoreAndVouchersPageLimit,
                                         "page": currentPage,
                                         "search": search,
                                         "store_id": storeId]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().newDealsAndVoucher) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let arrDealsAndVouchers = responseData.map { DealsAndVouchersData(jsonData: $0) }
            successCompletion(arrDealsAndVouchers)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
    
    //MARK: - Trending Deals And Vouchers List API Call
    func trendingDealsAndVouchers(categories: String, currentPage: Int, search: String, storeId: Int, successCompletion: @escaping([DealsAndVouchersData])->(), errorCompletion: @escaping(String)->()) {
        
        let dataParam: [String : Any] = ["categories": categories,
                                         "limit": Global.sharedManager.intStoreAndVouchersPageLimit,
                                         "page": currentPage,
                                         "search": search,
                                         "store_id": storeId]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().trendingDealsAndVoucher) { response in
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let arrDealsAndVouchers = responseData.map { DealsAndVouchersData(jsonData: $0) }
            successCompletion(arrDealsAndVouchers)
        } failureCallBack: { error in
            errorCompletion(error.debugDescription)
        }
    }
}
