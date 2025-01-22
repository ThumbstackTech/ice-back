//
//  LRFViewModel.swift
//  Iceback
//
//  Created by Admin on 28/03/24.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSMobileClient

class LRFViewModel {
    
    private var HUD = SVProgress()
    
    var signUpDelegate : SignUpDelegate!
    var signInDelegate : SignInDelegate!
    var oTPSendDelegate: OTPSendDelegate!
    var forgetPasswordDelegate : ForgetPasswordDelegate!
    var signOutDelegate : SignOutDelegate!
    var deleteUserDelegate : DeleteUserDelegate!
    var signInAccessTokenDelegate: SignInAccessTokenDelegate!
    var socialSigInDelegate : SocialSigInDelegate!
    var resetPasswordDelegate : ResetPasswordDelegate!
    var alreadyMemberDelegate : AlreadyMemberDelegate!
    var mobileAwsTokensDelegate : MobileAwsTokensDelegate!
    var userProfileDelegate : UserProfileDelegate!
    var welcomeMailDelegate : WelcomeMailDelegate!
    
    func signUp(email: String, password: String, phoneNumber: String, givenName: String, familyName: String) {
        HUD.show()
        
        let userAttributes: [String : String] = ["email": email,
                                                 "phone_number" : phoneNumber,
                                                 "given_name" : givenName,
                                                 "family_name" : familyName,
                                                 "custom:locale": UserDefaultHelper.selectedLanguage]
        
        LRFManager.sharedInstance.signUp(email: email, password: password, userAttributes: userAttributes) { result in
            switch result {
            case .success(let user):
                self.HUD.hide()
               dPrint("USER SIGNUP DATA>>",user)
                self.signUpDelegate.signUpSuccess(true)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
                
            }
        }
    }
    
    func signIn(email: String, password: String) {
        HUD.show()
        
        LRFManager.sharedInstance.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                if user != nil {
                    
                }else {
                    UserDefaultHelper.email = Common.shared.encrypt(str: email)
                    UserDefaultHelper.passowrd = Common.shared.encrypt(str: password)
                    self.oTPSendDelegate.OTPSendSuccess(true)
                }
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    func confirmSignIn(email: String, otp: String) {
        HUD.show()
        LRFManager.sharedInstance.confirmSignIn(email: email, otp: otp) { result in
            switch result {
            case .success(let user):
                self.signInDelegate.signInSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    func identityProvider() {
        LRFManager.sharedInstance.identityProvider() { result in
            switch result {
            case .success(let user):
                self.signInAccessTokenDelegate.SignInAccessTokenSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    func forgetPassword(email: String) {
        HUD.show()
        
        LRFManager.sharedInstance.forgetPassword(email: email) { result in
            switch result {
            case .success(let user):
                self.HUD.hide()
                self.forgetPasswordDelegate.forgetPasswordSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    
    func confirmForgotPassword(email: String,newPassword: String, otp: String) {
        HUD.show()
        
        LRFManager.sharedInstance.confirmForgotPassword(email: email,newPassword: newPassword, otp: otp) { result in
            switch result {
            case .success(let user):
                self.HUD.hide()
                self.resetPasswordDelegate.resetPasswordSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    
    func signOut() {
        HUD.show()
        
        LRFManager.sharedInstance.signOut() { result in
            switch result {
            case .success(let user):
                self.HUD.hide()
                self.signOutDelegate.signOutSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    func deleteUser() {
        HUD.show()
        
        LRFManager.sharedInstance.deleteUser() { result in
            switch result {
            case .success(let user):
                self.HUD.hide()
                self.deleteUserDelegate.deleteUserSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error.toString() , withDelegate: nil)
            }
        }
    }
    
    func showSignIn(navigationController: UINavigationController, hostedUIOptions: HostedUIOptions ) {
        HUD.show()
        
        LRFManager.sharedInstance.showSignIn(navigationController: navigationController, hostedUIOptions: hostedUIOptions) { result in
            switch result {
            case .success(let user):
                self.socialSigInDelegate.socialSigInSuccess(user)
            case .failure(let error):
                self.HUD.hide()
                if let errMsg = error.userInfo["error"] as? String {
                    self.socialSigInDelegate.socialSigInFailure(errMsg)
                }
            }
        }
    }
    
    //MARK: - Already Member
    func alreadyMember(email: String) {
        HUD.show()
        LRFManager.sharedInstance.alreadyMember(email: email) { [self] response in
            HUD.hide()
            alreadyMemberDelegate.alreadyMemberSuccess(true)
        } errorCompletion: { [self] error in
            HUD.hide()
            PPAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
        }
    }
    
    
    //MARK: - Already Member
    func mobileAwsTokens(accessToken: String) {
        LRFManager.sharedInstance.mobileAwsTokens(accessToken: accessToken) { [self] response in
            mobileAwsTokensDelegate.mobileAwsTokensSuccess(true)
        } errorCompletion: { [self] error in
            HUD.hide()
            PPAlerts().iOsAlert(title: AlertMsg.ALERT, withMessage: error, withDelegate: nil)
        }
    }
    
    //MARK: - Register Device Token
    func registerDeviceToken(fcmToken: String) {
        LRFManager.sharedInstance.registerDeviceToken(fcmToken: fcmToken) {  response in
        } errorCompletion: { [self] error in
            HUD.hide()
           dPrint("REGISTER DEVICE TOKEN ERROR: \(error)")
        }
    }
    //MARK: - DeRegister Device Token
    func deRegisterDeviceToken() {
        LRFManager.sharedInstance.deRegisterDeviceToken() { response in
        } errorCompletion: { error in
           dPrint("DE REGISTER DEVICE TOKEN ERROR: \(error)")
        }
    }
    
    //MARK: - Get User Profile
    func getUserProfile() {

        MyProfileManager.sharedInstance.getUserProfile() { [self] success in
            userProfileDelegate.getUserProfileDetails(success)
        } errorCompletion: { [self] error in
            self.HUD.hide()
            PPAlerts.sharedAlerts().iOsAlert(title: AlertMsg.TITLE, withMessage: error , withDelegate: nil)
        }
    }
    
    
    //MARK: - Welcome Mail
    func welcomeMail(email: String) {
        LRFManager.sharedInstance.welcomeMail(email: email) { [self] response in
            welcomeMailDelegate.welcomeMailSuccess(true)
        } errorCompletion: { [self] error in
            welcomeMailDelegate.welcomeMailSuccess(true)
        }
    }
}

