//
//  ExtensionString.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit


extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }

        return attributedString.string
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSRange(location: utf16view.distance(from: utf16view.startIndex, to: from), length: utf16view.distance(from: from, to: to))
        }
        return NSRange(location: 0, length: 0)
    }
    
    func attributedString(withRegularFont regularFont: UIFont, andBoldFont boldFont: UIFont) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString()
        guard let data = self.data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            attributedString = try NSMutableAttributedString(data: data,
                                                             options: [.documentType: NSAttributedString.DocumentType.html,
                                                                       .characterEncoding:String.Encoding.utf8.rawValue],
                                                             documentAttributes: nil)
            let range = NSRange(location: 0, length: attributedString.length)
            attributedString.enumerateAttribute(NSAttributedString.Key.font, in: range, options: .longestEffectiveRangeNotRequired) { value, range, _ in
                let currentFont: UIFont         = value as! UIFont
                var replacementFont: UIFont?    = nil
                
                if currentFont.fontName.contains("bold") || currentFont.fontName.contains("Bold") {
                    replacementFont = boldFont
                } else {
                    replacementFont = regularFont
                }
                
                let replacementAttribute = [NSAttributedString.Key.font:replacementFont!, NSAttributedString.Key.foregroundColor: UIColor.black]
                attributedString.addAttributes(replacementAttribute, range: range)
            }
        } catch let e {
            print(e.localizedDescription)
        }
        return attributedString
    }
    
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
           do {
               let htmlCSSString = "<style>" +
                   "html *" +
                   "{" +
                   "font-size: \(font.pointSize)pt !important;" +
               "color: #\(color.toHexString()) !important;" +
                   "font-family: \(font.familyName), Helvetica !important;" +
                   "}</style> \(self.replacingOccurrences(of: "<p>", with: "<p><br>"))"

               guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                   return nil
               }

               return try NSAttributedString(data: data,
                                             options: [.documentType: NSAttributedString.DocumentType.html,
                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                             documentAttributes: nil)
           } catch {
               print("error: ", error)
               return nil
           }
       }
    
    public func convertHtmlToAttributedStringWithCSS(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "font-size: \(font.pointSize)pt !important;" +
            "color: #\(color.hexString!) !important;" +
            "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}




extension String {
    func localized() -> String {
        if UserDefaultHelper.selectedLanguage != "" {
            let language = UserDefaultHelper.selectedLanguage
            let path = Bundle.main.path(forResource: language, ofType: "lproj")
            let bundle = Bundle(path: path!)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        } else {
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            let bundle = Bundle(path: path!)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
    }
    
    func trim() -> String?
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func blank() -> Bool
    {
        return self.trim()!.count == 0
    }
    
    var forDatabase : String {
        
        //        let firstChar = String(self.first!)
        //        let firstCharLowerCase = firstChar.lowercased()
        
        return prefix(1).lowercased() + self.dropFirst()
        
    }
    
    func isEqualTo(str : String) -> Bool {
        
        if self.uppercased() == str.uppercased() {
            
            return true
        }
        else{
            
            return false
        }
        
    }
    
    func validEmail() -> Bool
    {
        /*
         do {
         let regex = try NSRegularExpression(pattern:"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$", options: [.CaseInsensitive])
         return (regex.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.characters.count)) == 1)
         } catch {
         return false
         }
         */
        
        let regex = "^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.trim())
    }
    
    func validPhone() -> Bool
    {
        //        if(self.count < 14)
        //        {
        //            return false
        //        }
        //        return true
        /*
         do {
         let regex = try NSRegularExpression(pattern:"^((\\+)|(00))[0-9]{6,14}$", options: [.CaseInsensitive])
         return (regex.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.characters.count)) == 1)
         } catch {
         return false
         }
         */
        
        let regex = "^((\\+))[0-9]{6,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.trim())
    }
    
    func validPassword() -> Bool
    {
        return (self.trim()?.count)!>=6
    }
    
    func validNumber() -> Bool
    {
        let regex = "[0-9]"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.trim())
    }
    
    func validDouble() -> Bool
    {
        let regex = "^\\d+(\\.\\d+)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.trim())
    }
    
    func validURL() -> Bool
    {
        let regex = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self.trim())
    }
    
    func localURL() -> Bool
    {
        return !self.serverURL()
    }
    
    func serverURL() -> Bool
    {
        return !(self.index(of: "http:") == NSNotFound && self.index(of: "https:") == NSNotFound)
    }
    
    func URL() -> Foundation.URL? {
        if self.serverURL() {
            return Foundation.URL(string: self)
        } else {
            return Foundation.URL(fileURLWithPath: self)
        }
    }
    
    func index(of string: String) -> Int
    {
        return (self as NSString).range(of: string).location
    }
    
    func bundlePath() -> String?
    {
        return self.bundlePath(type: nil)
    }
    
    func bundlePath(type t:String?) -> String?
    {
        return Bundle.main.path(forResource: self, ofType: t)!
    }
    
    func homeDirPath() -> String
    {
        return NSHomeDirectory()
    }
    
    func documentDirPath() -> String?
    {
        return self.homeDirPath()+"/Documents"
    }
    
    func libraryDirPath() -> String?
    {
        return self.homeDirPath()+"/Library"
    }
    
    func cacheDirPath() -> String?
    {
        return self.homeDirPath()+"/Caches"
    }
    
    func truncate(by ellipsis:String, width:CGFloat, font:UIFont) -> String
    {
        /**
         * ellipsis = "..." OR "...Read More"
         * width = (widthOfSingleLine) * (numberOfLines need to display)
         * font = current text font
         */
        
        if ((self as NSString).size(withAttributes: [NSAttributedString.Key.font:font]).width < width) {
            return self
        }
        
        var width = width
        let truncatedString = NSMutableString(string: "\(self)\(ellipsis)")
        
        width -= (ellipsis as NSString).size(withAttributes: [NSAttributedString.Key.font:font]).width
        
        var range = truncatedString.range(of: ellipsis)
        range.length = 1
        
        while (truncatedString.size(withAttributes: [NSAttributedString.Key.font:font]).width > width && range.location > 0)
        {
            range.location -= 1
            truncatedString.deleteCharacters(in: range)
        }
        
        return truncatedString as String
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    
    // MARK: Convert NSTime Interval to String in Swift
    func durationString(duration: Double) -> String
    {
        let calender:Calendar = Calendar.current as Calendar
        
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute])
        let dateComponents = calender.dateComponents(unitFlags, from: Date(timeIntervalSince1970: duration), to: Date())
        //        let dateComponents = calender.dateComponents(unitFlags, from: Date(timeIntervalSince1970: duration), to: self.serverToLocal(date: currentDateTime)!)
        
        let years:NSInteger = dateComponents.year!
        let months:NSInteger = dateComponents.month!
        let days:NSInteger = dateComponents.day!
        let hours:NSInteger = dateComponents.hour!
        let minutes:NSInteger = dateComponents.minute!
        
        var durations:NSString = "Just Now"
        
        if (years > 0) {
            let strYear = years == 1 ? "year" : "years"
            durations = "\(years) \(strYear) ago" as NSString
        } else if (months > 0) {
            let strMonth = months == 1 ? "month" : "months"
            durations = "\(months) \(strMonth) ago" as NSString
        } else if (days > 0) {
            let strDay = days == 1 ? "day" : "days"
            durations = "\(days) \(strDay) ago" as NSString
        } else if (hours > 0) {
            let strHour = hours == 1 ? "hr" : "hrs"
            durations = "\(hours) \(strHour) ago" as NSString
        } else if (minutes > 0) {
            let strMins = minutes == 1 ? "min" : "mins"
            durations = "\(minutes) \(strMins) ago" as NSString
        }
        
        return durations as String
    }
    
    // MARK: Convert NSTime Interval to String in Swift
    func dateFromString(createdDate: String) -> String {
        
        var date = ""
        
        let arrDateAndTime = createdDate.components(separatedBy: " ")
        
        if arrDateAndTime.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//"yyyy-MM-dd HH:mm:ss"yyyy-MM-dd'T'HH:mm:ss.SSSZ
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date1 = dateFormatter.date(from: createdDate) {
                
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateFormatter.timeZone = TimeZone.current
                let strDate = dateFormatter.string(from: date1)
                date = strDate
            }
        }
        return date
    }
    
    
    func timeFromString(createdDate: String) -> String {
        
        var date = ""
        
        let arrDateAndTime = createdDate.components(separatedBy: " ")
        
        if arrDateAndTime.count > 0 {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss "//"yyyy-MM-dd HH:mm:ss"
            if let date1 = dateFormatter.date(from: createdDate) {
                
                dateFormatter.dateFormat = "HH:mm"
                let strDate = dateFormatter.string(from: date1)
                date = strDate
            }
        }
        return date
    }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Int
{
    func toString() -> String {
        let myString = String(self)
        return myString
    }
    
    
    func toMinSec() -> String {
        
        let (m,s) = ((self % 3600) / 60, (self % 3600) % 60)
        
        //        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        //        let s_string =  s < 10 ? "0\(s)" : "\(s)"
        
        let m_string = "\(m)"
        let s_string = s < 10 ? "0\(s)" : "\(s)"
        
        let minSec = m == 0 ? "\(s_string) Seconds" : "\(m_string):\(s_string) Minute"
        
        return minSec
    }
    
    func toMinuteSecond() -> String {
        
        let (m,s) = ((self % 3600) / 60, (self % 3600) % 60)
        
        //        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        //        let s_string =  s < 10 ? "0\(s)" : "\(s)"
        
        let m_string = "\(m)"
        let s_string = s < 10 ? "0\(s)" : "\(s)"
        
        let minSec = "\(m_string):\(s_string)"
        
        return minSec
    }
}


extension Date {
    func currentTimestamp() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
