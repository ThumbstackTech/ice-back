//
//  ApplicationConstants.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 12/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit


let kStatusSuccessCode : Int    = 200

let CJsonResponse               = "response"
let CJsonError                  = "error"
let CJsonErrorFalse             = "false"

let CJsonMessage                = "message"
let CJsonStatus                 = "status"
let CStatusCode                 = "status_code"
let CStatusSuccess              = "Success"
let CStatusFailure              = "FAIL"
let CJsonTitle                  = "title"
let CJsonData                   = "data"
let CJsonCode                   = "code"
let CJsonMeta                   = "meta"
let CUserDefaultUDID            = "Device_UDID"
let CUserDefaultDeviceToken     = "DeviceToken"
let CGameAvailableStatus        = "AVAILABLE"
let CGameNotAvailableStatus     = "NOT_AVAILABLE"
let DataNoFound                 = "No data found."
let submissionCreated           = "submission_created"
let ERRORMESSAGE                = "Something went wrong"

let stageServerBearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4IiwianRpIjoiNzViZTQ2NjQyOWRkYWJlNTNmM2ZmOGQyYWE0NjRhOWQ2ZWIwNWIxYTNiYjMzZDM2NWZmZmJiOTU4ZmNmMzRmYzJlOGM3Zjg1YWM2NzkzMWIiLCJpYXQiOjE3MDQ3MTk4NDMuNjA5MTEsIm5iZiI6MTcwNDcxOTg0My42MDkxMTUsImV4cCI6MTczNjM0MjI0My41OTc0ODgsInN1YiI6IiIsInNjb3BlcyI6WyJwdWJsaWMiXX0.LDyEmtMV36jlSxZ9zc95oRf0W83Mod5Tjjpsj2fdKF6c6F4rLgXDSd9p1fL__7q8kPLyT0JNIY9VO0P6Oc5grUOb5f2YfbaE3hiPxU3CRVTt0CmZhGpHfPbeSU0_z-LxqtsE_gNzmJhqXnd6X54MdJuoDK7stq0IilPsVJ0lEdOesdW-HXeHstLx1waNLCz-fJlx8rvxWo8AgsI53gF-o-Nzdgk7trZB0yRAxnPdhdmDqbPfMlmd4CeX4Gtr-O7Mt1WVj-csW9XtkIFDc-3M9ENOOE1NYVo0f-vWhds8PmK2JIFjOz9UM8O0eJ8kVJWvgpC_ou9Rylp8v17vZtVvmnpCwXPJ4WttUXdkX0z1DTW9KAmmITmNafZOeUI4cq199X7dDJQpL-6axURPDtN_b7AO-kIZeR7gRFl_Dh2OAlGYftQ_xpIjD4IPn06SwsaEDx16ZmrKx3uzjENSjmVpPHyPIdYQcc2SPxGnRiqI0wfiV7XIkKg5kg7wR5Ig8_1V2YYvaTaqoDN39-T47pbmEToWavtLdgBhISbUmaUE17RCo9j3ggrQEZOsNPRK_T9OpC1UPhStqPk_NLxH90kYoirFy8edHrES6pY1vTRiCblcSCMzeEl2zF1uMlkZy7LDIjo6sUUknp4RSNc4N2p6tcZq83qBrx-uIXojbpwPrJc"

let liveServerBearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4IiwianRpIjoiNmI2ZGQyZjliYTYyNWVjNTgzODE4ZWI4NzhmYzA2ZGEwYjc4NGZjZDAxMmRjM2E1YmIyOTEyYTk0NWU1MDg3OWRkNmMxMWIyYmJjM2FmMmIiLCJpYXQiOjE3MzY0MTUwMDMuNTU0Mjk3LCJuYmYiOjE3MzY0MTUwMDMuNTU0MzEsImV4cCI6MTc2Nzk1MTAwMy41MjQ5NDIsInN1YiI6IiIsInNjb3BlcyI6W119.YAp6ukjTh3S3NkBILzFg9SvrocVVZpc_LB9SpmdrISIwcfGyxCZjG3MYLhuO5gBzji4v7Z6j2_HIt11HBfYK9s5ti6DnyJqX3f0T_C90YUlT5sZSTMsuwxW_mAaMkOCmQAUNkM7zPtAkQQDZ0dm5sSR_yIQtcFT1xO9i6AlSNb9oI9OStCcv7cpVkLti2HS3_wHk3ri0WvKBZuvoVUk9vAEUntlnXj_rTmcS1NhSuBSWNfw9vjQ-blg0OTTntsBrw44dpKECgHFsrLR3xesf8IcyFbUFYZsk9zv8-MvYTBFfRaD4pzTO2HK3WwG61ka5expiK1mU1FuwavjHXl4Pyn_zQ_9zD6foj2QZ3UB414CSzyIKYv6KFrlkLCipJgflCOA18NzePcJk4or6UwCJgzfIxBNSO_0h2utXc0ocPFsGvFzR1zszLu-s1psFMuDqdLmHCeZ-EBznKafp60kAKz1lBDeUklRVzw3mGnwfyJmKbXLTGSqkNqqNLw8ETFK6n2iWHf58EJ-pj4SPqIn48250tIQKyAJg8oXgez2q0bAsLwEBUzeYy-mH6Cbzm2s5VByrDYh5-29bgfED5ESCn5ygxdx6_vo148OL6gER2Yizp4tc-tOc064EQRDNwmaaLuoFkoFY8QkjWKNh3zc0EAh4wDLWS50_CjgccGg679A"

let guestLoginBearerToken: String = Global.sharedManager.isLive ? liveServerBearerToken : stageServerBearerToken

let webOpenURL: String = Global.sharedManager.isLive ? "https://api.ice-back.com" : "https://api-staging.ice-back.com"

let kAWSBucket: String = Global.sharedManager.isLive ? "shop-iceback-production" : "shop-iceback-staging"

let kAWSPath: String = Global.sharedManager.isLive ? "https://shop-iceback-production.s3.eu-central-1.amazonaws.com/" : "https://shop-iceback-staging.s3.eu-central-1.amazonaws.com/"
let referralURL: String = Global.sharedManager.isLive ? "https://ice-back.com/referral?referralCode" : "https://staging.ice-back.com/referral?referralCode"

let CNotificationCurrentDateTime = "CurrentDateTimeUpdate"

let AppThemePopUpShadow = UIColor.init(hexString: "#257FA8")
let AppThemeGray = UIColor.init(hexString: "#AEAEAE")
let AppThemeOutline = UIColor.init(hexString: "#D4D3D3")

let selectedUnderLineColor = UIColor.init(hexString: "#C6DEF1")
let unSelectedColor = AppThemeOutline
let textfieldTextColor = UIColor.app00000010


let CTermsOfUseURL = ""
let CPrivacyPolicyURL = ""


let kDeviceTypeIOS = "1"


var currentDate: String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "YYYY-MM-dd"
    return dateFormater.string(from: Date())
}

var currentDateTime: String {
    let dateFormater = DateFormatter()
    dateFormater.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return dateFormater.string(from: Date())
}

enum CFontType {
    case Regular
    case Light
    case Black
    case Bold
    case SemiBold
    case ExtraBold
    case Italic
    case BoldItalic
}

enum CFontName : String {
    
    case Regular = "Nunito-Regular"
    case Light = "Nunito-Light"
    case Black = "Nunito-Black"
    case Bold = "Nunito-Bold"
    case SemiBold = "Nunito-SemiBold"
    case ExtraBold = "Nunito-ExtraBold"
    case Italic = "Nunito-Italic"
    case BoldItalic = "Nunito-BoldItalic"
}

//
func CFont(size: CGFloat, type: CFontType) -> UIFont {
    switch type {
        
    case .Regular:
        return UIFont.init(name: "Nunito-Regular", size: size)!
    case .Black:
        return UIFont.init(name: "Nunito-Black", size: size)!
    case .Bold:
        return UIFont.init(name: "Nunito-Bold", size: size)!
    case .Light:
        return UIFont.init(name: "Nunito-Light", size: size)!
    case .SemiBold:
        return UIFont.init(name: "Nunito-SemiBold", size: size)!
    case .ExtraBold:
        return UIFont.init(name: "Nunito-ExtraBold", size: size)!
    case .Italic:
        return UIFont.init(name: "Nunito-Italic", size: size)!
    case .BoldItalic:
        return UIFont.init(name: "Nunito-BoldItalic", size: size)!
    default:
        return UIFont.init(name: "Nunito-Light", size: size)!
    }
}


enum AFontType {
    case Book
    case Oblique
    case Light
    case Medium
    case BookOblique
    case HeavyOblique
    case Roman
    case MediumOblique
    case Black
    case Heavy
    case BlackOblique
}

//
func AFont(size: CGFloat, type: AFontType) -> UIFont {
    switch type {
        
    case .Book:
        return UIFont.init(name: "AvenirLTStd-Book", size: size)!
    case .Oblique:
        return UIFont.init(name: "AvenirLTStd-BookOblique", size: size)!
    case .Light:
        return UIFont.init(name: "AvenirLTStd-Light", size: size)!
    case .Medium:
        return UIFont.init(name: "AvenirLTStd-Medium", size: size)!
    case .BookOblique:
        return UIFont.init(name: "AvenirLTStd-BookOblique", size: size)!
    case .HeavyOblique:
        return UIFont.init(name: "AvenirLTStd-HeavyOblique", size: size)!
    case .Roman:
        return UIFont.init(name: "AvenirLTStd-Roman", size: size)!
    case .MediumOblique:
        return UIFont.init(name: "AvenirLTStd-MediumOblique", size: size)!
    case .Black:
        return UIFont.init(name: "AvenirLTStd-Black", size: size)!
    case .Heavy:
        return UIFont.init(name: "AvenirLTStd-Heavy", size: size)!
    case .BlackOblique:
        return UIFont.init(name: "AvenirLTStd-BlackOblique", size: size)!
    }
}


//Notifications
let kNotificationReachabilityLost = "ReachabilityLostNotification"



//MARK: - Cognito Credentails
struct CognitoCredentails {
    static let clientID = "4q3r4u9jopobn6v50a4baucp2k"//"6gq5ccnfrh2om7r0it5aac9hvb"
    static let clientSecret = "1eihfpcu66h2jebdgt0aq6pc7o5vbea0ha3inujhps7akirfa919" //"ah1m9rdktsr4ci61hqspuh4a6ggl1g6q1ivsudptc36au51q39c"
    static let poolId = "eu-central-1_ITiEFa6mr"//"eu-central-1_NLHbPxh4l"
    static let identityPoolId = "eu-central-1:3be57398-dc99-47c5-b13a-00e13935a622"
    static let userPool = "UserPool"
    static let region = "eu-central-1"
    static let webDomain = "androidgoogle.auth.eu-central-1.amazoncognito.com"
    static let callbackURL = "https://openidconnect.net/callback"
    static let signOutURL = "https://openidconnect.net/callback"
    static let googleClientIdWeb = "768891046844-e6epopi894quf5j3o62re1d7afinspp0.apps.googleusercontent.com"
    static let googleClientSecret = "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"
    static let googleClientIdiOS = "768891046844-c47438l0omtp2hj5tdlod5lq4unbgdn8.apps.googleusercontent.com"
}
