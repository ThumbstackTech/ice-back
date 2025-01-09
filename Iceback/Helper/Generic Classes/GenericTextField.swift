//
//  GenericTextField.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 13/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

class GenericTextField: UITextField {
    
    let leftPadding: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:
    // MARK: initialize
    
    func initialize() {
        
        if self.tag == 0{
            self.placeholderColor = AppThemeGray//textfieldPlaceholderColor
        }
        else if self.tag == 1{
            self.placeholderColor = AppThemeGray
        }
        else{
            self.placeholderColor = selectedUnderLineColor
        }
        
        self.placeholder = self.placeholder
        
//        self.font = CFont(size: 15, type: .Regular).convertToAppFont()
        //self.addLeftImageAsLeftView(strImgName: "", leftPadding: leftPadding)
        
        self.font = self.font?.convertToAppFont()
    }
}
