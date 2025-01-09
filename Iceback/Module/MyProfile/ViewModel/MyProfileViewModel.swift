//
//  MyProfileViewModel.swift
//  Iceback
//
//  Created by Admin on 03/05/24.
//

import Foundation
class MyProfileViewModel {
    
    var HUD = SVProgress()
    
    var userProfileDelegate : UserProfileDelegate!
    var profilePictureDelegate : ProfilePictureProtocol!
    var updateProfileDelegate : UpdateProfileProtocol!
    var favouriteStoresDelegate: FavouriteStoresDelegate!
    var customerSupportDelegate : CustomerSupportDelegate!
    var notificationsDelegate : NotificationsDelegate!
    var userActivitiesDeleteDelegate : UserActivitiesDeleteDelegate!
    var userAccountDeleteDelegate : UserAccountDeleteDelegate!
    
    //MARK: - Profile Picture
    func profilePicture(key: String) {        
        let userAttributes: [String : Any] = ["key": key]
        
        MyProfileManager.sharedInstance.profilePictureURL(param: userAttributes) { [self] response in
            profilePictureDelegate.profilePictureDelegate(response: response)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: -  Edit Profile
    func editProfile(key: String) {
        
        let userAttributes: [String : Any] = ["avatar": key]
        
        MyProfileManager.sharedInstance.profileUpate(param: userAttributes) { [self] success in
            self.HUD.hide()
            updateProfileDelegate.editAvatarDelegate(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: - Get User Profile
    func getUserProfile() {
        HUD.show()
        MyProfileManager.sharedInstance.getUserProfile() { [self] success in
            self.HUD.hide()
            userProfileDelegate.getUserProfileDetails(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func favouriteStores(intPage: Int) {
        HUD.show()
        
        MyProfileManager.sharedInstance.favouriteStores(intPage: intPage) { [self] success in
            self.HUD.hide()
            favouriteStoresDelegate.favouriteStoresSucess(success)
        } errorCompletion: {  [self] error in
                self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    

    func customerSupport(name: String, email: String, message: String) {
        HUD.show()
        
        MyProfileManager.sharedInstance.customerSupport(name: name, email: email, message: message) { [self] success in
            self.HUD.hide()
            customerSupportDelegate.customerSupport("success")
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    //MARK: - Notifications
    func notificationsList(intPageLimit: Int) {
        HUD.show()
        MyProfileManager.sharedInstance.notificationsList(intPageLimit: intPageLimit ) { [self] success in
            self.HUD.hide()
            notificationsDelegate.getNotifications(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func userActivitiesDelete() {
        HUD.show()
        MyProfileManager.sharedInstance.userActivitiesDelete() { [self] success in
            self.HUD.hide()
            userActivitiesDeleteDelegate.userActivitiesDeleteSuccess(isSucess: success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    func userDeleteAccount() {
        HUD.show()
        MyProfileManager.sharedInstance.userDeleteAccount() { [self] success in
            self.HUD.hide()
            userAccountDeleteDelegate.userAccountDeleteSuccess(isSucess: success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
}
