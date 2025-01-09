//
//  FilterViewModel.swift
//  Iceback
//
//  Created by APPLE on 24/01/24.
//

import Foundation

class FilterViewModel{
    
    private var HUD = SVProgress()
    
    var FilterRegionDelegate:FilterRegionDelegate!
    var FilterCategoryDelegate:FilterCategoryDelegate!
    var getAllStoreNameDelegate: GetAllStoreNameDelegate!
    
    //MARK: -FilterRegionLists
    func getFilterRegionLists(){
        HUD.show()
        FilterManager.sharedInstance.getRegionList { [self] response in
            HUD.hide()
            FilterRegionDelegate.getFilterRegionLists(arrFilterRegion: response)
            
        } errorCompletion: { [self] error in
            HUD.hide()
            PPAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
        }
    }
    
    
    //MARK: -FilterCategoryLists
    func getFilterCategoryLists(){
        HUD.show()
        FilterManager.sharedInstance.getCategoryList { [self] response in
            HUD.hide()
            
            FilterCategoryDelegate.getFilterCategoryLists(arrCaetgoryRegion: response)
            
            
        } errorCompletion: { [self] error in
            HUD.hide()
            PPAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
        }
    }
    
    
    func getAllStoreName(){
        HUD.show()
        
        let params: [String: Any] = [:]
        FilterManager.sharedInstance.getAllStoreName(param: params) { [self] response in
            HUD.hide()
            getAllStoreNameDelegate.getAllStoreNameSuccess(response)
        } errorCompletion: { [self] error in
            HUD.hide()
            PPAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
        }
    }
    
}
