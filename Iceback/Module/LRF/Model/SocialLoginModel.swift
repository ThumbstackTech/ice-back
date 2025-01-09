//
//  SocialLoginModel.swift
//  Iceback
//
//  Created by Admin on 21/03/24.
//

import Foundation
import UIKit

struct SocialLoginModel {
    var type: LoginType
    var image: UIImage?
}
enum LoginType {
    case Google
    case Apple
    case Facebook
}


