//
//  ExtensionUILabel.swift
//  Giga
//
//  Created by Admin on 4/29/20.
//  Copyright © 2020 CMarix. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}
extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

extension UILabel {
    
    func setHTML(html: NSMutableAttributedString) {
        let newFont = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: UIFont.systemFontSize)) // The same is possible for custom font.

        let mattrStr = NSMutableAttributedString(attributedString: html)
        mattrStr.beginEditing()
        mattrStr.enumerateAttribute(.font, in: NSRange(location: 0, length: mattrStr.length), options: .longestEffectiveRangeNotRequired) { (value, range, _) in
            if let oFont = value as? UIFont, let newFontDescriptor = oFont.fontDescriptor.withFamily(newFont.familyName).withSymbolicTraits(oFont.fontDescriptor.symbolicTraits) {
                let nFont = UIFont(descriptor: newFontDescriptor, size: newFont.pointSize)
                mattrStr.removeAttribute(.font, range: range)
                mattrStr.addAttribute(.font, value: nFont, range: range)
            }
        }
        mattrStr.endEditing()
        self.attributedText = mattrStr
    }
}
extension UILabel{
   
    func setUnderLine(_ text: String, with search: String){
        let attributedText = NSMutableAttributedString(string: text) // 1
        let range = NSString(string: text).range(of: search, options:.caseInsensitive) // 2
        let highlightColor = UIColor.appGreen    // 3
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineColor: highlightColor,
            .foregroundColor:UIColor.appPurple,
            .underlineStyle:NSUnderlineStyle.single.rawValue
        ] //4
        attributedText.addAttributes(attributes, range: range ) // 5
        self.attributedText = attributedText // 6
       
    }
    
    func setHighlightedAttribute(_ text: String, with search: String){
        let attributedText = NSMutableAttributedString(string: text) // 1
        let range = NSString(string: text).range(of: search, options:.caseInsensitive) // 2
        let highlightColor = UIColor.appGreen    // 3
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor:UIColor.appPurple,
        ]
        attributedText.addAttributes(attributes, range: range ) // 5
        self.attributedText = attributedText // 6
       
    }
    
    func setLargeSmallText(price:String,rupees:String){
        let priceAttributes = [NSAttributedString.Key.foregroundColor:UIColor.app53428B,NSAttributedString.Key.font:UIFont(name: "FaktSoft-Medium", size:38)]
        let rupeesAttributes = [NSAttributedString.Key.foregroundColor:UIColor.app53428B,NSAttributedString.Key.font:UIFont(name: "FaktSoft-Medium", size:24)]
        
        let partOne = NSMutableAttributedString(string:price, attributes: priceAttributes as [NSAttributedString.Key : Any])
        let partTwo = NSMutableAttributedString(string:rupees, attributes: rupeesAttributes as [NSAttributedString.Key : Any])

        partOne.append(partTwo)
        self.attributedText  = partOne
    }
    
    func setMultipleTextAttribute(_ text: String,searchOne: String,searchTwo:String){
        let attributedText = NSMutableAttributedString(string: text) // 1
        let range = NSString(string: text).range(of: searchOne, options:.caseInsensitive) // 2
        let highlightColor = UIColor.appGreen    // 3
        let attributesOne: [NSAttributedString.Key: Any] = [
            .foregroundColor:UIColor.appPurple
        ]
        let attributesTwo: [NSAttributedString.Key: Any] = [
            .foregroundColor:UIColor.appPurple
        ]
        attributedText.addAttributes(attributesOne, range: range )
        attributedText.addAttributes(attributesTwo, range: range ) // 5// 5
        self.attributedText = attributedText // 6
        
    }
    
    func multipleAttribute(price:String,message:String,service:String){
        let priceAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPurple]
       
        let messageAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app5D678F]
        
        let serviceAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appPurple]
        

        let partOne = NSMutableAttributedString(string:price, attributes: priceAttributes)
        let partTwo = NSMutableAttributedString(string:message, attributes: messageAttributes)
        let partThree = NSMutableAttributedString(string:service, attributes: serviceAttributes)

        partOne.append(partTwo)
        partOne.append(partThree)
        self.attributedText  = partOne
       
    }

}
extension NSMutableAttributedString {

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)

        return self
    }

    @discardableResult func bold(_ text: String, withLabel label: UILabel) -> NSMutableAttributedString {

        //generate the bold font
        var font: UIFont = UIFont(name: label.font.fontName , size: label.font.pointSize)!
        font = UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitBold) ?? font.fontDescriptor, size: font.pointSize)

        //generate attributes
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)

        //append the attributed text
        append(boldString)

        return self
    }
    
    @discardableResult func customFont(_ text: String, withLabel label: UILabel, andFontName name: String) -> NSMutableAttributedString {

        //generate the bold font
        let font: UIFont = UIFont(name: name , size: label.font.pointSize)!

        //generate attributes
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)

        //append the attributed text
        append(boldString)

        return self
    }
    
    @discardableResult func customColor(_ text: String, withColor color: UIColor) -> NSMutableAttributedString {

        //generate attributes
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color ]
        
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)

        //append the attributed text
        append(boldString)

        return self
    }
    
    @discardableResult func customFont(_ text: String, withLabel fontSize: CGFloat , andFontName name: String) -> NSMutableAttributedString {

        //generate the bold font
        let font: UIFont = UIFont(name: name , size: fontSize)!

        //generate attributes
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)

        //append the attributed text
        append(boldString)

        return self
    }
    
    
    @discardableResult func customFontWithColor(text: String, fontSize: CGFloat , andFontName name: String, color: UIColor) -> NSMutableAttributedString {

            //generate the bold font
            let font: UIFont = UIFont(name: name , size: fontSize)!

            //generate attributes
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
            let boldString = NSMutableAttributedString(string:text, attributes: attrs)

            //append the attributed text
            append(boldString)

            return self
        }
}
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
