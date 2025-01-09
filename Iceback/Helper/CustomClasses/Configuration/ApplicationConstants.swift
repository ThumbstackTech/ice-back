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

let liveServerBearerToken = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI4IiwianRpIjoiNTljYzIxZWVlZTc3OGZiYWZjZTY1MTZlOGRmZTQxNDRjNzA5MTE2NzRkOWEzZmFjZTUyYzEzZjQ1MTllZmYwYWVkMWNjZDQ1Zjg4OTc4MDEiLCJpYXQiOjE3MDQ3MjMxNDQuNDU4MDQ3LCJuYmYiOjE3MDQ3MjMxNDQuNDU4MDUyLCJleHAiOjE3MzYzNDU1NDQuNDQzMjM0LCJzdWIiOiIiLCJzY29wZXMiOltdfQ.fHyGRYU6vsE0FmYk0jaYhyBlZwGGm003uXUgTMr1M95H8UlEffIaG9FsTLlAsKS6-x-xQa4Ou9kgOEzgNU7Q14hOhgm47RzyTLNvMMDKP3-vUJwomXcDWFAZCa76gMV-rtezIKxufTQgRLarf4rnoUZQ9LrEWt4SUnB7mu6RpQhwOT03P8tQGPlvdXICmTrP93vGOVU6S9Yt4e92mm9MboPusKBwel02koj8KkyaYkGoLk1AaBjwcwJb9IAMilvwHEofRq1WLHfuHeKyQSU6IAeHyEChOUJmYh0nD7I7rvkLRx7w8T8ocsBvckv4UhTIjrKi2OcpzV-pu0YKYZzxli01WL1Db7ydrOUW7frTmJyJhc2lRFSClkKsQEJ2KBFqWrt-UAgG9PCMG_RzvDaheWBWjvKpOJ4uZoOTd8E21PbnlcYjUhbJVqoIjpyj7jBWJiTEPXYeSuXHIk4uUBVEGuv5NEOtxuvi-VVG8qdloAxPL1R6OBkMWV7HTccP98jv09faVzKw4YL9aAOqOsMnxTUaK2htJZadKtJG57LoDKlJrCDhh6D1cYN-FUf5EDVf5EqaGGT2atLHYX84JcDxtaa_7OLuLyPcM4tNN4uIAzU3aXclqtc7vbueOakvv9mpCRY_pbzL8D8sELo8A5OQCuOI8LyM_5djBZL38-crMl4"

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
