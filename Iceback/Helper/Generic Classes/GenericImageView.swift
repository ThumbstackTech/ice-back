//
//  GenericImageView.swift
//  HealthLayby
//
//  Created by CMR010 on 22/05/23.
//

import Foundation
import UIKit
class GenericImageView: UIImageView {
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:
    // MARK: initialize
    
    func initialize() {
        
        
        if self.tag == 1 { //--- Corner only
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = true
        }
        else if self.tag == 2 { // Round-corner ImageVioew
            
            self.layer.cornerRadius = 8.3
            self.layer.borderWidth = 0.5
            //self.layer.borderColor = UIColor.borderColor().cgColor
            
            self.layer.shadowColor = UIColor.init(red: 0.00/255.0, green: 0.00/255.0, blue: 41.00/255.0, alpha: 1.0).cgColor
            self.layer.shadowOpacity = 1.0
            self.layer.shadowOffset = CGSize.zero
            self.layer.shadowRadius = 1
        }
        else if self.tag == 3 {
            Common.shared.roundCorners(view: self, corners: [.topLeft, .topRight], radius: 14.0)
        }
        else if self.tag == 11 { //--- Corner only
            self.layer.cornerRadius = (CViewHeight(self)/2.0)
            self.layer.masksToBounds = true
            
        }
        if self.tag == 12 { // Circular ImageView
            self.layer.cornerRadius = self.frame.size.width/2
            self.clipsToBounds = true
        }
        
    }
    
}
