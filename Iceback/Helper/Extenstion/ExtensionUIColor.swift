//
//  ExtensionUIColor.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func getRGB() -> (r:CGFloat , g:CGFloat , b:CGFloat , a:CGFloat)? {
        
        var red:CGFloat = 0.0
        var green:CGFloat = 0.0
        var blue:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        
        return (red , green , blue , alpha)
    }
    
    func lightColor(byPercentage:CGFloat) -> UIColor? {
        return adjustColor(byPercentage: abs(byPercentage))
    }
    
    func darkColor(byPercentage:CGFloat) -> UIColor? {
        return adjustColor(byPercentage: (-1 * abs(byPercentage)))
    }
    
    private func adjustColor(byPercentage:CGFloat) -> UIColor? {
        
        guard let RGB = self.getRGB() else { return nil }
            
        return UIColor(red: min(RGB.r + byPercentage/100.0, 1.0), green: min(RGB.g + byPercentage/100.0, 1.0), blue: min(RGB.b + byPercentage/100.0, 1.0), alpha: RGB.a)
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
}
@IBDesignable
extension UIColor{
    @objc public class var app008000:UIColor{
        return UIColor(named: "App008000")!
    }
    @objc public class var appGreen:UIColor{
        return UIColor(named: "App29CF4D")!
    }
    @objc public class var appGray:UIColor{
        return UIColor(named: "AppGray")!
    }
    @objc public class var appPurple:UIColor{
        return UIColor(named: "AppPurple")!
    }
    @objc public class var appUnderLine:UIColor{
        return UIColor(named: "AppUnderLine")!
    }
    @objc public class var appF5F7:UIColor{
        return UIColor(named: "AppF5F7")!
    }
    @objc public class var appDBE0F3:UIColor{
        return UIColor(named: "AppDBE0F3")!
    }
    @objc public class var appBorder:UIColor{
        return UIColor(named: "AppBorader")!
    }
    @objc public class var appOrange:UIColor{
        return UIColor(named: "AppOrange")!
    }
    
    @objc public class var app5D678F:UIColor{
        return UIColor(named: "App5D678F")!
    }
    
    @objc public class var app53428B:UIColor{
        return UIColor(named: "App53428B")!
    }
    @objc public class var appEDEFF9:UIColor{
        return UIColor(named: "AppEDEFF9")!
    }
    @objc public class var app010101:UIColor{
        return UIColor(named: "App010101")!
    }
    
    @objc public class var app000000:UIColor{
        return UIColor(named: "App000000")!
    }
    
    @objc public class var app00000060:UIColor{
        return UIColor(named: "App000000(60%)")!
    }
    @objc public class var app00000070:UIColor{
        return UIColor(named: "App000000(70%)")!
    }
    
    @objc public class var app00000080:UIColor{
        return UIColor(named: "App000000(80%)")!
    }
    
    @objc public class var appFFFFFF:UIColor{
        return UIColor(named: "AppFFFFFF")!
    }
    @objc public class var app00000010:UIColor{
        return UIColor(named: "App000000(10%)")!
    }
    @objc public class var appEFF8FF:UIColor{
        return UIColor(named: "AppEFF8FF")!
    }
    @objc public class var app1F8DFF:UIColor{
        return UIColor(named: "App1F8DFF")!
    }
    
    @objc public class var app1F8DFF20:UIColor{
        return UIColor(named: "App1F8DFF(20%)")!
    }
    
    @objc public class var appED1925:UIColor{
        return UIColor(named: "AppED1925")!
    }
    
    @objc public class var appBDF4B7:UIColor{
        return UIColor(named: "AppBDF4B7")!
    }
}


extension UIColor {
    var hexString: String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}
