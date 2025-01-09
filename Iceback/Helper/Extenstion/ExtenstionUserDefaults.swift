//
//  ExtenstionUserDefaults.swift
//  Spot-O
//
//  Created by CMR010 on 03/11/20.
//  Copyright © 2020 Hitesh Baldaniya. All rights reserved.
//

import Foundation
import UIKit


class UserDefaultHelper {
    
    private enum Defaults: String {
        case isLogin = "com.user.login"
        case selectedTabIndex = "com.user.selectedTabIndex"
        case selectedPreviousTabIndex = "com.user.selectedPreviousTabIndex"
        case isRememberMe = "com.user.rememberme"
        case email = "com.user.email"
        case password = "com.user.password"
        case isBiometric = "com.user.biometric"
        case acessToken = "com.user.acessToken"
        case user_id = "com.user.user_id"
        case device_token = "com.user.device_token"
        case referral_link = "com.user.referral_link"
        case fName = "com.user.first_name"
        case lName = "com.user.last_name"
        case selectedLanguage = "com.test.selectedLanguage"
        case selectedLanguageIndexPath = "com.test.selectedLanguageIndexPath"
        case selectedBiometric = "com.user.selectedBiometric"
    }
    
    // MARK: Selected biometric
    static var selectedBiometric: String {
        set{
            _set(value: newValue, key: .selectedBiometric)
        } get {
            return _get(valueForKay: .selectedBiometric) as? String ?? ""
        }
    }
    
    // MARK: Check selected tab
    static var selectedTabIndex: Int {
        set{
            _set(value: newValue, key: .selectedTabIndex)
        } get {
            return _get(valueForKay: .selectedTabIndex) as? Int ?? 0
        }
    }
    
    // MARK: Check previously selected tab
    static var selectedPreviousTabIndex: Int {
        set{
            _set(value: newValue, key: .selectedPreviousTabIndex)
        } get {
            return _get(valueForKay: .selectedPreviousTabIndex) as? Int ?? 0
        }
    }
    
    // MARK: User isRememberMe
    static var isRememberMe: Bool {
        set{
            _set(value: newValue, key: .isRememberMe)
        } get {
            return _get(valueForKay: .isRememberMe) as? Bool ?? false
        }
    }
    
    
    // MARK: User email
    static var email: String {
        set{
            _set(value: newValue, key: .email)
        } get {
            return _get(valueForKay: .email) as? String ?? ""
        }
    }
    
    // MARK: Check selected language
    static var selectedLanguage: String {
        set{
            _set(value: newValue, key: .selectedLanguage)
        } get {
            return _get(valueForKay: .selectedLanguage) as? String ?? ""
        }
    }
    
    // MARK: Check selected language
    static var selectedLanguageIndexPath: Int {
        set{
            _set(value: newValue, key: .selectedLanguageIndexPath)
        } get {
            return _get(valueForKay: .selectedLanguageIndexPath) as? Int ?? 0
        }
    }
    
    
    // MARK: User Password
    static var passowrd: String {
        set{
            _set(value: newValue, key: .password)
        } get {
            return _get(valueForKay: .password) as? String ?? ""
        }
    }
    
    // MARK: User isBiometric
    static var isBiometric: Bool {
        set{
            _set(value: newValue, key: .isBiometric)
        } get {
            return _get(valueForKay: .isBiometric) as? Bool ?? false
        }
    }
    
    // MARK: User acess token
    static var acessToken: String {
        set{
            _set(value: newValue, key: .acessToken)
        } get {
            return _get(valueForKay: .acessToken) as? String ?? ""
        }
    }
    
    // MARK: User isLogin
    static var isLogin: Bool {
        set{
            _set(value: newValue, key: .isLogin)
        } get {
            return _get(valueForKay: .isLogin) as? Bool ?? false
        }
    }
    
    //MARK: First Name
    static var FirstName:String{
        set{
            _set(value: newValue, key: .fName)
        }get{
            return _get(valueForKay: .fName)as? String ?? ""
        }
    }
    
    //MARK: Last Name
    static var LastName:String{
        set{
            _set(value: newValue, key: .lName)
        }get{
            return _get(valueForKay: .lName)as? String ?? ""
        }
    }
    
    // MARK: User ID
    static var user_id: Int {
        set{
            _set(value: newValue, key: .user_id)
        } get {
            return _get(valueForKay: .user_id) as? Int ?? 0
        }
    }
    
    //MARK: Device token
    static var device_token:String{
        set{
            _set(value: newValue, key: .device_token)
        }get{
            return _get(valueForKay: .device_token)as? String ?? ""
        }
    }
    
    //MARK: Device token
    static var referral_link:String{
        set{
            _set(value: newValue, key: .referral_link)
        }get{
            return _get(valueForKay: .referral_link)as? String ?? ""
        }
    }
    
    // MARK: Generic Detail Set
    private static func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func _get(valueForKay key: Defaults)-> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    private static func _remove(valueForKay key: Defaults) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    //
    //static func deleteUserLoginId() {
    //    UserDefaults.standard.removeObject(forKey: Defaults.userloginId.rawValue)
    // }
}
