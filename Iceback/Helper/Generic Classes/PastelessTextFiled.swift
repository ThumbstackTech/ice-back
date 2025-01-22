//
//  PastelessTextFiled.swift
//  HealthLayby
//
//  Created by CMR010 on 05/06/23.
//

import Foundation
import UIKit
class PastelessTextFiled: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return super.canPerformAction(action, withSender: sender)
            && (action == #selector(UIResponderStandardEditActions.cut)
            || action == #selector(UIResponderStandardEditActions.copy))
    }
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK: initialize
    func initialize() {
        self.placeholder = self.placeholder
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
