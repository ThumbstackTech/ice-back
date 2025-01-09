//  Networking.swift
//  OfficeTreePhone
//
//  Created by CMR010 on 10/10/22.
//

import Foundation
import Alamofire

// MARK: Networking Class

class Networking {

    typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?, _ statusCode: Int) -> Void
    typealias ClosureError   = (_ task:URLSessionTask, _ error:NSError?) -> Void
    
    var StageBaseURL: String = Global.sharedManager.isLive ? "https://api.ice-back.com"  : "https://api-staging.ice-back.com"    //Staging server
//    var StageBaseURL: String = "https://api.ice-back.com" // https://api.ice-back.com/    //Live server
    
    var loggingEnabled = true
    var statusCode = 0

    // Networking Singleton

    static let sharedInstance = Networking()
    
    private init() {

    }

    fileprivate func logging(request req:Request?) -> Void {
        if (loggingEnabled && req != nil) {
            var body:String = ""
            var length = 0

            if (req?.request?.httpBody != nil) {
                body = String.init(data: (req!.request!.httpBody)!, encoding: String.Encoding.utf8)!
                length = req!.request!.httpBody!.count
            }

            if (req?.request != nil) {
                let printableString = "\(req!.request!.httpMethod!) '\(req!.request!.url!.absoluteString)': \(String(describing: req!.request!.allHTTPHeaderFields)) \(body) [\(length) bytes]"

                print("API Request: \(printableString)")
            }
        }
    }
    

    func GET(param parameters: [String: Any]?, header: [String: String], tag: String?, success: ClosureSuccess?,  failure: ClosureError?) -> URLSessionTask? {
        
        let uRequest = SessionSharedManager.shared.request((StageBaseURL+tag!), method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header)
        self.logging(request: uRequest)

        uRequest.response { (response) in
            self.statusCode = (response.response?.statusCode) ?? 0
            
            guard let dataResponse = response.data ,
                response.error == nil else {
                    print(response.error?.localizedDescription ?? "Response Error")
                    failure!(uRequest.task!, response.error as NSError?)
                    return
            }
            
            // Check status code
            // If statuscode == 200 then parse the json in [String:Value] format
            // else display message from Server as a String value
            if self.statusCode == 200 {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    print(jsonResponse)
                    success!(uRequest.task!, jsonResponse as AnyObject, self.statusCode)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure!(uRequest.task!, response.error as NSError?)
                }
            } else if self.statusCode == 401 {
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.SESSIONEXPIREMESSAGE.localized(), withTimeoutImterval: 0.2)
                print("STAGE BASE 401,\(self.StageBaseURL + tag!)")
                Common.shared.doLogoutFromApp()
            } else if self.statusCode == 404 {
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.SESSIONEXPIREMESSAGE.localized(), withTimeoutImterval: 0.2)
                print("STAGE BASE 404,\(self.StageBaseURL + tag!)")
                Common.shared.doLogoutFromApp()
            } else {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    print(jsonResponse)

                    let dictResponse = jsonResponse
                    success!(uRequest.task!, dictResponse as AnyObject, self.statusCode)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure!(uRequest.task!, response.error as NSError?)
                }
            }
        }
        
        return uRequest.task
    }

    
    func requestPOSTURL(param parameters: [String: Any]?, header: [String: String], tag: String?, success: ClosureSuccess?, failure: ClosureError?) -> URLSessionTask? {
        let uRequest = SessionSharedManager.shared.request((StageBaseURL + tag!), method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
        
        self.logging(request: uRequest)

        uRequest.response { (response) in
            self.statusCode = (response.response?.statusCode) ?? 0
            
            guard let dataResponse = response.data ,
                response.error == nil else {
                    print(response.error?.localizedDescription ?? "Response Error")
                    failure!(uRequest.task!, response.error as NSError?)
                    return
            }

            // Check status code
            // If statuscode == 200 then parse the json in [String:Value] format
            // else display message from Server as a String value
            if self.statusCode == 200 {
                do {
                    if dataResponse.count > 0 {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        print(jsonResponse)
                        success!(uRequest.task!, jsonResponse as AnyObject, self.statusCode)
                    } else {
                        let jsonResponse = [CJsonMessage: "Success"]
                        success!(uRequest.task!, jsonResponse as AnyObject, self.statusCode)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                    failure!(uRequest.task!, parsingError as NSError)
                }
            } else if self.statusCode == 401 {
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.SESSIONEXPIREMESSAGE.localized(), withTimeoutImterval: 0.2)
                print("STAGE BASE 401,\(self.StageBaseURL + tag!)")
                Common.shared.doLogoutFromApp()
            } else if self.statusCode == 404 {
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.SESSIONEXPIREMESSAGE.localized(), withTimeoutImterval: 0.2)
                print("STAGE BASE 404,\(self.StageBaseURL + tag!)")
                Common.shared.doLogoutFromApp()
            }  else {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    print(jsonResponse)

                    let dictResponse = jsonResponse
                    success!(uRequest.task!, dictResponse as AnyObject, self.statusCode)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure!(uRequest.task!, parsingError as NSError)
                }
            }
        }
        
        return uRequest.task
    }
    
    func requestDELETEURL(param parameters: [String: Any]?, header: [String: String], tag: String?, success: ClosureSuccess?, failure: ClosureError?) -> URLSessionTask? {
        let uRequest = SessionSharedManager.shared.request((StageBaseURL + tag!), method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: header)
        
        self.logging(request: uRequest)

        uRequest.response { (response) in
            self.statusCode = (response.response?.statusCode) ?? 0
            
            guard let dataResponse = response.data ,
                response.error == nil else {
                    print(response.error?.localizedDescription ?? "Response Error")
                    failure!(uRequest.task!, response.error as NSError?)
                    return
            }

            // Check status code
            // If statuscode == 200 then parse the json in [String:Value] format
            // else display message from Server as a String value
            if self.statusCode == 200 {
                do {
                    if dataResponse.count > 0 {
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            dataResponse, options: [])
                        print(jsonResponse)
                        success!(uRequest.task!, jsonResponse as AnyObject, self.statusCode)
                    } else {
                        let jsonResponse = [CJsonMessage: "Success"]
                        success!(uRequest.task!, jsonResponse as AnyObject, self.statusCode)
                    }
                } catch let parsingError {
                    print("Error", parsingError)
                    failure!(uRequest.task!, parsingError as NSError)
                }
            } else if self.statusCode == 401 {
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.SESSIONEXPIREMESSAGE.localized(), withTimeoutImterval: 0.2)
                print("STAGE BASE 401,\(self.StageBaseURL + tag!)")
                Common.shared.doLogoutFromApp()
            } else if self.statusCode == 404 {
                PPAlerts.sharedAlerts().ToastAlert(message: AlertMsg.SESSIONEXPIREMESSAGE.localized(), withTimeoutImterval: 0.2)
                print("STAGE BASE 404,\(self.StageBaseURL + tag!)")
                Common.shared.doLogoutFromApp()
            } else {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        dataResponse, options: [])
                    print(jsonResponse)

                    let dictResponse = jsonResponse
                    success!(uRequest.task!, dictResponse as AnyObject, self.statusCode)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure!(uRequest.task!, parsingError as NSError)
                }
            }
        }
        
        return uRequest.task
    }
    
    
    //MARK: Upload image
    
    func requestPOSTImage(param parameters: [String: Any]?, tag: String?, imgData: [String: Data]?, headers : HTTPHeaders, multipartFormData: @escaping (MultipartFormData) -> Void, success: ClosureSuccess?, failure: ClosureError?) -> Void {
        SessionSharedManager.shared.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            for (key, value) in parameters! {
                if let value = value as? String {
                    multipart.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
                else if let value = value as? Int {
                    let strValue = String(value)
                    multipart.append(strValue.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
                
                if let arryReq = value as? Array<[String: AnyObject]> {
                    let str = self.notPrettyString(from: arryReq)!
                    multipart.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }
            
            let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
            if let dataImage = imgData {
                for (key, value) in dataImage {
                    multipart.append(value, withName: key, fileName: "\(currentTimeStamp).jpeg", mimeType: "image/jpeg")
                }
            }
            
            print(multipart)
        }, to: (StageBaseURL + tag!), method: HTTPMethod.post, headers: headers) { (encodingResult) in
            
            switch encodingResult {
            case .success(let uRequest, _, _):
                self.logging(request: uRequest)
                
                uRequest.uploadProgress(closure: { (progress) in
                    print("Progress for uploading pages \(progress.fractionCompleted)")
                })
                
                uRequest.responseJSON { (response) in
                    print(response)
                    self.statusCode = (response.response?.statusCode) ?? 0
                    
                    if(response.result.error == nil) {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject, self.statusCode)
                        }
                    } else {
                        if(failure != nil) {
                            failure!(uRequest.task!, response.result.error as NSError?)
                        }
                    }
                }
                
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }
    
    
    
    //MARK: -Multiple doc and Image
//    func requstPOSTMedia(param parameters: [String: Any]?, tag: String?, mediaData: [String: [Data]]?, headers : HTTPHeaders,mediaExtension:[SelectedMediaExtension], multipartFormData: @escaping (MultipartFormData) -> Void, success: ClosureSuccess?, failure: ClosureError?)  -> Void{
//        SessionSharedManager.shared.upload(multipartFormData: { (multipart) in
//            multipartFormData(multipart)
//
//            for (key, value) in parameters! {
//                if let value = value as? String {
//                    multipart.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//                }
//                else if let value = value as? Int {
//                    let strValue = String(value)
//                    multipart.append(strValue.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//                }
//
//                if let arryReq = value as? Array<[String: AnyObject]> {
//                    let str = self.notPrettyString(from: arryReq)!
//                    multipart.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
//                }
//            }
//
//            let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
////            if let dataImage = imgData {
////                for (key, value) in dataImage {
////                    multipart.append(value, withName: key, fileName: "\(currentTimeStamp).jpeg", mimeType: "image/jpeg")
////                }
////            }
//            if let dataMedia = mediaData{
//
//                dataMedia.forEach { i in
//                    for k in 0..<i.value.count{
//                        print("SELECTED..FILE NAME\(mediaExtension[k].fileName)")
//                        print("SELECTED..FILE TYPE\(mediaExtension[k].mimeType)")
//                        multipart.append(i.value[k], withName:i.key, fileName: "\(currentTimeStamp).\(mediaExtension[k].fileName)", mimeType: mediaExtension[k].mimeType)
//                    }
////                    i.value.forEach { k in
////                        print("kop..Va\(k)")
////                        //multipart.append(k, withName:i.key, fileName: "\(currentTimeStamp)", mimeType: <#T##String#>)
////                    }
//                }
//            }
//
//            print(multipart)
//            print(parameters)
//        }, to: (StageBaseURL + tag!), method: HTTPMethod.post, headers: headers) { (encodingResult) in
//
//            switch encodingResult {
//            case .success(let uRequest, _, _):
//                self.logging(request: uRequest)
//
//                uRequest.uploadProgress(closure: { (progress) in
//                    print("Progress for uploading pages \(progress.fractionCompleted)")
//                })
//
//                uRequest.responseJSON { (response) in
//                    print(response)
//                    self.statusCode = (response.response?.statusCode) ?? 0
//
//                    if(response.result.error == nil) {
//                        if(success != nil) {
//                            success!(uRequest.task!, response.result.value as AnyObject, self.statusCode)
//                        }
//                    } else {
//                        if(failure != nil) {
//                            failure!(uRequest.task!, response.result.error as NSError?)
//                        }
//                    }
//                }
//
//                break
//            case .failure(let encodingError):
//                print(encodingError)
//                break
//            }
//        }
//    }
//
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    
    //MARK: - Document updlaod
    func requestPOSTImageDocument(param parameters: [String: Any]?, tag: String?, imgData: [String: Data]?,file_name:String,mime_Type:String, headers : HTTPHeaders, multipartFormData: @escaping (MultipartFormData) -> Void, success: ClosureSuccess?, failure: ClosureError?) -> Void {
        SessionSharedManager.shared.upload(multipartFormData: { (multipart) in
            multipartFormData(multipart)
            
            for (key, value) in parameters! {
                if let value = value as? String {
                    multipart.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
                else if let value = value as? Int {
                    let strValue = String(value)
                    multipart.append(strValue.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
                
                if let arryReq = value as? Array<[String: AnyObject]> {
                    let str = self.notPrettyString(from: arryReq)!
                    multipart.append(str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
            }
            
            let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
            if let dataImage = imgData {
                for (key, value) in dataImage {
                    multipart.append(value, withName: key, fileName: "\(currentTimeStamp).\(file_name)", mimeType:mime_Type)
                }
            }
            
            print(multipart)
        }, to: (StageBaseURL + tag!), method: HTTPMethod.post, headers: headers) { (encodingResult) in
            
            switch encodingResult {
            case .success(let uRequest, _, _):
                self.logging(request: uRequest)
                
                uRequest.uploadProgress(closure: { (progress) in
                    print("Progress for uploading pages \(progress.fractionCompleted)")
                })
                
                uRequest.responseJSON { (response) in
                    print(response)
                    self.statusCode = (response.response?.statusCode) ?? 0
                    
                    if(response.result.error == nil) {
                        if(success != nil) {
                            success!(uRequest.task!, response.result.value as AnyObject, self.statusCode)
                        }
                    } else {
                        if(failure != nil) {
                            failure!(uRequest.task!, response.result.error as NSError?)
                        }
                    }
                }
                
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }

}

class SessionSharedManager {

    static let shared =  SessionManager()

    private init() {}
}
