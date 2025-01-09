//
//  HomeProtocol.swift
//  Iceback
//
//  Created by Admin on 12/01/24.
//

import Foundation

protocol TableViewReloadDelegate {
    func reloadTableView()
}

protocol NavigateToStoreDelegate{
    func navigateToStore()
}

protocol NavigateToCashbackDelegate{
    func navigateToCashback()
}

protocol NavigateToProjectDetailsDelegate {
    func navigateToProjectDetails()
}

protocol HomeDetailDelegate {
    func homeDetail(_ homeData: HomeData)
}

protocol HomeShopWithCashbackDelegate {
    func shopWithCashback(_ arrData: [ShopWithCashbackData])
}

protocol HomeSpecialAndVoucherDelegate {
    func specialAndVoucher(_ arrData: [SpecialAndVoucherData])
}

protocol NavigateToStoreDetailDelegate{
    func navigateToStoreDetail(_ storeId: Int, _ dealId: Int, _ isCashBack: Bool, name: String, expiryDate: String, couponCode: String)
}

protocol ReferalProgramDelegate {
    func referalProgram(_ referalProgramData: ReferalProgramData)
}

protocol CashbackProgramDelegate {
    func cashbackProgram(_ cashbackProgramData: ReferalProgramData)
}
