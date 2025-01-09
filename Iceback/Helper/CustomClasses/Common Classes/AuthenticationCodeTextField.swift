//
//  AuthenticationCodeTextField.swift
//  Iceback
//
//  Created by Admin on 28/03/24.
//

import Foundation
import UIKit

class AuthenticationCodeTextField: UITextField {
    
    weak var previousTextField: AuthenticationCodeTextField?
    weak var nextTextField: AuthenticationCodeTextField?
    
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}
