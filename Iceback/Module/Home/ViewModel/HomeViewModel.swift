//
//  HomeViewModel.swift
//  Iceback
//
//  Created by Admin on 19/01/24.
//

class HomeViewModel {
    
    //MARK: - Constant & Variables
    private var HUD = SVProgress()
    
    var homeDetailDelegate: HomeDetailDelegate!
    var homeShopWithCashbackDelegate: HomeShopWithCashbackDelegate!
    var homeSpecialAndVoucherDelegate: HomeSpecialAndVoucherDelegate!
    var referalProgramDelegate: ReferalProgramDelegate!
    var cashbackProgramDelegate: CashbackProgramDelegate!
    
    //MARK: - Home Detail API
    func homeDetailData() {
        HUD.show()
        
        HomeManager.sharedInstance.homeDetails() { [self] success in
            self.HUD.hide()
            homeDetailDelegate.homeDetail(success.data.first ?? HomeData(jsonData: [:]))
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: - Home Shop With Cashback API
    func homeShopWithCashback() {
        HomeManager.sharedInstance.homeShopCashback() { [self] success in
            homeShopWithCashbackDelegate.shopWithCashback(success)
        } errorCompletion: { error in
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: - Home Special And Voucher API
    func homeSpecialAndVoucher() {
        HomeManager.sharedInstance.homeSpecialVouchers() { [self] success in
            self.HUD.hide()
            homeSpecialAndVoucherDelegate.specialAndVoucher(success)
        } errorCompletion: { error in
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: - Referal Program API
    func referalProgram() {
        HUD.show()
        
        HomeManager.sharedInstance.referalProgram() { [self] success in
            self.HUD.hide()
            referalProgramDelegate.referalProgram(success.data.first ?? ReferalProgramData(jsonData: [:]))
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: - Cashback Program API
    func cashbackProgram() {
        HUD.show()
        
        HomeManager.sharedInstance.cashbackProgram() { [self] success in
            self.HUD.hide()
            cashbackProgramDelegate.cashbackProgram(success.data.first ?? ReferalProgramData(jsonData: [:]))
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
}
