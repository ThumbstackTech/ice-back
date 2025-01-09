//
//  AuthError.swift
//  Iceback
//
//  Created by Admin on 27/03/24.
//

import Foundation
import AWSMobileClient

enum AuthError: Error {
    case signinIncomplete
    case invalidPassword
    case error(AWSMobileClientError)
    
    func toString() -> String {
        switch self {
        case .signinIncomplete:
            return "Signin incomplete"
        case .invalidPassword:
            return AlertMsg.PASSWORDSTRONGMSG
        case .error(let err):
            return err.message
        }
    }
}
