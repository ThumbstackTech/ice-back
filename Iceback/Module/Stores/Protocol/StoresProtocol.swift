//
//  StoresProtocol.swift
//  Iceback
//
//  Created by Admin on 12/01/24.
//

import Foundation


protocol SortByDelegate{
    func sortBy(sort:String,intPrevius:Int)
}

protocol StoresListDelegate{
    func StoresLists(arrstores: [storeDataListObject])
}


protocol StoresFailureHandleDelegate{
    func StoreFailureHandler(isFailure: Bool)
}

protocol StoreDetailsDelegate {
    func StoreDetails(_ objData: StoreDetailsNewModel)
}

protocol SpecialDealsAndVoucherDelegate {
    func specialDealsAndVoucher(_ arrData: [DealsAndVouchersData])
}

protocol FavouriteStoreAddDelegate {
    func favouriteStoreAddSuccess(_ isSuccess: Bool,  intIndex: Int)
}

protocol FavouriteStoreRemoveDelegate {
    func favouriteStoreRemoveSuccess(_ isSuccess: Bool,  intIndex: Int)
}



