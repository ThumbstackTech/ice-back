//
//  Common.swift
//  Catalogue
//
//  Created by CTPLMac8 on 25/06/18.
//  Copyright © 2018 Cmarix Technolab Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AVFoundation
import WebKit
import SafariServices

let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

class Common {
    
    static let shared = Common()
    var appName : String
    var preference : UserDefaults
    var screenWidth : CGFloat
    var screenHeight : CGFloat
    
    var appVersion : String
    var appBuildVersion : String
    
    var decryptKey : String
    var decryptIv : String
    
    var time: Double = 0
    
    /*var timer = Timer()
     var startTime: Double = 0
     //var time: Double = 0
     var elapsed: Double = 0*/
    
    init() {
        
        appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        preference = UserDefaults.standard
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        appBuildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        
        decryptKey = "@Mt#eR@nD0mKey2|)<cRy|>Tp@s$w0rD"
        decryptIv = "Y0|_|N<eDey<2iN!"
    }
    
    func roundCorners(view:UIView,corners: UIRectCorner, radius: CGFloat) {
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
            
            view.clipsToBounds = true
            view.layer.cornerRadius = radius
            view.layer.maskedCorners = maskedCorners
        } else {
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    func roundCornersBottomLeftRight(view:UIView, radius: CGFloat) {
        view.clipsToBounds = true
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func updateThemeColor(view:CardView,color:UIColor,label:UILabel) {
        label.textColor = color
        view.layer.borderColor = color.cgColor
        view.firstColor = UIColor.clear
        view.secondColor = UIColor.clear
        view.backgroundColor = color
    }
    
    //Converter
    
    func convertDateFormater(inputDate: String, input: String, output: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = input
        let dateInput = dateFormatter.date(from: inputDate)
        dateFormatter.dateFormat = output
        return dateFormatter.string(from: dateInput!)
    }
    //start - 19-4-24
    class func getDateFormattedFromString(dateStr: String, recievedDateFormat: String, convertedDateFormat: String) -> String? {
        //            let strDate: String = dateStr.replacingOccurrences(of: "T", with: " ")
        let dateFormatter = DateFormatter()
        //            dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = recievedDateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if !dateStr.isEmpty, let date = dateFormatter.date(from: dateStr) {
            dateFormatter.dateFormat = convertedDateFormat
            return dateFormatter.string(from: date)
        }
        return nil
    } //end - 19-4-24
    
    
    // MARK: - Preference -
    
    func setPreference(strKey : String, value : String) {
        
        preference.set(value, forKey: strKey)
        preference.synchronize()
    }
    
    func getPreference(strKey : String) -> String {
        
        return preference.string(forKey:strKey) ?? ""
    }
    
    
    // MARK: - Remove White Space -
    
    func removeWhiteSpaceFromString(str : String) -> String {
        
        if str.count > 0 {
            
            let trimmedString = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            return trimmedString
        }
        else{
            
            return ""
        }
        
    }
    
    //MARK:- API Call convert in string
    func jsonConvertInStaring(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    // MARK: - Alert  -
    
    func showAlert(strMsg : String, vc : UIViewController, completion: @escaping () -> Void)  {
        
        let alert = UIAlertController.init(title: appName, message: strMsg, preferredStyle: UIAlertController.Style.alert)
        
        let actionOk = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
            
            completion()
        }
        alert.addAction(actionOk)
        vc.present(alert, animated: true) {
            
        }
        
    }
    
    
    //MARK: - Create Invoice Folder
    func createInvoiceFolder() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        let dataPath = docURL.appendingPathComponent("Invoice")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
               dPrint(error.localizedDescription);
            }
        } else {
           dPrint("Folder already exist")
        }
       dPrint("Dir Path = \(dataPath)")
    }
    
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return outputImage!
    }
    func encrypt(str: String) -> String {
        let ke = self.decryptKey
        let iv = self.decryptIv
        var strTemp = ""
        do {
            let aes = try AES256(key: ke.data(using: .utf8)!, iv: iv.data(using: .utf8)!)
            let encrypted = try aes.encrypt(str.data(using: .utf8)!)
           dPrint("encrypted --> ", encrypted.base64EncodedString())
            strTemp = encrypted.base64EncodedString()
        } catch {
            
        }
        return strTemp
    }
    
    func decrypt(str: String) -> String {
        let ke = self.decryptKey
        let iv = self.decryptIv
        var strTemp = ""
        
        do {
            let aes = try AES256(key: ke.data(using: .utf8)!, iv: iv.data(using: .utf8)!)
            let decrptedData = NSData(base64Encoded: str)
            let decrypted = try aes.decrypt(decrptedData! as Data)
            strTemp = String(decoding: decrypted, as: UTF8.self)
           dPrint("decrypted --> ", str)
        } catch {
            
        }
        
        return strTemp
    }
    
    
    //MARK: - Log Out
    func doLogoutFromApp()  {
        UserDefaultHelper.isLogin = false
        UserDefaultHelper.acessToken = ""
        UserDefaultHelper.referral_link = ""
        UserDefaultHelper.user_id = 0
        UserDefaultHelper.selectedTabIndex = 0
        Global.destroySharedManager()
        
        appDelegate.arrNavigationStack = []
        
        let dataTypes = Set([WKWebsiteDataTypeCookies, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeSessionStorage, WKWebsiteDataTypeWebSQLDatabases, WKWebsiteDataTypeIndexedDBDatabases])
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: NSDate.distantPast, completionHandler: {})
        
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
        GCDMainThread.asyncAfter(deadline: .now() + 0.5) {
            let vc : LoginVC = LoginVC.instantiate(appStoryboard: .main)
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            appDelegate.window?.rootViewController = navController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    //MARK: - Time stamp to date string -
    
    func dateStringFromTimeStamp(timeStamp : String,format : String) -> String {
        
        let df = DateFormatter.init()
        df.dateFormat = format
        
        let date = Date.init(timeIntervalSince1970: Double(timeStamp)!)
        
        return df.string(from: date)
    }
    
    func countBytesInMB(withData data : Data) -> String {
        
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        
        return bcf.string(fromByteCount: Int64(data.count))
    }
    
    func getCurrentTimeStamp() -> String {
        
        let timestamp = Date().timeIntervalSince1970
        
        var strTimeStamp = "\(timestamp)"
        
        strTimeStamp = strTimeStamp.replacingOccurrences(of: ".", with: "")
        
        return strTimeStamp
    }
    
    // MARK :- Fetch Image From The URL
    func getImage(assetUrl: URL) -> UIImage?  {
        var image = UIImage()
        let data = NSData(contentsOf: assetUrl)
        if let img = UIImage(data: data! as Data) {
            image = img
        }
        return image
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
           dPrint(thumbnail.size.width)
           dPrint(thumbnail.size.height)
            return thumbnail.getThumbnailFromVideo(size: thumbnail.size.height)
        } catch let error {
           dPrint("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func objectToJSONString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func getFilteredVideoData(path: URL) -> NSData? {
        if let data = NSData(contentsOf: path) {
            return data
        }
        return nil
    }
    
    //MARK:- get formated duration from seconds.
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
       dPrint(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let localDate = dateFormatter.date(from: date)
        
        return localDate
    }
    
    
    func UTCToLocal(dateInput:String) -> String? {
        
       dPrint("Input Time ----> \(dateInput)")
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions =  [.withInternetDateTime, .withFractionalSeconds]
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let dateISO = dateFormatter.date(from: dateInput){
            
           dPrint("dateISO = \(dateISO)")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            formatter.timeZone = TimeZone.current
            formatter.string(from: dateISO)
            
           dPrint("Local Time ----> \(formatter.string(from: dateISO))")
            
            return formatter.string(from: dateISO)
            
        }else{
            
            return dateInput
        }
    }
    
}

// MARK: - Classes -
// MARK: - Connectivity -
class Connectivity
{
    class var isConnectedToInternet:Bool
    {
        //return NetworkReachabilityManager()!.isReachable
        
        return checkForInternetPermission
    }
    
    private class var checkForInternetPermission : Bool {
        
        
        if NetworkReachabilityManager()!.isReachable{
            return true
        }
        else {
            return false
        }
        
    }
    
    
    
    class var checkForWifiOr4g : String {
        
        if NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi  {
            
            return "wifi"
        }
        else if NetworkReachabilityManager()!.isReachableOnWWAN {
            
            return "4g"
        }
        else{
            return "not reachable"
        }
    }
    
}



//MARK: - Extensions -

extension UIViewController{
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
       return (view.window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 20.0) +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func setTitleView() {
        
        let iv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 62.5, height: 25.83))
        iv.contentMode = UIView.ContentMode.scaleAspectFit
        //   iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "couchshoprlogo")
        self.navigationItem.titleView = iv
    }
    
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = UIActivityIndicatorView.Style.medium;
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        //  UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    func stopLoading(){
        activityIndicator.stopAnimating();
        //  UIApplication.shared.endIgnoringInteractionEvents();
    }
    
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension UIView {
    
    func setShadowToView()  {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 1.5
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    }
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
    
    
}

extension UINavigationController {
    
    func makeNavigationBarTransperent()  {
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        
    }
}

extension String {
    
    var convertStringToCurrency : String {
        
        let number = Double(self)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        return formatter.string(from: number! as NSNumber)!
        
        
    }
    
    var convertCurrencyToString : String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        let number = formatter.number(from: self)
        
        return (number?.stringValue)!
    }
    
}

func dPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #endif
}
