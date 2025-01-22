//
//  ExtensionUIApplication.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension of UIApplication For getting the TopMostViewController(UIViewController) of Application.
extension UIApplication {
    
    /// A Computed Property (only getter) of UIViewController For getting the TopMostViewController(UIViewController) of Application. For using this property you must have instance of UIApplication Like this:(UIApplication.shared).
    var topMostViewController:UIViewController {
        
        
       var top = appDelegate.window!.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top!
        
    }
    
}
