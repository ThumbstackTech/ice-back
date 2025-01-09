//
//  StoresViewModel.swift
//  Iceback
//
//  Created by Admin on 24/01/24.
//

import Foundation

class StoresViewModel {
    
    var StoreDetails: StoreDetailsNewModel!
    var SimilarStores: [SimilarStoresModel] = []
    
    var StoresListDelegate:StoresListDelegate!
    var StoresFailureHandleDelegate : StoresFailureHandleDelegate!
    var StoreDetailsDelegate: StoreDetailsDelegate!
    var specialDealsAndVoucherDelegate: SpecialDealsAndVoucherDelegate!
    var regionListDelegate: RegionListDelegate!
    var favouriteStoreAddDelegate: FavouriteStoreAddDelegate!
    var favouriteStoreRemoveDelegate: FavouriteStoreRemoveDelegate!
    
    var isStoreTrending = false
    private var HUD = SVProgress()
    
    //MARK: - StoresLists
    func StoresLists(page:Int, regions:[Int], categories:[Int], search:String, isNewStore: Bool = false, sortbycashbackpercentage: String, sortbyname: String){
        
        if page == 1 {
            HUD.show()
        }
      
        
        var param: [String : Any] = ["page":page, "limit":Global.sharedManager.intStoreAndVouchersPageLimit]
            
        if !categories.isEmpty {
            param["categories"] = "\(categories)"
        }
        
        if !regions.isEmpty {
            param["regions"] = "\(regions)"
        }
        
        if !search.isEmpty {
            param["search"] = "\(search)"
        }
        
        if isNewStore {
            param["newStore"] = "1"
        }
        
        if !sortbycashbackpercentage.isEmpty {
            param["sortbycashbackpercentage"] = sortbycashbackpercentage
        }
        
        if !sortbyname.isEmpty {
            param["sortbyname"] = sortbyname
        }
        
            print("param",param)
            
            StoresManager.sharedInstance.isStoreTrending = isStoreTrending == true ? true : false
            
            StoresManager.sharedInstance.storeListsAPICall(param:param) { [self] response in
                if page == 1 {
                    self.HUD.hide()
                }
               
                StoresListDelegate.StoresLists(arrstores: response)
             
            } errorCompletion: { [self] error in
                if page == 1 {
                    self.HUD.hide()
                }
                StoresFailureHandleDelegate.StoreFailureHandler(isFailure: true)
                
            }
    

    }
    
    //MARK: - Home Detail Data
    func StoreDetailsData(storeId: Int, isHideLoader: Bool = false) {
        if !isHideLoader {
            HUD.show()
        }
        StoresManager.sharedInstance.StoreDetails(storeId: storeId) { [self] success in
            StoreDetailsDelegate.StoreDetails(success)
        } errorCompletion: { [self] error in
            if !isHideLoader {
                self.HUD.hide()
            }
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func specialDealsAndVouchers(specialId: Int) {
//        HUD.show()
        
        StoresManager.sharedInstance.specialDealsAndVouchers(specialId: specialId) { [self] success in
            self.HUD.hide()
            specialDealsAndVoucherDelegate.specialDealsAndVoucher(success)
        } errorCompletion: {  [self] error in
                self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func favouriteStoreAdd(storeId: Int, intIndex: Int) {
        HUD.show()
        
        StoresManager.sharedInstance.favouriteStoreAdd(storeId: storeId) { [self] success in
            self.HUD.hide()
            favouriteStoreAddDelegate.favouriteStoreAddSuccess(success, intIndex: intIndex)
        } errorCompletion: {  [self] error in
                self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func favouriteStoreRemove(storeId: Int,  intIndex: Int) {
        HUD.show()
        
        StoresManager.sharedInstance.favouriteStoreRemove(storeId: storeId) { [self] success in
            self.HUD.hide()
            favouriteStoreRemoveDelegate.favouriteStoreRemoveSuccess(success, intIndex: intIndex)
        } errorCompletion: {  [self] error in
                self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }

}
