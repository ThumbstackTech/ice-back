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
        
        /*if self.tag == 0 {
            
            let height = CViewHeight(self)*CScreenWidth/414
            self.layer.cornerRadius = height / 2
        
        }else{
            
            self.layer.borderWidth = 1.0
            self.layer.borderColor = selectedUnderLineColor.cgColor
            
            self.layer.cornerRadius = 5
        }*/
        
        
        if self.tag == 1 { // Round-corner UIView- UITextfield Border
            
            self.layer.cornerRadius = self.frame.size.height / 2
            self.layer.borderWidth = 1.0
            self.layer.borderColor = AppThemeGray.cgColor
        }
        else if self.tag == 2 { // Round-corner UIView- PopUp
            
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
            //self.layer.borderWidth = 1.0
            //self.layer.borderColor = selectedUnderLineColor.cgColor
        }
        else if self.tag == 3 { // UIView- PopUp - Shadow
            self.popUpViewShadowUI()
        }
        else if self.tag == 4 {
            Common.shared.roundCorners(view: self, corners: [.bottomLeft, .topRight], radius: 10.0)
        }
        else if self.tag == 5 {
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
        //self.layer.borderWidth = 0.5
        //self.layer.borderColor = AppThemeGray.cgColor
    }
    
    /*func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            let cornerMasks = [
                corners.contains(.topLeft) ? CACornerMask.layerMinXMinYCorner : nil,
                corners.contains(.topRight) ? CACornerMask.layerMaxXMinYCorner : nil,
                corners.contains(.bottomLeft) ? CACornerMask.layerMinXMaxYCorner : nil,
                corners.contains(.bottomRight) ? CACornerMask.layerMaxXMaxYCorner : nil,
                corners.contains(.allCorners) ? [CACornerMask.layerMinXMinYCorner, CACornerMask.layerMaxXMinYCorner, CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner] : nil
                ].compactMap({ $0 })

            var maskedCorners: CACornerMask = []
            cornerMasks.forEach { (mask) in maskedCorners.insert(mask) }

            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = maskedCorners
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }*/
    
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
