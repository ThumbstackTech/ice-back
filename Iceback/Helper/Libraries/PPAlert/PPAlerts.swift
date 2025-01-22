//
//  PPAlerts.swift
//  HealthLayby
//
//  Created by CMR010 on 22/05/23.
//

import UIKit
import Foundation

private var sharedAlert : PPAlerts? = nil
enum AlertType : Int {
    case adefault = 0
    case toast
}

class PPAlerts: NSObject {
    
    class func sharedAlerts() -> PPAlerts {
        if sharedAlert == nil {
            sharedAlert = PPAlerts()
        }
        return sharedAlert!
    }
    
    //MARK: - Alerts
    func showMessage(with alertType: AlertType, withMessage message: String) {
        self.showAlert(with: alertType, withMessage: message, withTitle: "", withTimeoutInterval: 10.0)
    }
    
    func showAlert(with alertType: AlertType, withMessage message: String) {
        self.showAlert(with: alertType, withMessage: message, withTitle: "")
    }
    
    func showAlert(with alertType: AlertType, withMessage message:String, withTitle title:String?) {
        self.showAlert(with: alertType, withMessage: message, withTitle: title, withTimeoutInterval: 2.0)
    }
    
    func showAlert(with alertType: AlertType, withMessage message:String, withTitle title:String?, withTimeoutInterval interval:TimeInterval){
        var strmsg : String = ""
        if ((title as String?) ?? "").isEmpty {
            strmsg = message
        } else if ((message as String?) ?? "").isEmpty {
            strmsg = title!
        } else {
            strmsg = "\(String(describing: title)) \n \(message)"
        }
        
        switch alertType {
        case .adefault:
            iOsAlert(title: title, withMessage: message, withDelegate: nil)
        case .toast:
            ToastAlert(message: strmsg, withTimeoutImterval: interval)
        }
    }
    
    func topMostViewController() -> UIViewController {
       var topController: UIViewController? = appDelegate.window?.rootViewController
        while ((topController?
            .presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
    func iOsAlert(title: String?, withMessage message:String, withDelegate delegate: Any?) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let OkAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(OkAction)
        self.topMostViewController().present(alert, animated: true, completion: nil)
    }

    func alertOneButton(title: String?, withMessage message:String,_ btnOneTapped:alertActionHandler){
        let alertController = UIAlertController(title: title ?? "", message: message , preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title:BUTTONTITLE.OK, style: .default, handler: btnOneTapped))
        self.topMostViewController().present(alertController, animated: true, completion: nil)
    }

    func ToastAlert(message: String, withTimeoutImterval interval:TimeInterval) {    
        appDelegate.window?.makeToast(message, duration: interval, position: .bottom)
    }
}
