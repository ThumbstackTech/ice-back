//
//  ExtentionDate.swift
//  GovCam
//
//  Created by Admin on 1/27/20.
//  Copyright © 2020 CMarix. All rights reserved.
//

import Foundation
import UIKit

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}

extension Date {

    var fullDate: String   { localizedDescription(dateStyle: .full,   timeStyle: .none) }
    var longDate: String   { localizedDescription(dateStyle: .long,   timeStyle: .none) }
    var mediumDate: String { localizedDescription(dateStyle: .medium, timeStyle: .none) }
    var shortDate: String  { localizedDescription(dateStyle: .short,  timeStyle: .none) }

    var fullTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .full) }
    var longTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .long) }
    var mediumTime: String { localizedDescription(dateStyle: .none,   timeStyle: .medium) }
    var shortTime: String  { localizedDescription(dateStyle: .none,   timeStyle: .short) }

    var fullDateTime: String   { localizedDescription(dateStyle: .full,   timeStyle: .full) }
    var longDateTime: String   { localizedDescription(dateStyle: .long,   timeStyle: .long) }
    var mediumDateTime: String { localizedDescription(dateStyle: .medium, timeStyle: .medium) }
    var shortDateTime: String  { localizedDescription(dateStyle: .short,  timeStyle: .short) }
}

extension Date {

    //func todayDate() -> String{
    static func todayDate() -> String{
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: today)
    }
    
    static func dateFormatFromString(dateStr: String,withDateFormat: String) -> String {
            
            //let strDate = Date.dateFormatFromString(dateStr: dateFormatterPrint.string(from: date ?? Date.init()))
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    //
    //        let calendarCurrent = Calendar.current
    //        dateFormatterGet.calendar = calendarCurrent
    //
            
            let dateFormatterPrint = DateFormatter()
            let calendar = Calendar.init(identifier: .gregorian)
            dateFormatterPrint.calendar = calendar
            
            dateFormatterPrint.dateFormat = withDateFormat//"dd/MM/yyyy"
         
            let date: Date? = dateFormatterGet.date(from: dateStr)
            //dPrint("Date",dateFormatterPrint.string(from: date ?? Date.init()))
            
          
            //dPrint(dateFormatterPrint.date(from: dateStr))
            return dateFormatterPrint.string(from: date ?? Date.init())
        }
}
