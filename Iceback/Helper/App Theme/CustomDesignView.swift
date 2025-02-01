//
//  CustomDesignView.swift
//  Iceback
//
//  Created by Gourav Joshi on 29/01/25.
//

import Foundation
import UIKit

@IBDesignable
class CustomDesignView: UIView {

//   @IBInspectable override var cornerRadius: CGFloat = AppThemeManager.shared.cornerRadius {
//      didSet {
//         layer.cornerRadius = cornerRadius
//         layer.masksToBounds = cornerRadius > 0
//      }
//   }

   @IBInspectable public var appBackgroundColor: UIColor = UIColor.black { //AppThemeManager.shared.backgroundColor {

      didSet {
         dPrint("appBackgroundColor = \(appBackgroundColor)")
         self.backgroundColor = appBackgroundColor
      }
   }
}
