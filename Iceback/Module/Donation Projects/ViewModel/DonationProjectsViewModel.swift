//
//  DonationProjectsViewModel.swift
//  Iceback
//
//  Created by Admin on 19/01/24.
//

import Foundation

class DonationProjectsViewModel {
    
    //MARK: - Constant & Variables
    private var HUD = SVProgress()
    
    var donationProjectsListDelegate: DonationProjectsListDelegate!
    var donationDelegate: DonationDelegate!
    
    //MARK: - Donation Project List
    func donationProjectsList(pageCount: Int, limitCount: Int) {
        HUD.show()
        DonationProjectsManager.sharedInstance.donationProjects(pageCount: pageCount, limit: limitCount) { [self] success in
            self.HUD.hide()
            donationProjectsListDelegate.DonationProjectsListSuccess(success.data, totalData: success.meta?.total ?? 0, pageLimit: success.meta?.perPage ?? 0)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    
    //MARK: - Donation API Call
    func donation() {
        HUD.show()
        DonationProjectsManager.sharedInstance.donation() { [self] success in
            self.HUD.hide()
            donationDelegate.donation(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
}
