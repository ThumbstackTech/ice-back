//
//  AppThemeManager.swift
//  Iceback
//
//  Created by Gourav Joshi on 22/01/25.
//

import Foundation
import UIKit

fileprivate var designTokens: DesignTokens? = DesignTokensConfig().parseDesignTokensData()
fileprivate var colorContent: Content?
fileprivate var appColor: AppColor?
fileprivate let defaultColor: String = "#000000"
fileprivate var isAppDarkMode: Bool {
   return appDelegate.window?.rootViewController?.traitCollection.userInterfaceStyle == .dark
}

fileprivate func getAppColor() -> AppColor {
   if designTokens?.platform?[0].type == "ios" {
      appColor = designTokens?.platform?[0].content?.appColor
      return appColor!
   }
   return AppColor()
}

class AppThemeManager: NSObject {

   static let shared = AppThemeManager()
   private override init() {}

   /*
    This will be the main app theme color used in the app.
    */
   var primaryColor: UIColor = ColorConverter.hexToRGB(
      hex: (isAppDarkMode ? getAppColor().primaryDark?.value : getAppColor().primaryLight?.value) ?? defaultColor)

   /*
    This will be the supportive color for app theme color used in the app for background purpose
    */
   var secondaryColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().secondaryDark?.value : getAppColor().secondaryLight?.value) ?? defaultColor)
   /*
    This color will be used for all textFields in order to maintain the color while typing.
    */
   var textColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().textColorDark?.value : getAppColor().textColorLight?.value) ?? defaultColor)
   /*
    This color will be used for all labels in order to maintain the color while rendering the UI.
    */
   var labelColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().labelColorDark?.value : getAppColor().labelColorLight?.value) ?? defaultColor)
   var placeholderTextColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().placeholderTextColorDark?.value : getAppColor().placeholderTextColorLight?.value) ?? defaultColor)
   var backgroundColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().backgroundDark?.value : getAppColor().backgroundLight?.value) ?? defaultColor)
   var tertiaryColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().tertiaryDark?.value : getAppColor().tertiaryLight?.value) ?? defaultColor)
   var titleColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().titleColorDark?.value : getAppColor().titleColorLight?.value) ?? defaultColor)
   var buttonTitleColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().buttonTitleDark?.value : getAppColor().buttonTitleLight?.value) ?? defaultColor)
   var borderColor: UIColor = UIColor(hexString: (isAppDarkMode ? getAppColor().borderColorDark?.value : getAppColor().borderColorLight?.value) ?? defaultColor)
   var gradientColor: [String]? = (isAppDarkMode ? getAppColor().gradientDark : getAppColor().gradientLight) ?? [String]()
   var appFont: AppFont? = designTokens?.font
   var appBaseUrl: String? = String()
   var cornerRadius: CGFloat = 60

   func setTextFont(fontWeight: UIFont.Weight = .regular)-> UIFont {
      return UIFont.systemFont(ofSize: CGFloat(designTokens?.font?.size ?? 15.0) , weight: fontWeight)
   }




}

func checkAppDarkMode() -> Bool {
   if let vc = appDelegate.window?.rootViewController {
      if vc.traitCollection.userInterfaceStyle == .dark {
         return true
      }
   }
   return false
}

class ColorConverter {
  static func hexToRGB(hex: String) -> UIColor {//(red: CGFloat, green: CGFloat, blue: CGFloat)? {
    // dPrint("designTokens?.appColor?.primary = \(designTokens?.appColor?.primary ?? defaultColor)")
      dPrint("hex = \(hex)")
      let formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      dPrint("formattedHex = \(formattedHex)")
      if formattedHex.count != 6 {
         return UIColor(red: 180.0/255.0, green: 101.0/255.0, blue: 105.0/255.0, alpha: 1.0)
      }
      var rgb: UInt64 = 0
      Scanner(string: formattedHex).scanHexInt64(&rgb)
      let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      let blue = CGFloat(rgb & 0x0000FF) / 255.0

      return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
   }
}

extension UIView {

   func loopViewHierarchyReversed(block: (_ view: UIView, _ stop: inout Bool) -> ()) {
      for i in stride(from: self.highestViewLevel(view: self), through: 1, by: -1) {
         let stop = self.loopView(view: self, level: i, block: block)
         if stop {
            break
         }
      }
   }

   private func loopView(view: UIView, level: Int, block: (_ view: UIView, _ stop: inout Bool) -> ()) -> Bool {
      if level == 1 {
         var stop = false
         block(view, &stop)
         return stop
      } else if level > 1 {
         for subview in view.subviews.reversed() {
            let stop = self.loopView(view: subview, level: level - 1, block: block)
            if stop {
               return stop
            }
         }
      }
      return false
   }

   private func highestViewLevel(view: UIView) -> Int {
      var highestLevelForView = 0
      for subview in view.subviews.reversed() {
         let highestLevelForSubview = self.highestViewLevel(view: subview)
         highestLevelForView = max(highestLevelForView, highestLevelForSubview)
      }
      return highestLevelForView + 1
   }
}

extension UILabel {
   func setColorOnAttributedString(fullText: String, changeText: String, labelColor: UIColor) {
      let strNumber: NSString = fullText as NSString
      let range = (strNumber).range(of: changeText)
      let attribute = NSMutableAttributedString.init(string: fullText); attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: labelColor, range:NSRange(location: 0, length: 7) )
      self.attributedText = attribute }

}
