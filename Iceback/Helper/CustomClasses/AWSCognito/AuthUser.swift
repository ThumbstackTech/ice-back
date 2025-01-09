//
//  AuthUser.swift
//  Iceback
//
//  Created by Admin on 27/03/24.
//

import Foundation

struct AuthUser {
    let username: String
    let claims: [String: Any]
    
    init(username: String, claims: [String : Any]) {
        self.username = username
        self.claims = claims
    }
}
