//
//  AppDelegate.swift
//  Iceback
//
//  Created by APPLE on 08/01/24.
//

import UIKit
import IQKeyboardManagerSwift 
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import Foundation
import AWSMobileClient

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Constant & Variables
    var window: UIWindow?
    var arrNavigationStack = [UIViewController]()
    var timeLeft: TimeInterval = INTEGER.TIMEDURATION
    var notificationType: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3)
        //1
        setUpLogin()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UINavigationController().navigationBar.isHidden = true
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//        
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error != nil || user == nil {
//                // Show the app's signed-out state.
//            } else {
//                // Show the app's signed-in state.
//            }
//        }
        awsCognitoInitialize()
        
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func applicationWillEnterForeground(_ application: UIApplication){
        print("Enter Foreground")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Enter Background")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Resign Active")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Become Active")
        //5
        verifyVersion()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Will Terminate")
    }
    
}

extension AppDelegate {
    
    func setUpLogin() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarConfiguration.placeholderConfiguration.showPlaceholder = false
        IQKeyboardManager.shared.resignOnTouchOutside = true
        UserDefaultHelper.selectedPreviousTabIndex = 5
        UserDefaultHelper.selectedTabIndex = 0
        if UserDefaultHelper.selectedLanguage == "" {
            UserDefaultHelper.selectedLanguage = "en"
        }
        
        if UserDefaultHelper.isLogin {
            UserDefaultHelper.selectedTabIndex = 0
            UserDefaultHelper.selectedPreviousTabIndex = 5
            let vc: HomeVC = HomeVC.instantiate(appStoryboard: .home)
            let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
            navigationController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navigationController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
}

//MARK: - AWS Cognito Setup
extension AppDelegate {
    func awsCognitoInitialize() {
        AWSDDLog.sharedInstance.logLevel = .verbose // TODO: Disable or reduce log level in production
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance) //TODO: Log everything to Xcode console
        
        AWSMobileClient.default().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized with user state: \(userState)")
            }
        }
    }
}


//MARK: - Firebase Remote Config
extension AppDelegate {
    //2
    func setupRemoteConfig(){
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let defaults : [String : Any] = [
            //            ForceUpdateChecker.IS_FORCE_UPDATE_REQUIRED : false,
            ForceUpdateChecker.FORCE_UPDATE_CURRENT_VERSION : "1.4(11)",
            //            ForceUpdateChecker.FORCE_UPDATE_STORE_URL : "https://itunes.apple.com/br/app/iceback/id6478161994"
        ]
        
        let expirationDuration = 0
        
        remoteConfig.setDefaults(defaults as? [String : NSObject])
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) in
            if status == .success {
                remoteConfig.activate()
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    //3
    func goToAppStore(action: UIAlertAction) {
        let appId = "6478161994"
        UIApplication.shared.openAppStore(for: appId)
    }
    
    //4
    func verifyVersion() {
        setupRemoteConfig()
        
        if ForceUpdateChecker().check() == .shouldUpdate {
            let alert = UIAlertController(title: "New version avaiable", message: "There are new features avaiable, please update your app", preferredStyle: .alert)
            let action = UIAlertAction(title: "Update", style: .default, handler: goToAppStore)
            alert.addAction(action)
            window?.rootViewController?.present(alert, animated: true)
        }
    }
}


//MARK: - Notification setup
extension AppDelegate {
    func enablePushNotification(_ application : UIApplication) {
        if #available(iOS 10.0, *) {
            //For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            //Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        //  print("Messaging Token \(Messaging.messaging().fcmToken ?? "")")
        
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Bring app to foreground
        print("RECEIVED = \(userInfo)")
        
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN = \(deviceToken)")
        let strToken = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        print("DEVICE TOKEN string: \(strToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
}


//MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("willPresentNotification Userinfo \(notification.request.content.userInfo)")
        //        let data = notification.request.content.userInfo
//        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {
//            completionHandler([])
//            return
//        }
        completionHandler([.sound, .alert, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveNotificationResponse Userinfo \(response.notification.request.content.userInfo)")
        
        let userInfo = response.notification.request.content.userInfo
        
        guard let aps = userInfo["aps"] as? [String:Any] else {
            return
        }
        print("aps",aps)
        
        
        if let notification = userInfo["message"] as? String,
                    let jsonData = notification.data(using: .utf8),
           let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary {
            //This is the point where we need to save push notification
            print("APS PAYLOAD DICTIONARY \(dict)")
            notificationType = dict["notification_type"] as? String ?? ""
            let voucherId = dict["voucher_id"] as? Int
            let storeId = dict["store_id"] as? Int
            let code = dict["code"] as? String
            let expiryDate = dict["expiry_date"] as? String
            let name = dict["name"] as? String
            let intReportId = dict["report_issue"] as? Int
         
            switch notificationType {
            case NOTIFICATIONTYPE.NEWVOUCHERS.rawValue:
                let vc: DealsAndVouchersDetailsVC = DealsAndVouchersDetailsVC.instantiate(appStoryboard: .deals)
                vc.storeId = storeId ?? 0
                vc.intDealId = voucherId ?? 0
                vc.strCouponCode = code ?? ""
                vc.strExpiryDate = expiryDate ?? ""
                vc.strCouponDetail = name ?? ""
                vc.isNotification = true
                let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()

            case NOTIFICATIONTYPE.NEWDONATIONPROJECT.rawValue:
                UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
                UserDefaultHelper.selectedTabIndex = 3
                let vc: DonationProjectsVC = DonationProjectsVC.instantiate(appStoryboard: .donationProjects)
                let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()

            case NOTIFICATIONTYPE.REPORTISSUE.rawValue:
                let vc: ReportIssueDetailVC = ReportIssueDetailVC.instantiate(appStoryboard: .reportIssue)
                vc.intReportId = intReportId ?? 0
                let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()

            case NOTIFICATIONTYPE.NEWSHOPS.rawValue:
                UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
                UserDefaultHelper.selectedTabIndex = 1
                let vc: StoresVC = StoresVC.instantiate(appStoryboard: .stores)
                vc.strSelectedStore = "New"
                let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()

            case NOTIFICATIONTYPE.DONATIONMILESTONE.rawValue:
                UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
                UserDefaultHelper.selectedTabIndex = 3
                let vc: DonationProjectsVC = DonationProjectsVC.instantiate(appStoryboard: .donationProjects)
                let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()

            case NOTIFICATIONTYPE.DONATIONRECIEVED.rawValue:
                UserDefaultHelper.selectedPreviousTabIndex = UserDefaultHelper.selectedTabIndex
                UserDefaultHelper.selectedTabIndex = 3
                let vc: DonationProjectsVC = DonationProjectsVC.instantiate(appStoryboard: .donationProjects)
                let navigationController : UINavigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.isHidden = true
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()
                
            default:
                break
            }
        
        }
           
    }
    
    
}

//MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaultHelper.device_token = token
            }
        }
    }
}
