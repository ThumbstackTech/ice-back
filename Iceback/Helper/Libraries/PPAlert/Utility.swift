//
//  Utility.swift
//  Iceback
//
//  Created by Admin on 12/01/24.
//

import Foundation
import UIKit

class Utility: NSObject {
  // MARK: - Email Validation -
  
  class func isValidEmail(strEmail : String) -> Bool {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: strEmail)
  }
  class func isValidPassword(strPassword:String?) -> Bool {
    // least one uppercase,
    // least one digit
    // least one lowercase
    // least one symbol
    //  min 6 and max 100 characters total
    guard let strPassword = strPassword else { return false }
    let password = strPassword.trimmingCharacters(in: CharacterSet.whitespaces)
    let passwordRegx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#.])[A-Za-z\\d$@$!%*?&#.]{8,100}"
    let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
    return passwordCheck.evaluate(with: password)
    
  }
  
  class func isNameValid(strName:String?) -> Bool {
    
    guard let strName = strName else { return false }
    let name = strName.trimmingCharacters(in: CharacterSet.whitespaces)
    let nameRegx = "[A-Za-z]{2,100}"
    let nameCheck = NSPredicate(format: "SELF MATCHES %@",nameRegx)
    return nameCheck.evaluate(with: name)
    
  }
  class func isCardNumberValid(strNumber:String?) -> Bool {
    
    guard let strCardNo = strNumber else { return false }
    let cardNoRegx = "[0-9 ]{19}"
    let cardNoCheck = NSPredicate(format: "SELF MATCHES %@",cardNoRegx)
    return cardNoCheck.evaluate(with: strCardNo)
  }
  class func isAccountNumberValid(strNumber:String?) -> Bool {
    
    guard let strCardNo = strNumber else { return false }
    let cardNoRegx = "[0-9]{6,10}"
    let cardNoCheck = NSPredicate(format: "SELF MATCHES %@",cardNoRegx)
    return cardNoCheck.evaluate(with: strCardNo)
  }
  
  class func isBSBNumberValid(strNumber:String?) -> Bool {
    
    guard let strCardNo = strNumber else { return false }
    let cardNoRegx = "[0-9,-]{7,7}"
    let cardNoCheck = NSPredicate(format: "SELF MATCHES %@",cardNoRegx)
    return cardNoCheck.evaluate(with: strCardNo)
  }
  
  class func isPhoneNumberValid(strPhoneNo:String?) -> Bool {
    guard let strPhone = strPhoneNo else { return false }
    let number = strPhone.trimmingCharacters(in: CharacterSet.whitespaces)
    let numberRegx = "[0-9]{7,15}"
    let numberCheck = NSPredicate(format: "SELF MATCHES %@",numberRegx)
    return numberCheck.evaluate(with: number)
  }
  
  class func fullNameValid(strFullName:String?,isFullName:Bool = false) -> Bool{
    let characterset = CharacterSet(charactersIn: isFullName ? "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ " :"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    if strFullName?.rangeOfCharacter(from: characterset.inverted) == nil {
      dPrint("string contains special characters")
      return true
    }
    return false
  }
  
  class func searchTextValid(strSearch:String?) -> Bool{
    guard let strSearch = strSearch else { return false }
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$@$!%*?&#. ")
    if !strSearch.blank() {
      dPrint("string does not contains only whites spaces")
      return true
    }
    return false
  }
  
  class func numberPadValid(strNumberPad:String?,isAmount:Bool = false) -> Bool{
    
    let characterset = CharacterSet(charactersIn: isAmount ? "0123456789." : "0123456789")
    if strNumberPad?.rangeOfCharacter(from: characterset.inverted) == nil {
      dPrint("string contains special characters")
      return true
    }
    return false
  }
  
  class func couponPercentageMultipleAttribute(discountValue: Double, isCHF: Bool = false) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app00000070,
      .font: AFont(size: 15, type: .Roman)
    ]
    let couponPercentage:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 20, type: .Black)
    ]
    
    let checkValue = removeDecimalIfZero(from: discountValue)
    let value = removeDecimalIfZero(from: discountValue)
    
    let partOne = NSMutableAttributedString(string: "Up to ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: "\(isCHF ?  value : checkValue) ", attributes: couponPercentage)
    let partThree = NSMutableAttributedString(string: isCHF ? "CHF " : "% ", attributes: couponPercentage)
    let partFour = NSMutableAttributedString(string: "Cashback".localized(), attributes: staticAttributes)
    
    partOne.append(partTwo)
    partOne.append(partThree)
    partOne.append(partFour)
    
    
    return partOne
    
    
    
  }
  class func minimumCashbackAttribute(discountValue: Double) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app00000070,
      .font: AFont(size: 15, type: .Roman)
    ]
    let couponPercentage:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 16, type: .Black)
    ]
    
    let checkValue = removeDecimalIfZero(from: discountValue)
    
    let partOne = NSMutableAttributedString(string: "Minimum Cashback up to ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: "\(checkValue) ", attributes: couponPercentage)
    let partThree = NSMutableAttributedString(string: "CHF ", attributes: couponPercentage)
    
    partOne.append(partTwo)
    partOne.append(partThree)
    
    
    return partOne
    
    
    
  }
  class func reportIssuesDescription(str: String) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app000000,
      .font: AFont(size: 15, type: .Black)
    ]
    let shippingDetail:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 16, type: .Roman)
    ]
    
    let partOne = NSMutableAttributedString(string: "Description: ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: str, attributes:shippingDetail)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func userActivitiesDescription(str: String, title: String) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app000000,
      .font: AFont(size: 15, type: .Black)
    ]
    let shippingDetail:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 16, type: .Roman)
    ]
    
    let partOne = NSMutableAttributedString(string: "\(title): ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: str, attributes:shippingDetail)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func reportIssuesSubject(str: String) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app000000,
      .font: AFont(size: 15, type: .Black)
    ]
    let shippingDetail:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 16, type: .Roman)
    ]
    
    let partOne = NSMutableAttributedString(string: "Subject: ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: str, attributes:shippingDetail)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func couponShippingDetail(shippingAddress: String) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app000000,
      .font: AFont(size: 14, type: .Roman)
    ]
    let shippingDetail:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 16, type: .Black)
    ]
    
    let partOne = NSMutableAttributedString(string: "Shipping: ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: shippingAddress, attributes:shippingDetail)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func couponCode(code: String) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app000000,
      .font: AFont(size: 14, type: .Roman)
    ]
    let deliveryTimeDetail:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 16, type: .Black)
    ]
    
    let partOne = NSMutableAttributedString(string: "Coupon Code: ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: code, attributes:deliveryTimeDetail)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func couponExpirationDate(expirayDate: String) -> NSMutableAttributedString {
    
    let staticAttributes:[NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.app000000,
      .font: AFont(size: 13, type: .Roman)
    ]
    let expirayDateDetail:[NSAttributedString.Key: Any] = [
      .foregroundColor:UIColor.app000000,
      .font: AFont(size: 14, type: .Black)
    ]
    
    let partOne = NSMutableAttributedString(string: "Expiry Date: ".localized(), attributes: staticAttributes)
    let partTwo = NSMutableAttributedString(string: expirayDate, attributes:expirayDateDetail)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func getFormattedDateFromString(dateStr: String, withDateFormat: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
    
    let dateFormatterPrint = DateFormatter()
    let calendar = Calendar.init(identifier: .gregorian)
    dateFormatterPrint.calendar = calendar
    dateFormatterPrint.dateFormat = withDateFormat
    
    let date: Date? = dateFormatterGet.date(from: dateStr)
    return dateFormatterPrint.string(from: date ?? Date.init())
  }
  
  class  func termsAndPrivacymultipleAttribute() -> NSMutableAttributedString{
    let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app000000, NSAttributedString.Key.font:  AFont(size: 14, type: .Roman)]
    let attributes: [NSAttributedString.Key: Any] = [
      .underlineColor: UIColor.app1F8DFF ,
      .foregroundColor:UIColor.app1F8DFF,
      .underlineStyle:NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font:  AFont(size: 14, type: .Black)
    ]
    let termsAttributes = attributes
    
    let partOne = NSMutableAttributedString(string: "I Accept all the ".localized(), attributes: yourAttributes)
    let partTwo = NSMutableAttributedString(string: LABELTITLE.TERMTITLE.localized(), attributes: termsAttributes)
    let partFive = NSMutableAttributedString(string: " of the Iceback Application.".localized(), attributes: yourAttributes)
    
    partOne.append(partTwo)
    partOne.append(partFive)
    
    return partOne
  }
  
  class  func otpResendMultipleAttribute() -> NSMutableAttributedString{
    let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app000000, NSAttributedString.Key.font:  AFont(size: 14, type: .Roman)]
    let attributes: [NSAttributedString.Key: Any] = [
      .underlineColor: UIColor.app1F8DFF ,
      .foregroundColor:UIColor.app1F8DFF,
      .underlineStyle:NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font:  AFont(size: 14, type: .Black)
    ]
    let otpResendAttributes = attributes
    
    let partOne = NSMutableAttributedString(string: "Didn’t receive the code? ", attributes: yourAttributes)
    let partTwo = NSMutableAttributedString(string: "Resend", attributes: otpResendAttributes)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class  func loginMultipleAttribute() -> NSMutableAttributedString{
    let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app000000, NSAttributedString.Key.font:  AFont(size: 14, type: .Medium)]
    let attributes: [NSAttributedString.Key: Any] = [
      .underlineColor: UIColor.app1F8DFF ,
      .foregroundColor:UIColor.app1F8DFF,
      .underlineStyle:NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font:  AFont(size: 14, type: .Black)
    ]
    let termsAttributes = attributes
    let andAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app000000]
    
    let partOne = NSMutableAttributedString(string: "Already have an account? ".localized(), attributes: yourAttributes)
    let partTwo = NSMutableAttributedString(string: LABELTITLE.LOGIN.localized(), attributes: termsAttributes)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class  func signUpMultipleAttribute() -> NSMutableAttributedString{
    let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app000000, NSAttributedString.Key.font:  AFont(size: 15, type: .Medium)]
    let attributes: [NSAttributedString.Key: Any] = [
      .underlineColor: UIColor.app1F8DFF ,
      .foregroundColor:UIColor.app1F8DFF,
      .underlineStyle:NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font:  AFont(size: 14, type: .Black)
    ]
    let termsAttributes = attributes
    let andAttributes = [NSAttributedString.Key.foregroundColor: UIColor.app000000]
    
    let partOne = NSMutableAttributedString(string: "Don’t have an account? ".localized(), attributes: yourAttributes)
    let partTwo = NSMutableAttributedString(string: LABELTITLE.SIGNUP.localized(), attributes: termsAttributes)
    
    partOne.append(partTwo)
    
    return partOne
  }
  
  class func alreadyMember()-> NSMutableAttributedString {
    let attributeString : [NSAttributedString.Key: Any] = [
      .underlineColor: UIColor.app1F8DFF ,
      .foregroundColor:UIColor.app1F8DFF,
      .underlineStyle:NSUnderlineStyle.single.rawValue,
      NSAttributedString.Key.font:  AFont(size: 14, type: .Heavy)
    ]
    
    let str = NSMutableAttributedString(string:LABELTITLE.ALREADYMEMBER.localized(), attributes: attributeString)
    return str
  }
  //    
  
  static func isObjectOrValueAvailable(someObject: Any?) -> Any? {
    if someObject is String {
      
      if let someObject = someObject as? String {
        
        return someObject
      } else {
        
        return ""
      }
    } else if someObject is Array<Any> {
      
      if let someObject = someObject as? Array<Any> {
        
        return someObject
      } else {
        
        return []
      }
    } else if someObject is Dictionary<AnyHashable, Any> {
      
      if let someObject = someObject as? Dictionary<String, Any> {
        
        return someObject
      } else {
        
        return [:]
      }
    } else if someObject is Data {
      
      if let someObject = someObject as? Data {
        
        return someObject
      } else {
        
        return Data()
      }
    } else if someObject is NSNumber {
      
      if let someObject = someObject as? NSNumber{
        
        return someObject
      } else {
        
        return NSNumber.init(booleanLiteral: false)
      }
    } else if someObject is UIImage {
      
      if let someObject = someObject as? UIImage {
        
        return someObject
      } else {
        
        return UIImage()
      }
    } else {
      return ""
    }
  }
}

//MARK: - Decode JWT token code

func decode(jwtToken jwt: String) -> [String: Any] {
  let segments = jwt.components(separatedBy: ".")
  return decodeJWTPart(segments[1]) ?? [:]
}

func base64UrlDecode(_ value: String) -> Data? {
  var base64 = value
    .replacingOccurrences(of: "-", with: "+")
    .replacingOccurrences(of: "_", with: "/")
  
  let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
  let requiredLength = 4 * ceil(length / 4.0)
  let paddingLength = requiredLength - length
  if paddingLength > 0 {
    let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
    base64 = base64 + padding
  }
  return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}

func decodeJWTPart(_ value: String) -> [String: Any]? {
  guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
    return nil
  }
  
  return payload
}

