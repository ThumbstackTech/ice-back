//
//  GenericLabel.swift
//  HealthLayby
//
//  Created by CMR010 on 22/05/23.
//

import Foundation
import UIKit
class GenericLabel: UILabel {
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:
    // MARK: initialize
    
    func initialize() {
        
        if self.tag == 12 { // Circular Label
            self.layer.cornerRadius = self.frame.size.width/2
            self.clipsToBounds = true
        }
    
        self.text = self.text
    }
    
}
