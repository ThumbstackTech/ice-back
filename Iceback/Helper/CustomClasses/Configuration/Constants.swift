//
//  Constants.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 12/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



// Notification Center Method
let KNoInternet = "Your device does not appear to have an active internet connection at this time."
let kSomethingWrongAlert = "Sorry, but we are unable to process your request at this time."


let CURRENT_DEVICE      = UIDevice.current

let CScreen             = UIScreen.main

let CScreenUIHeight      = 768

let CBounds             = CScreen.bounds

let CScreenHeight       = CBounds.size.height

let CScreenWidth        = CBounds.size.width

let CScreenCenterX      = CScreenWidth / 2.0

let CScreenCenterY      = CScreenHeight / 2.0

let CScreenCenter       = CGPoint(x: CScreenCenterX, y: CScreenCenterY)

let CBundle             = Bundle.main

let CUserDefaults       = UserDefaults.standard

let CSharedApplication  = UIApplication.shared

let appDelegate         = CSharedApplication.delegate as! AppDelegate

let UserdefaultsKey     =  "user_auth_token"


let GCDMainThread                   = DispatchQueue.main

let GCDBackgroundThread             = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)

let GCDBackgroundThreadLowPriority  = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)

let GCDBackgroundThreadHighPriority = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)

typealias BlockVoid                         = () -> Void

let lineSpacingBetweenText = 8.0

let iOS_NAME    = UIDevice.current.systemName

let iOS_VERSION = (UIDevice.current.systemVersion as NSString).doubleValue

let IS_iOS12            = Int(iOS_VERSION) == 12
let IS_iOS12_OR_LATER   = iOS_VERSION >= 12

let IS_iOS11            = Int(iOS_VERSION) == 11
let IS_iOS11_OR_LATER   = iOS_VERSION >= 11

let IS_iOS10            = Int(iOS_VERSION) == 10
let IS_iOS10_OR_LATER   = iOS_VERSION >= 10

let IS_iOS9             = Int(iOS_VERSION) == 9
let IS_iOS9_OR_LATER    = iOS_VERSION >= 9

let IS_iOS8             = Int(iOS_VERSION) == 8
let IS_iOS8_OR_LATER    = iOS_VERSION >= 8

let IS_iOS7             = Int(iOS_VERSION) == 7
let IS_iOS7_OR_LATER    = iOS_VERSION >= 7

let IS_iOS6             = Int(iOS_VERSION) == 6
let IS_iOS6_OR_LATER    = iOS_VERSION >= 6


let DEVICE_NAME     = CURRENT_DEVICE.name

let DEVICE_MODEL    = CURRENT_DEVICE.model

let IS_SIMULATOR    = (TARGET_IPHONE_SIMULATOR == 1)

let IS_IPHONE       = DEVICE_MODEL.range(of: "iPhone") != nil

let IS_IPOD         = DEVICE_MODEL.range(of: "iPod") != nil

let IS_IPAD         = DEVICE_MODEL.range(of: "iPad") != nil


let IS_IPHONE_4     = IS_IPHONE && CScreenHeight == 480
let IS_IPHONE_5     = IS_IPHONE && CScreenHeight == 568
let IS_IPHONE_6     = IS_IPHONE && CScreenHeight == 667
let IS_IPHONE_6P    = IS_IPHONE && CScreenHeight == 736
let IS_IPHONE_X     = IS_IPHONE && CScreenHeight >= 812

let IS_IPHONE_5_Landscape     = IS_IPHONE && CScreenWidth == 320
let IS_IPHONE_6_Landscape     = IS_IPHONE && CScreenWidth == 375
let IS_IPHONE_X_Landscape     = IS_IPHONE && CScreenWidth == 414

let IS_IPAD_MINI    = IS_IPAD && CScreenWidth == 512
let IS_IPAD_MINI2   = IS_IPAD && CScreenWidth == 512
let IS_IPAD_AIR     = IS_IPAD && CScreenWidth == 1024
let IS_IPAD_PRO     = IS_IPAD && CScreenWidth == 1366

let CBundleID               = CBundle.bundleIdentifier
let CBundleInfo             = CBundle.infoDictionary
let CAppVersion             = CBundleInfo!["CFBundleShortVersionString"]
let CAppBuild               = CBundleInfo!["CFBundleVersion"]
let CAppName : String       = CBundleInfo!["CFBundleName"] as! String

//

let CCacheDirectory         = NSHomeDirectory() + "/Library/Caches"
let CDocumentDirectory      = NSHomeDirectory() + "/Documents"
let CLimit                  = "20" as AnyObject



func IS_IPHONE_SIMULATOR() -> Bool
{
    #if (arch(i386) || arch(x86_64))
        return true
    #else
        return false
    #endif
    
}

func SYSTEM_VERSION_LESS_THAN(v: String) -> Any {
    return ((UIDevice.current.systemVersion.compare(v, options: .numeric, range: nil, locale: .current)) == .orderedAscending)
}

func CViewX(_ view:UIView) -> CGFloat {
    return view.frame.origin.x
}

func CViewY(_ view:UIView) -> CGFloat {
    return view.frame.origin.y
}

func CViewWidth(_ view:UIView) -> CGFloat {
    return view.frame.size.width
}

func CViewHeight(_ view:UIView) -> CGFloat {
    return view.frame.size.height
}

func CViewCenter(_ view:UIView) -> CGPoint {
    return view.center
}

func CViewCenterX(_ view:UIView) -> CGFloat {
    return CViewCenter(view).x
}

func CViewCenterY(_ view:UIView) -> CGFloat {
    return CViewCenter(view).y
}

func CViewSetX(_ view:UIView, x:CGFloat) -> Void {
    view.frame = CGRect(x: x, y: CViewY(view), width: CViewWidth(view), height: CViewHeight(view))
}

func CViewSetY(_ view:UIView, y:CGFloat) -> Void {
    view.frame = CGRect(x: CViewX(view), y: y, width: CViewWidth(view), height: CViewHeight(view))
}

func CViewSetWidth(_ view:UIView, width:CGFloat) -> Void {
    view.frame = CGRect(x: CViewX(view), y: CViewY(view), width: width, height: CViewHeight(view))
}

func CViewSetHeight(_ view:UIView, height:CGFloat) -> Void {
    view.frame = CGRect(x: CViewX(view), y: CViewY(view), width: CViewWidth(view), height: height)
}

func CViewSetOrigin(_ view:UIView, x:CGFloat, y:CGFloat) -> Void {
    view.frame = CGRect(x: x, y: y, width: CViewWidth(view), height: CViewHeight(view))
}

func CViewSetSize(_ view:UIView, width:CGFloat, height:CGFloat) -> Void {
    view.frame = CGRect(x: CViewX(view), y: CViewY(view), width: width, height: height)
}

func CViewSetFrame(_ view:UIView, x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> Void {
    view.frame = CGRect(x: x, y: y, width: width, height: height)
}

func CViewSetCenter(_ view:UIView, x:CGFloat, y:CGFloat) -> Void {
    view.center = CGPoint(x: x, y: y)
}

func CViewSetCenterX(_ view:UIView, x:CGFloat) -> Void {
    view.center = CGPoint(x: x, y: CViewCenterY(view))
}

func CViewSetCenterY(_ view:UIView, y:CGFloat) -> Void {
    view.center = CGPoint(x: CViewCenterX(view), y: y)
}

func CRectX(_ frame:CGRect) -> CGFloat {
    return frame.origin.x
}

func CRectY(_ frame:CGRect) -> CGFloat {
    return frame.origin.y
}

func CRectWidth(_ frame:CGRect) -> CGFloat {
    return frame.size.width
}

func CRectHeight(_ frame:CGRect) -> CGFloat {
    return frame.size.height
}


func CRGB(r red:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
}

func CRGBA(r red:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


struct AlertMsg{
    
    static let TITLE                          = "Error"//Opps!
    static let ALERT                          = "Alert"
    static let SUCCESS                        = "Success"
    static let LOGOUTITLE                     = "Confirm Logout"
    static let DELETEACCOUNTTITLE             = "Delete Account"
    static let COMINGSOONTITLE                = "Coming Soon!"
    static let CAMERADENIED                   = "To scan merchant QR code please enable camera permission."
    static let DATASUCCESS                    = "Data Submitted Successfully "
    static let USEREXISTSUCCESS               = "The admin will contact you soon!."
    static let USEREXISTFAILURE               = "User is not exists."
    static let CAMERAPERMISION                = "Enable permissions to access your camera for QR code scan."
    
    static let BIOMETRICSUCCESSMSG            = "Successful login."
    
    static let AUTHENTICATIORESONMSG          = "Authentication required to access the secure data."
    
    static let BIOMETRICON                    = "Please enable switch for biometric login."
    static let BIOMETRICOPTIONSELECT          = "Please select any biometric option."
    
    static let EMAILADDRESS                   = "Please enter email address."
    static let EMAILVALIDMSG                  = "Please enter a valid email address."
    static let PASSWORDVALIDMSG               = "Please enter password."
    static let PASSWORDSTRONGMSG              = "Password must contain lowercase, uppercase, number, special char/space, be at least 8 characters long, and no leading/trailing spaces."
    static let CONFIRMPASSWORDMSG             = "Please enter confirm password."
    static let CONFIRMVALIDPASSWORDMSG        = "Password and confirm password does not match."
    static let NEWPASSCONFIRMVALIDPASSWORDMSG = "New password and confirm password does not match."
    
    static let TERMSCONDIATIONMSG             = "Please accept terms & conditions and privacy policy."
    
    static let OLDPASSWORDMSG                 = "Please enter old password."
    static let NEWPASSWORDMSG                 = "Please enter new password."
    
    static let OTPEMPTY                       = "Please enter OTP."
    static let OTPVALIDMSG                    = "Please enter valid OTP."
    
    
    static let RESETPASSSUCESSMSG             = "Your password has been reset successfully."

    static let BANKNAME                       = "Please enter bank name."
    static let BSBNO                          = "Please enter bank BSB number."
    static let BSBNOVAlID                     = "Please enter valid bank BSB number."
    static let FULLNAME                       = "Please enter your full name."

    static let LOGOUTMSG                      = "Are you sure you want to logout?"
    
    static let DELETEACCOUNTMSG               = "You will lose your all data."
   
    static let FIRSTNAME                      = "Please enter first name."
    static let LASTNAME                       = "Please enter last name."
    static let DATEOFBIRTH                    = "Please enter date of birth."
    static let PHONENO                        = "Please enter phone number."
    static let COUNTRYCODE                    = "Please select country code."
    static let ADDRESS                        = "Please enter address."
    static let PHONENOVALID                   = "Please enter valid phone number."
    static let CUSTOMERSUPPORTSUBJECT         = "Please enter subject."
    static let CUSTOMERSUPPORTMESSAGE         = "Please enter message."
    static let CUSTOMERSUPPORTATTACHMENT      = "Please select attachment."
    static let CUSTOMERSUPPORTSUCESSMSG       = "Your data submit successfully!"
    static let INVALIDFILTER                  = "Please select at-least one category or one region."
    static let COUPONCODECOPIED               = "Coupon code copied."
    static let REFERRALLINKCOPIED             = "Referral link copied."
    static let GETMYCARD                      = "Mastercard credit card with CASHBACK coming soon…"
    static let PROFILEUPDATEDALREADY          = "Profile is already updated."
    static let PROFILEUPDATEDSUCCESSFULLY     = "Your profile has been updated successfully."
    static let ICEBACKREFERALMESSAGE          = "Referral link for Iceback"
    static let SESSIONEXPIREMESSAGE           = "Your session is expired please login again."
}
