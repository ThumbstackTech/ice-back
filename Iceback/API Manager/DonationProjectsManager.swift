//
//  DonationProjectsManager.swift
//  Iceback
//
//  Created by Admin on 19/01/24.
//

import Foundation

class DonationProjectsManager {
    
    static let sharedInstance = DonationProjectsManager()
    
    private init(){
    }
    
    //MARK: - Donation Projects API Call
    func donationProjects(pageCount: Int, limit: Int, successCompletion:@escaping(DonationProjectsModel)->(),errorCompletion:@escaping(String)->()) {
                
        let dataParam: [String : Any] = ["filter[site]": UserDefaultHelper.selectedLanguage,
                                         "page": pageCount, "limit": limit]
        
        APIRequestManager.shared.GET(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().donationProjects) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData as? [String: Any] else {
                errorCompletion(DataNoFound)
                return
            }
            
            let donationProjectData = DonationProjectsModel(jsonData: responseData)
            successCompletion(donationProjectData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Donation API Call
    func donation(successCompletion:@escaping([DonationData])->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String : Any] = [:]
        let headerParameter = ["Authorization": guestLoginBearerToken]
        
        APIRequestManager.shared.GET(param: dataParam, header: headerParameter, withTag: APIPoint().projectDonation) { response in
            
            guard let jsonData = response else {
                errorCompletion(DataNoFound)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? [[String: Any]] else {
                successCompletion([])
                return
            }
            
            let donationData = responseData.map { DonationData(jsonData: $0) }
            successCompletion(donationData)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
}
