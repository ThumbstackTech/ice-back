//
//  ExtensionDouble.swift
//  Iceback
//
//  Created by Admin on 29/01/24.
//

import Foundation

func removeDecimalIfZero(from doubleValue: Double) -> String {
    let formattedString = doubleValue.truncatingRemainder(dividingBy: 1) == 0 ?
        String(format: "%.0f", doubleValue) :
        String(doubleValue)
    
    return formattedString
}

func removeDecimalIfZeroTwoDigit(from doubleValue: Double) -> String {
    let formattedString = String(format: "%g", doubleValue)
    return formattedString
}
