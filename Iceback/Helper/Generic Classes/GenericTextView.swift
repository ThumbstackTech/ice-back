//
//  GenericTextView.swift
//  Diretoria
//
//  Created by Admin on 7/31/19.
//  Copyright © 2019 CMarix. All rights reserved.
//

import UIKit

class GenericTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:
    // MARK: initialize
    
    func initialize() {
        
        if self.tag == 99 {
            
            self.layer.borderWidth = 0.7
            self.layer.borderColor = UIColor.black.cgColor
        }
        
        self.font = self.font?.convertToAppFont()
    }
    
}

