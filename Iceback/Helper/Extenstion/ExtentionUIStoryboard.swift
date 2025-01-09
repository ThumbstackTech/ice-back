//
//  ExtentionUIStoryboard.swift
//  Spot-O
//
//  Created by CMR010 on 16/10/20.
//  Copyright © 2020 Hitesh Baldaniya. All rights reserved.
//

import Foundation
import UIKit

struct POPUpView {
    
    let contentSizeInPopup = CGSize(width: 580.deviceMaxHeight(), height: 440.deviceMaxHeight())
    let contentSizeFeedbackPopup = CGSize(width: 580.deviceMaxHeight(), height: 550.deviceMaxHeight())
    let contentMediumSizeInPopup = CGSize(width: 822.deviceMaxHeight(), height: 676.deviceMaxHeight())
    let contentFullSizeInPopup = CGSize(width: 839.deviceMaxHeight(), height: 381.deviceMaxHeight())
    let contentFullSizeInWorkOutSetsVC = CGSize(width: 839.deviceMaxHeight(), height: 560.deviceMaxHeight())
    let contentHalfSizeInTopPopup = CGSize(width: UIScreen.main.bounds.width, height: 374.deviceMaxHeight())
    let corner10 : CGFloat = 10.0
}

enum AppStoryboard: String {
    
    case main                   = "Main"
    case reportIssue            = "ReportIssue"
    case home                   = "Home"
    case stores                 = "Stores"
    case profile                = "Profile"
    case deals                  = "DealsAndVouchers"
    case sideMenu               = "SideMenu"
    case donationProjects       = "DonationProjects"
    
}

extension UIViewController {
    
    class func instantiate<T: UIViewController>(appStoryboard: AppStoryboard) -> T {
        
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
