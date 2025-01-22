//
//  CommonEnum.swift
//  HealthLayby
//
//  Created by CMR010 on 23/05/23.
//

import Foundation
import UIKit

//MARK: - DateTime Format
enum DateAndTimeFormatString {
    static let yyyymmddhhmmss = "yyyy-MM-dd HH:mm:ss"
    static let MMMddyyyhhmmsssa = "MMM dd, yyyy hh:mm a"
    static let ddMMM = "dd MMM"
    static let ddMMMYYYY = "dd-MMM-YYYY"
    static let MMddYYYY = "MMM dd, yyyy"
    static let YYYYMMdd = "YYYY/MM/dd"
    
}

//MARK: - Home Section
enum HomeSection: CaseIterable {
    case heroSection
    case howItWorkTitle
    case howItWork
    case shopWithCashbackTitle
    case shopWithCashback
    case specialAndVoucherTitle
    case specialAndVoucher
    case donationProjectsTitle
    case donationProjects
    case referAFriendsTitle
    case referAFriends
}

//MARK: - Language Items
enum LanguageItems: String, CaseIterable {
    case en = "English"
    case de = "German"
}

//MARK: - CMS Page Name
enum CMSPageName {
    case TERMSANDCONDITION, ABOUTUS, PRIVACYPOLICY
}

struct IMAGES {
    static let ICN_HOME_UNSELECTED                = UIImage(named: "ic_home_unselected")
    static let ICN_STORE_UNSELECTED               = UIImage(named: "ic_store_unselected")
    static let ICN_VOUCHER_UNSELECTED             = UIImage(named: "ic_voucher_unselected")
    static let ICN_DONATION_UNSELECTED            = UIImage(named: "ic_donation_unselected")
    static let ICN_HOME_SELECTED                  = UIImage(named: "ic_home_selected")
    static let ICN_STORE_SELECTED                 = UIImage(named: "ic_store_selected")
    static let ICN_VOUCHER_SELECTED               = UIImage(named: "ic_voucher_selected")
    static let ICN_DONATION_SELECTED              = UIImage(named: "ic_donation_selected")
    static let ICN_LANGUAGE_SELECTED              = UIImage(named: "ic_select_language")
    static let ICN_LANGUAGE_UNSELECTED            = UIImage(named: "ic_unselect_language")
    static let ICN_FILTER_SELECTED                = UIImage(named: "ic_select")
    static let ICN_FILTER_UNSELECTED              = UIImage(named: "ic_unselect")
    static let ICN_PLACEHOLDER_IMAGE              = UIImage(named: "ic_placeholder_image")
    static let ICN_EYE_OPEN                       = UIImage(named: "icn_eye_open")
    static let ICN_EYE_CLOSE                      = UIImage(named: "icn_eye_close")
    static let ICN_FACEBOOK_LOGIN                 = UIImage(named: "icn_facebook_login")
    static let ICN_APPLE_LOGIN                    = UIImage(named: "icn_apple_login")
    static let ICN_GOOGLE_LOGIN                   = UIImage(named: "icn_google_login")
    static let ICN_FACEID                         = UIImage(named: "icn_faceId")
    static let ICN_PASSCODE                       = UIImage(named: "icn_passcode")
    static let ICN_FINGERPRINT                    = UIImage(named: "icn_fingerprint")
    static let ICN_LOGOUTPOPUP                    = UIImage(named: "icn_logout")
    static let ICN_DELETEACCOUNTPOPUP             = UIImage(named: "icn_delete_popup")
    static let ICN_CASHBACKSTATUSACTIVE           = UIImage(named: "icn_cashback_status_active")
    static let ICN_CASHBACKSTATUSINACTIVE         = UIImage(named: "icn_cashback_status_inactive")
    static let ICN_UNFAVOURITE                    = UIImage(named: "icn_unfavourite")
    static let ICN_FAVOURITE                      = UIImage(named: "icn_favourite")
    static let ICN_CLOSE                          = UIImage(named: "ic_close_grey")
    static let ICN_BACK                           = UIImage(named: "ic_back_black")
}
struct BUTTONTITLE{
 
    static let YES                       = "Yes"
    static let No                        = "No"
    static let OK                        = "OK"
    static let SIGNUP                    = "Sign Up"
    static let IWANTTOKNOWMORE           = "I Want to Know More"
    static let VIEWMORE                  = "View More"
    static let SHOPNOW                   = "Shop Now"
    static let CLEARALL                  = "Clear All"
    static let CANCEL                    = "Cancel"
    static let APPLY                     = "Apply"
    static let REGISTER                  = "Register"
    static let LOGIN                     = "Login"
    static let FORGOTPASSWORD            = "Forgot Password?"
    static let CONTINUEASGUEST           = "Continue as Guest"
    static let DONATE                    = "Donate"
    static let SUBMIT                    = "Submit"
    static let ADDFILE                   = "+Add File"
    static let GETMYCARD                 = "Get My Card"
    static let USEPASSCODE               = "Use Passcode"    
    static let Verify                    = "Verify"
    static let MOREINFORMATION           = "More Information"
    static let CLEARACTIVITIESHISTORY    = "Clear Activities History"
    static let REPORTISSUE               = "Report Issue"
    static let UPDATE                    = "Update"
    static let ALREADYMEMBER             = "Already Member"
    static let RESETPASSWORD             = "Reset Password"
}

struct AlertMessage {
    
    
}

struct LABELTITLE{
 
    static let TERMTITLE                            = "Terms of Service"
    static let HOMETABBARTITLE                      = "Home"
    static let STORETABBARTITLE                     = "Stores"
    static let VOUCHERTABBARTITLE                   = "Deals & Vouchers"
    static let DONATIONTABBARTITLE                  = "Donation Projects"
    static let HOWITWORKSTITLE                      = "How it works"
    static let SHOPWITHCASHBACKITLE                 = "Shops with cashback"
    static let SPECIALVOUCHERTITLE                  = "Specials & vouchers"
    static let DONATIONPROJECTJOINTITLE             = "Donation Projects-join us!"
    static let REFERAFRIENDTITLE                    = "Refer-A-Friends"
    static let ENTERMESSAGETITLE                    = "Enter message"
    static let NONETITLE                            = "None"
    static let SIGNUP                               = "Sign Up"
    static let DONTHAVEACCOUNT                      = "Don’t have an account? "
    static let LOGIN                                = "Login"
    static let ALREADYHAVEACCOUNT                   = "Already have an account? "
    static let LOGOUTPOPUPTITLE                     = "Are you sure you want to log out of your account?"
    static let DELETEACCOUNTPOPUPTITLE              = "Are you sure you want to delete your account?"
    static let CASHBACKSTATUSACTIVE                 = "Cashback Active"
    static let CASHBACKSTATUSINACTIVE               = "Cashback Inactive"
    static let FORGOTPASSWORD                       = "Forgot Password"
    static let ALREADYMEMBER                        = "Already Member"
    static let REPORTDETAIL                         = "Report Detail - "
    static let SUBJECT                              = "Subject"
}
struct ARRAY{
    
    static let COUNTRYCODE               = ["+61"]
    static let SORTBY              = [SortByModel(title: "None", isSelect: false,value: ""), SortByModel(title: "A to Z", isSelect: false,value: "asc"), SortByModel(title: "Z to A", isSelect: false,value: "desc"), SortByModel(title: "Cashback (High to Low)", isSelect: false,value: "desc"), SortByModel(title: "Cashback (Low to High)", isSelect: false,value: "asc")]
}


enum CMSPAGES: String {
    case aboutUs  = "About Us"
    case terms    = "Terms of Service"
    case privacy  = "Privacy Policy"
}

enum CMSPageValue {
   static let AboutUs = "about-us"
   static let TermsConditions = "terms-and-conditions"
   static let PrivacyPolicy = "privacy-policy"
}


enum SIDEMENU: String,CaseIterable {
    case myProfile         = "My Profile"
    case aboutUs           = "About Us"
    case terms             = "Terms of Service"
    case privacyPolicy           = "Privacy Policy"
    case login             = "Login"
    case logout            = "Logout"
    case selectLanguage    = "Select Language"
}


enum MyProfileMenu: String,CaseIterable {
    
    case editProfile       = "Personal Information"
    case userActivities    = "User Activities"
    case favourites        = "Favourites"
    case customerSupport   = "Customer Support"
    case notificationTitle = "Notification"
    case purchaseHistory   = "Purchase History"
    case reports           = "Reports"
    case biometricLogin    = "Biometric Login"
    case deleteAccount     = "Delete Account"
}


//MARK: - Redirection URL
struct REDIRECTIONURL {
    static let SIGNUPURL                    = "Sign Up URL"
    static let ABOUTUSURL                   = "About Us URL"
    static let TERMSANDCONDITIONURL         = "Terms URL"
    static let PRIVACYPOLICYURL             = "Privacy URL"
    static let DONATEURL                    = "Donate URL"
    static let GETMYCARDURL                 = "Get My Card URL"
}

struct INTEGER {
    static let TIMEDURATION = 30.0
}


//MARK: - Notification Type
enum NOTIFICATIONTYPE: String {
    case NEWVOUCHERS                     = "new_vouchers"
    case NEWDONATIONPROJECT              = "new_donation_project"
    case REPORTISSUE                     = "report_issue"
    case NEWSHOPS                        = "new_shops"
    case DONATIONMILESTONE               = "donation_milestone"
    case DONATIONRECIEVED                = "donation_received"
    
}


struct EMPTYCELLMESSAGE {
    static let FAVOURITEEMPTY                        = "No more favourite available"
    static let REPORTISSUESEMPTY                     = "No more reports available"
    static let DEALSANDVOUCHERSEMPTY                 = "No more deals & vouchers available"
    static let STORESEMPTY                           = "No more store available"
}


enum BIOMETRICTYPE: String {
    case FACEID                          = "Face ID"
    case FINGERPRINT                     = "Fingerprint"
    case PASSCODE                        = "Passcode"
}
