//
//  ProgressHUD.swift
//  HealthLayby
//
//  Created by CMR010 on 27/06/23.
//

import Foundation
import SVProgressHUD
class SVProgress{
    static let shared = SVProgress()
    
     init() {
    }
    func show(){
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(.appEFF8FF)
        SVProgressHUD.setForegroundColor(.app1F8DFF)
        SVProgressHUD.show()
    }
    func hide(){
        SVProgressHUD.dismiss()
    }
}
