//
//  ExtensionUIFont.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 13/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func convertToAppFont() -> UIFont {
        
        let pointSize: CGFloat = IS_IPAD_AIR ? +0 : IS_IPAD_PRO ? +5 : 0
        
        let fontSize = (self.pointSize) + (pointSize)
        var type = CFontType.Light
        
        if(self.fontName.uppercased().contains("BLACK")) {
            type = CFontType.Black
        } else if(self.fontName == "Nunito-BoldItalic") {
            type = CFontType.BoldItalic
        } else if(self.fontName == "Nunito-ExtraBold") {
            type = CFontType.ExtraBold
        } else if(self.fontName.uppercased().contains("BOLD")) {
            type = CFontType.Bold
        } else if(self.fontName.uppercased().contains("LIGHT")) {
            type = CFontType.Light
        } else if(self.fontName.uppercased().contains("REGULAR")) {
            type = CFontType.Regular
        } else if(self.fontName.uppercased().contains("SEMIBOLD")) {
            type = CFontType.SemiBold
        } else if(self.fontName.uppercased().contains("ITALIC")) {
            type = CFontType.Italic
        } else {
            type = CFontType.Light
        }
        return  CFont(size: fontSize, type: type)
    }
    
    func convertToPerWeek() -> UIFont {
        
         let pointSize: CGFloat = IS_IPHONE_5_Landscape ? -6 : IS_IPHONE_6_Landscape ? -3 : IS_IPHONE_X_Landscape ? -2 : 0
        let fontSize = (self.pointSize) + (pointSize)
        return  UIFont.init(name: self.fontName, size: fontSize)!
    }
}

extension Int {
    func deviceMaxHeight() -> CGFloat {
       
        let currentHeight = self
        let newMaxHeight = CGFloat(currentHeight) * (CGFloat(CScreenHeight) / CGFloat(CScreenUIHeight))
        return CGFloat(newMaxHeight)
    }
}

extension CGFloat {
    func deviceMaxHeight() -> CGFloat {
       
        let currentHeight = self
        let newMaxHeight = CGFloat(currentHeight) * (CGFloat(CScreenHeight) / CGFloat(CScreenUIHeight))
        return CGFloat(newMaxHeight)
    }
}


extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
