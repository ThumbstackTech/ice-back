//
//  StoresModel.swift
//  Iceback
//
//  Created by APPLE on 17/01/24.
//

import Foundation

class StoresModel {
    
    var cashbackPercentage  : Double
    var couponimage : String
        
    
    init(cashbackPercentage: Double, couponimage: String) {
        self.cashbackPercentage = cashbackPercentage
        self.couponimage = couponimage
    }
}
