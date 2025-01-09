//
//  DealsAndVouchersViewModel.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation

class DealsAndVouchersViewModel {
    
    var dealsAndVouchersDetailDelegate: DealsAndVouchersDetailDelegate!
    var regionListDelegate: RegionListDelegate!
    var newDealsAndVouchersSuccessDelegate: NewDealsAndVouchersSuccessDelegate!
    var newDealsAndVouchersFailureDelegate: NewDealsAndVouchersFailureDelegate!
    var trendingDealsAndVouchersSuccessDelegate: TrendingDealsAndVouchersSuccessDelegate!
    var trendingDealsAndVouchersFailureDelegate: TrendingDealsAndVouchersFailureDelegate!
    
    private var HUD = SVProgress()
    
    //MARK: - Donation Project List
    func dealsAndVoucherDetails(storeId: Int) {
        HUD.show()
        DealsAndVouchersManager.sharedInstance.dealsAndVoucherDetails(storeId: storeId) { [self] success in
            self.HUD.hide()
            dealsAndVouchersDetailDelegate.dealsAndVouchersDetail(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func regionList(isHideLoader: Bool = false) {
        if !isHideLoader {
            HUD.show()
        }
        DealsAndVouchersManager.sharedInstance.regionList() { [self] success in
            self.HUD.hide()
            regionListDelegate.regionList(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    
    func newDealsAndVouchers(categories: String, currentPage: Int, search: String, storeId: Int) {
        if currentPage == 1 {
            HUD.show()
        }
        DealsAndVouchersManager.sharedInstance.newDealsAndVouchers(categories: categories, currentPage: currentPage, search: search, storeId: storeId) { [self] success in
            if currentPage == 1 {
                self.HUD.hide()
            }
            newDealsAndVouchersSuccessDelegate.newDealsAndVouchersSuccess(success)
        } errorCompletion: { [self] error in
            if currentPage == 1 {
                self.HUD.hide()
            }
            newDealsAndVouchersFailureDelegate.newDealsAndVouchersFailure(true)
        }
    }
    
    func trendingDealsAndVouchers(categories: String, currentPage: Int, search: String, storeId: Int) {
        if currentPage == 1 {
            HUD.show()
        }
        DealsAndVouchersManager.sharedInstance.trendingDealsAndVouchers(categories: categories, currentPage: currentPage, search: search, storeId: storeId) { [self] success in
            if currentPage == 1 {
                self.HUD.hide()
            }
            trendingDealsAndVouchersSuccessDelegate.trendingDealsAndVouchersSuccess(success)
        } errorCompletion: { [self] error in
            if currentPage == 1 {
                self.HUD.hide()
            }
            trendingDealsAndVouchersFailureDelegate.trendingDealsAndVouchersFailure(true)
        }
    }
}
