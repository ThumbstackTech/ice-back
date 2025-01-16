//
//  FireBaseRemoteConfig.swift
//  Iceback
//
//  Created by Admin on 31/01/24.
//

import Foundation
import Firebase
import UIKit

extension Bundle {
    //1
    static var appVersionBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String
            else { return "" }
        return version
    }

    //2
    static var appBuildBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleVersion"] as? String
            else { return "" }
        return version
    }
}


class ForceUpdateChecker {

    //1
    enum UpdateStatus {
        case shouldUpdate
        case noUpdate
    }

    //2
    static let TAG = "ForceUpdateChecker"
    static let FORCE_UPDATE_STORE_URL = "force_update_store_url_iOS"
    static let FORCE_UPDATE_CURRENT_VERSION = "force_update_current_version_iOS"
    static let IS_FORCE_UPDATE_REQUIRED = "is_force_update_required_iOS"

    //3
    func getAppVersion() -> String {
        let version = "\(Bundle.appVersionBundle)(\(Bundle.appBuildBundle))"
        return version
    }

    //4
    func check() -> UpdateStatus {
        let remoteConfig = RemoteConfig.remoteConfig()
        
            guard let currentAppStoreVersion = remoteConfig[ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION].stringValue else {
                return .noUpdate
            }

            let appVersion = getAppVersion()

            if(currentAppStoreVersion > appVersion){
                return .shouldUpdate
            } else {
                return .noUpdate
            }

    }

    func setupRemoteConfig(){

        let remoteConfig = RemoteConfig.remoteConfig()

        let defaults : [String : Any] = [ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION : "",]

        let expirationDuration = 0

        remoteConfig.setDefaults(defaults as? [String : NSObject])

        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) in
            if status == .success {
                remoteConfig.activate()
            } else {
               dPrint("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}


extension UIApplication {
    func openAppStore(for appID: String) {
        let appStoreURL = "https://apps.apple.com/ch/app/iceback/id\(appID)"
        guard let url = URL(string: appStoreURL) else {
            return
        }

        DispatchQueue.main.async {
            if self.canOpenURL(url) {
                self.open(url)
            }
        }
    }
}
