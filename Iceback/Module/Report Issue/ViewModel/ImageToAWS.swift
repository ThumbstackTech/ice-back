//
//  ImageToAWS.swift
//  Iceback
//
//  Created by Jeegnasa Mudsa on 19/04/24.
//

import Foundation
import AWSS3
import ObjectMapper


enum S3Bucket : String {
    case kAWSAccessKeyId                       = "AKIA4J5QP2VEQZVL3NF7"
    case kAWSSecretKey                         = "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"
    case kAWSDocumentPathIssueImage            = "issue_image/"
    case kAWSDocumentPathProfileImage          = "profiles/"
    
    static func getPath(key : S3Bucket) -> String? {
         if key == S3Bucket.kAWSDocumentPathIssueImage {
            return S3Bucket.kAWSDocumentPathIssueImage.rawValue
        } else  if key == S3Bucket.kAWSDocumentPathProfileImage {
            return S3Bucket.kAWSDocumentPathProfileImage.rawValue
        } else {
            return nil
        }
    }
}

class ImageUpload: NSObject {
    
    static let shared                   : ImageUpload = ImageUpload()
    var completionHandler               : AWSS3TransferUtilityUploadCompletionHandlerBlock?
    var progressBlock                   : AWSS3TransferUtilityProgressBlock?
    
    
    func uploadImage(_ showLoader : Bool = true,
                     _ image : UIImage,
                     _ mimeType : String,
                     _ imageType : S3Bucket,
                     _ index : Int? = nil,
                     strVideoThumb : String? = "",
                     withBlock completion : ((_ fullPath : String? , _ lastPathComponent : String?, _ index: Int?) -> Void)?) {
        
        if showLoader {
          //  GFunction.shared.addLoader()
        }
        //S3 bucket setup
        let credentialsProvider : AWSStaticCredentialsProvider = AWSStaticCredentialsProvider(accessKey: S3Bucket.kAWSAccessKeyId.rawValue, secretKey: S3Bucket.kAWSSecretKey.rawValue)
        
        let configuration : AWSServiceConfiguration = AWSServiceConfiguration(region: AWSRegionType.EUCentral1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let name = "\(self.getRandomString()).jpeg"
        guard let key = S3Bucket.getPath(key: imageType) else { return }
        let remotePath = key + name
        //keyPathName(name: remotePath)
        let transferUtility = AWSS3TransferUtility.default()
        
        let expression = AWSS3TransferUtilityUploadExpression()
        
        expression.progressBlock = { (task: AWSS3TransferUtilityTask,progress: Progress) -> Void in
            print(progress.fractionCompleted)   //2
            if progress.isFinished{           //3
                print("Upload Finished...")
                //do any task here.
            }
        }

        
        self.progressBlock = {(task, progress) in
            print(progress)
        }
        
        self.completionHandler = { (task, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    if showLoader {
                      //  GFunction.shared.removeLoader()
                    }
                    if let completion = completion {
                        completion(nil, nil, index)
                    }
                }
                else{
                    print(kAWSPath + remotePath)
                    if let completion = completion {
                        completion(kAWSPath + remotePath, remotePath, index)
                    }
                }
            })
        }
        
        func uploadImage(with data: Data) {
          //  let expression = AWSS3TransferUtilityUploadExpression()
            expression.setValue("public-read", forRequestHeader: "x-amz-acl")
            expression.setValue("\(image.size.height)", forRequestHeader: "x-amz-meta-height")
            expression.setValue("\(image.size.width)", forRequestHeader: "x-amz-meta-width")
            
            expression.progressBlock = progressBlock
            
            transferUtility.uploadData(
                data,
                bucket : kAWSBucket,
                key: remotePath,
                contentType: mimeType,
                expression: expression,
                completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                    if let error = task.error {
                        print("Error: \(error.localizedDescription)")
                    }
                    
                    if let result = task.result {
                        print(result)
                    }
                    
                    return nil;
            }
        }
        let quality : CGFloat = 0.6
        if let data = image.jpegData(compressionQuality: quality) {
            uploadImage(with: data)
        }
        
    }
        
    func getSizeOfData(data : Data) -> String {
        let byteCount = data.count//512_000 // replace with data.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(byteCount))
        print(string)
        if byteCount == 0 {
            return "0"
        }
        return string
    }
    
    func getTimeStampFromDate() -> (double : Double,string : String) {
        
        let timeStamp = Date().timeIntervalSince1970
        return (timeStamp,String(format: "%f", timeStamp))
    }
    
    func getRandomString(length: Int = 10) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        let timeStamp = self.getTimeStampFromDate()
        return randomString + "\(String(format: "%0.0f", timeStamp.double))"
    }
    


}
