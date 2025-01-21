//
//  LRFManager.swift
//  Iceback
//
//  Created by Admin on 28/03/24.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSMobileClient
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LRFManager {
    
    static let sharedInstance = LRFManager()
    
    init() {
        
    }
    
    //MARK: - SignUp
    func signUp(email: String, password: String, userAttributes: [String : String],
                completion: @escaping (Result<Bool, AuthError>) -> Void) {
        
        AWSMobileClient.default().signUp(username: email, password: password, userAttributes: userAttributes) { result, error in
            GCDMainThread.async {
                if let signInResult = result {
                    switch (signInResult.signUpConfirmationState) {
                    case .confirmed:
                        completion(.success(true))
                    case .unconfirmed:
                        completion(.success(true))
                    case .unknown:
                       dPrint("unknown")
                    }
                }else if let error = error as? AWSMobileClientError {
                    // Handle login failure
                    completion(.failure(AuthError.error(error)))
                }
            }
        }
    }
    
    
    //MARK: - SignIn
    func signIn(email: String, password: String,
                completion: @escaping (Result<AuthUser?, AuthError>) -> Void) {
        AWSMobileClient.default().signOut()
        
        AWSMobileClient.default().signIn(username: email, password: password) { (signInResult, error) in
            GCDMainThread.async {
                if let signInResult = signInResult {
                    switch (signInResult.signInState) {
                    case .signedIn:
                        // User signed in successfully
                       dPrint("SIGN IN")
                        completion(.success(nil))
                    case .smsMFA:
                        // Additional authentication step required (e.g., MFA)
                       dPrint("SMSMFA")
                        completion(.success(nil))
                    case .newPasswordRequired:
                       dPrint("New Password")
                    default:
                        // Handle other cases (e.g., user needs to confirm account)
                       dPrint("DEFAULT")
                    }
                } else if let error = error as? AWSMobileClientError {
                    // Handle login failure
                    completion(.failure(AuthError.error(error)))
                }
            }
        }
    }
    
    //MARK: - Confirm SignIn
    func confirmSignIn(email: String, otp: String, completion: @escaping (Result<AuthUser, AuthError>) -> Void) {
        
        AWSMobileClient.default().confirmSignIn(challengeResponse: otp) { result, error in
            GCDMainThread.async {
                if let signInResult = result {
                    switch (signInResult.signInState) {
                        
                        
                    case .unknown:
                       dPrint("unknown")
                    case .smsMFA:
                       dPrint("smsMFA")
                    case .passwordVerifier:
                       dPrint("passwordVerifier")
                    case .customChallenge:
                       dPrint("customChallenge")
                    case .deviceSRPAuth:
                       dPrint("deviceSRPAuth")
                    case .devicePasswordVerifier:
                       dPrint("devicePasswordVerifier")
                    case .adminNoSRPAuth:
                       dPrint("adminNoSRPAuth")
                    case .newPasswordRequired:
                       dPrint("newPasswordRequired")
                    case .signedIn:
                        completion(.success(AuthUser(username: "username", claims: signInResult.parameters)))
                    }
                    
                } else if let error = error as? AWSMobileClientError  {
                    // Handle login failure
                   dPrint("ERROR>>",error)
                    completion(.failure(AuthError.error(error)))
                }
            }
            
        }
    }
    
    //MARK: - Identity Provider
    func identityProvider( completion: @escaping (Result<String, AuthError>) -> Void) {
        AWSMobileClient.default().getTokens { result, error in
            GCDMainThread.async {
                if let acessToken = result {
                    completion(.success(acessToken.accessToken?.tokenString ?? ""))
                } else if let error = error as? AWSMobileClientError  {
                    // Handle login failure
                    completion(.failure(AuthError.error(error)))
                }
            }
        }
    }
    
    //MARK: - Forget Password
    func forgetPassword(email: String, completion: @escaping (Result<ForgotPasswordResult?, AuthError>) -> Void) {
        
        AWSMobileClient.default().forgotPassword(username: email) { result, error in
            GCDMainThread.async {
                if let error = error as? AWSMobileClientError  {
                    completion(.failure(AuthError.error(error)))
                } else {
                    completion(.success(result))
                }
            }
        }
    }
    
    
    
    //MARK: - Confirm Forgot Password
    func confirmForgotPassword(email: String, newPassword: String, otp: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        
        AWSMobileClient.default().confirmForgotPassword(username: email, newPassword: newPassword, confirmationCode: otp) { result, error in
            GCDMainThread.async {
                if let signInResult = result {
                    switch (signInResult.forgotPasswordState) {
                    case .done:
                       dPrint("done")
                        completion(.success(true))
                    case .confirmationCodeSent:
                       dPrint("confirmationCodeSent")
                    }
                } else if let error = error as? AWSMobileClientError {
                    // Handle login failure
                    if error.localizedDescription.contains("error 9") {
                        completion(.failure(AuthError.invalidPassword))
                    } else {
                        completion(.failure(AuthError.error(error)))
                    }
                }
            }
            
        }
    }
  
    //MARK: - Sign Out
    func signOut(completion: @escaping (Result<Bool, AuthError>) -> Void) {
        AWSMobileClient.default().signOut(options: SignOutOptions(signOutGlobally: true, invalidateTokens: true)) { error in
            if let error = error as? AWSMobileClientError {
                // Handle login failure
                completion(.failure(AuthError.error(error)))
            } else {
                let manager = LoginManager()
                manager.logOut()
                Profile.current = nil
                AccessToken.current = nil
                GIDSignIn.sharedInstance.signOut()
                AWSMobileClient.default().clearKeychain()
                AWSMobileClient.default().clearCredentials()
                AWSMobileClient.default().invalidateCachedTemporaryCredentials()
                completion(.success(true))
            }
        }
        
    }
    
    //MARK: - Delete User
    func deleteUser(completion: @escaping (Result<Bool, AuthError>) -> Void) {
        AWSMobileClient.default().deleteUser { error in
            if let error = error as? AWSMobileClientError  {
                // Handle login failure
                completion(.failure(AuthError.error(error)))
            } else {
                completion(.success(true))
            }
        }
    }
    
    
    //MARK: - Federated SignIn
    func showSignIn(navigationController: UINavigationController,hostedUIOptions: HostedUIOptions, completion: @escaping (Result<Bool, NSError>) -> Void) {
        AWSMobileClient.default().signOut()
        AWSMobileClient.default().showSignIn(navigationController: navigationController, hostedUIOptions: hostedUIOptions) { (userState, error) in
            if let signInResult = userState {
               dPrint("showSignIn signInResult = \(signInResult)")
                completion(.success(true))
            } else if let error = error as? NSError  {
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Already Member API Call
    func alreadyMember(email: String, successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam = ["email": email]
        let headerParam = ["Authorization": guestLoginBearerToken]
        
        APIRequestManager.shared.POST(param: dataParam, header: headerParam, withTag: APIPoint().userExist) { response in
            
            guard let jsonData = response else {
                errorCompletion(ERRORMESSAGE)
                return
            }
            
            guard let status = jsonData["status"] as? String, status == "OK" else {
                errorCompletion(AlertMsg.USEREXISTFAILURE)
                return
            }
            successCompletion(true)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    
    func mobileAwsTokens(accessToken: String, successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        let dataParam = ["access_token": accessToken]
        let headerParam = ["Authorization": guestLoginBearerToken]
        
        APIRequestManager.shared.POST(param: dataParam, header: headerParam, withTag: APIPoint().mobileAwsTokens) { response in
            
            guard let jsonData = response else {
                errorCompletion(ERRORMESSAGE)
                return
            }
            
            guard let responseData = jsonData[CJsonData] as? String, responseData == "valid" else {
                errorCompletion(ERRORMESSAGE)
                return
            }
            
            successCompletion(true)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Register Device Token API Call
    func registerDeviceToken(fcmToken: String, successCompletion:@escaping(Bool)->(),errorCompletion:@escaping(String)->()) {
        
        let dataParam: [String: Any] = ["device_token": fcmToken, "device_type": 2]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().registerDeviceToken) { response in
            
            guard let jsonData = response else {
                errorCompletion(ERRORMESSAGE)
                return
            }
            
            guard let status = jsonData["status"] as? String, status == "OK" else {
                errorCompletion(AlertMsg.USEREXISTFAILURE)
                return
            }
            
            successCompletion(true)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Deregister Device Token API Call
    func deRegisterDeviceToken(successCompletion:@escaping(Bool)->(), errorCompletion: @escaping(String)->()) {
        
        let dataParam: [String: Any] = ["user_id": UserDefaultHelper.user_id]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().deRegisterDeviceToken) { response in
            
            guard let jsonData = response else {
                errorCompletion(ERRORMESSAGE)
                return
            }
            
            guard let status = jsonData["status"] as? String, status == "OK" else {
                errorCompletion(AlertMsg.USEREXISTFAILURE)
                return
            }
            
            successCompletion(true)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
    
    //MARK: - Welcome Mail API Call
    func welcomeMail(email: String, successCompletion:@escaping(Bool)->(), errorCompletion: @escaping(String)->()) {
        
        let dataParam: [String: Any] = ["email": email]
        
        APIRequestManager.shared.POST(param: dataParam, header: Global.sharedManager.headerParam, withTag: APIPoint().welcomeMail) { response in
            
            guard let jsonData = response else {
                errorCompletion(ERRORMESSAGE)
                return
            }
            
            guard let response = jsonData as? [String: Any] else {
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            guard let statusCode = response["status_code"] as? Int, statusCode == 200  else {
                errorCompletion(jsonData[CJsonMessage] as? String ?? "")
                return
            }
            
            successCompletion(true)
            
        } failureCallBack: { error in
            errorCompletion(error)
        }
    }
}





