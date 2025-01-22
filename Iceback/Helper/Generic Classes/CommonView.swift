//
//  CommonView.swift
//  HealthLayby
//
//  Created by CMR010 on 22/05/23.
//

import Foundation
import UIKit
class CommonView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:
    // MARK: initialize
    
    func initialize() {
        if self.tag == 1 { // Round-corner UIView- UITextfield Border
            
            self.layer.cornerRadius = self.frame.size.height / 2
            self.layer.borderWidth = 1.0
            self.layer.borderColor = AppThemeGray.cgColor
        } else if self.tag == 2 { // Round-corner UIView- PopUp
            
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
        } else if self.tag == 3 { // UIView- PopUp - Shadow
            self.popUpViewShadowUI()
        } else if self.tag == 4 {
            Common.shared.roundCorners(view: self, corners: [.bottomLeft, .topRight], radius: 10.0)
        } else if self.tag == 5 {
            self.dropShadow(color: AppThemeOutline, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 8, scale: true)
        } else if self.tag == 6 {
            Common.shared.roundCorners(view: self, corners: [.topLeft,.bottomRight], radius: 10.0)
        }
        if self.tag == 99 { // Round-corner UIView- UITextfield Border
            self.layer.cornerRadius = 8.3
            self.layer.borderWidth = 1.0
            self.layer.borderColor = selectedUnderLineColor.cgColor
        }
    }
    
    func popUpViewShadowUI(){
        self.layer.cornerRadius = 20
        self.layer.shadowColor = AppThemePopUpShadow.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 8
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
