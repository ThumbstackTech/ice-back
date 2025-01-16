//
//  ExtensionUINavigationController.swift
//  Spot-O
//
//  Created by macmini on 10/29/20.
//  Copyright © 2020 Hitesh Baldaniya. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    //MARK: - Remove View Controller
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
    
    //MARK: - Navigation Fade Animation
    func fadeTo(_ viewController: UIViewController, animated: Bool) {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
        appDelegate.window?.rootViewController = self
    }
    
    //MARK: - Navigate To ViewController
    func navigateToViewController<T: UIViewController>(type: T.Type, animated: Bool, storyboard: AppStoryboard) {
        for controller in self.viewControllers {
            if controller.isKind(of: type) {
               dPrint("INSIDE CONTROLLER NAME: \(controller)")
                self.popToViewController(controller, animated: animated)
                return
            }
        }
        
        let vc = T.instantiate(appStoryboard: storyboard)
        appDelegate.arrNavigationStack.append(vc)
        self.fadeTo(vc, animated: animated)
    }
}

class NavigationController : UINavigationController {
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if let topVC = viewControllers.last {
            //return the status property of each VC, look at step 2
            return topVC.preferredStatusBarStyle
        }
        
        return .default
    }
}
