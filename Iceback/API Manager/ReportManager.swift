//
//  ReportManager.swift
//  Iceback
//
//  Created by apple on 15/04/24.
//

import Foundation

class ReportManager {
    
    static let sharedInstance = ReportManager()
   
    private init() {
        
    }
    
    var isStoreTrending = false
    
    var PassEndPont = ""
    
    //MARK: - CreateReport Api call
    func createReport(param:[String:Any], successCompletion:@escaping(ReportListData)->(),errorCompletion:@escaping(String)->()) {

            APIRequestManager.shared.POST(param: param, header: Global.sharedManager.headerParam, withTag: APIPoint().createReport) { response in

                guard let jsonData = response else {
                    errorCompletion(DataNoFound)
                    return
                }
                
                guard let responseData = jsonData[CJsonData] as? [String: Any] else {
                    errorCompletion(DataNoFound)
                    return
                }

                let aboutUsListData = ReportListData(jsonDic: responseData)
                successCompletion(aboutUsListData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    //start- 19-4-24
    //MARK: - ReportList Api call
    func reportList(pageCount: Int, successCompletion:@escaping([ReportListData])->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = ["page": pageCount, "limit": Global.sharedManager.intPaginationLimit]

        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().reportList) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]]else {
                successCompletion([])
                return
            }

            let arrReportList = responseData.map { ReportListData(jsonDic: $0) }
            successCompletion(arrReportList)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    } // end - 19-4-24
    
    //MARK: - reportView Api call
    func reportView(param:[String:Any], successCompletion: @escaping([ReportListData])->(), errorCompletion: @escaping(String)->()) {

            APIRequestManager.shared.POST(param: param, header: Global.sharedManager.headerParam, withTag: APIPoint().viewReport) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let aboutUsListData = responseData.map { ReportListData(jsonDic: $0) }
            successCompletion(aboutUsListData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
}
