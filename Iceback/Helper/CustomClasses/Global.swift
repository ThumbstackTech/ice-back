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

enum DateFormat {
   static let FullDateHHMMSS = "yyyy-MM-dd HH:mm:ss"
   static let FullDateHHMM = "dd/MM/yyyy - HH:mm"
   static let FullDateHHMMSSZZZ = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
   static let DDMMYYYY = "dd-MMM-yyyy"
}

enum ValidationMessages {
   static let EnableCamera = "Enable permissions to access your photos for sending photos."
}

enum Language {
   enum Name {
      static let English = "English"
      static let German = "German"
   }
   
   enum Code {
      static let English = "en"
      static let German = "de"
   }
}

enum TransactionStatus {
   static let Approved = "approved"
}

enum ActivityTitle {
   static let Deal = "Deal"
   static let Shop = "Shop"
   static let Date = "Date"
}

enum StoresTypes {
  static let All = "All"
  static let Trending = "Trending"
  static let New = "New"
}

enum DealsTypes {
  static let All = "All"
  static let Trending = "Trending"
  static let New = "New"
}
