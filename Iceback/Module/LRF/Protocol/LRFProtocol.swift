//
//  LRFProtocol.swift
//  Iceback
//
//  Created by Admin on 28/03/24.
//

import Foundation
import AWSMobileClient


protocol SignInDelegate{
    func signInSuccess(_ objData: AuthUser )
}
protocol SignInAccessTokenDelegate{
    func SignInAccessTokenSuccess(_ strData: String )
}

protocol SignUpDelegate{
    func signUpSuccess(_ isSucess: Bool  )
}

protocol SocialSigInDelegate{
    func socialSigInSuccess(_ isSucess: Bool  )
    func socialSigInFailure(_ strError: String  )
}


protocol OTPSendDelegate{
    func OTPSendSuccess(_ isSucess: Bool )
}

protocol ForgetPasswordDelegate{
    func forgetPasswordSuccess(_ objData: ForgotPasswordResult? )
}

protocol ResetPasswordDelegate{
    func resetPasswordSuccess(_ isSucess: Bool )
}

protocol SignOutDelegate{
    func signOutSuccess(_ isSucess: Bool )
}

protocol DeleteUserDelegate{
    func deleteUserSuccess(_ isSucess: Bool )
}

protocol AlreadyMemberDelegate{
    func alreadyMemberSuccess(_ isSucess: Bool)
}


protocol MobileAwsTokensDelegate{
    func mobileAwsTokensSuccess(_ isSucess: Bool)
}


protocol WelcomeMailDelegate{
    func welcomeMailSuccess(_ isSucess: Bool)
}
