//
//  CustomerSupportViewModel.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation

class CustomSideMenuViewModel {
    
    private var HUD = SVProgress()
    
  
    var abourUsDelegate : AboutUsDelegate!

    
    //MARK: - AboutUs
    func abousUs(slug: String) {
        HUD.show()
        SideMenuManager.sharedInstance.aboutUsList(slug: slug) { [self] success in
            self.HUD.hide()
            abourUsDelegate.aboutUsDelegate(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    
}

