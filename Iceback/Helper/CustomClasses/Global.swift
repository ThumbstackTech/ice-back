//
//  HearderParams.swift
//  Iceback
//
//  Created by Admin on 13/05/24.
//

import Foundation

class Global {
    
    //MARK: - Shared Instance
    private static var sharedInstance: Global?
    
    //MARK: - Shared Manager
    class var sharedManager : Global {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = Global()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    private init() {}
    
    //MARK: - Header Parameter
    let headerParam = ["Authorization": UserDefaultHelper.acessToken,
                       "accept-language": UserDefaultHelper.selectedLanguage,
                       "accept": "application/json"]
    
    let intStoreAndVouchersPageLimit = 50
    let intPaginationLimit = 20
    let isLive: Bool = true
    
    //MARK: - Destroy Shared Manager
    class func destroySharedManager() {
        sharedInstance = nil
    }
}
