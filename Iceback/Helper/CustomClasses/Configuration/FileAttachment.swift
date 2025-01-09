//
//  FileAttachment.swift
//  Spot-O
//
//  Created by macmini on 6/23/20.
//  Copyright © 2020 Spot-O. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import QuickLook

public protocol FileAttachmentDelegate: class {
  func didSelect(file: URL?)
}

class FileAttachment: NSObject {
    private var pickerController: CustomDocumentPickerViewController = CustomDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypeText as String, kUTTypeContent as String], in: .import)
    private var quickViewController = QLPreviewController()
    private weak var presentationController: UIViewController?
    private weak var delegate: FileAttachmentDelegate?
    private var files:[URL] = []
    public override init() {
        super.init()
    }
    
    public func present(presentationController: UIViewController, delegate: FileAttachmentDelegate) {
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.allowsMultipleSelection = false
        self.pickerController.delegate = self
        self.presentationController!.present(pickerController, animated: true, completion: nil)
    }
    
    public func previewFile(presentationController: UIViewController, data:[URL]?) {
        self.presentationController = presentationController
        let navbar = UINavigationBar.appearance(whenContainedInInstancesOf: [QLPreviewController.self])
        navbar.setBackgroundImage(self.imageWithColor(color: .clear), for: UIBarMetrics.default)
        if let attachFiles = data {
            files = attachFiles
        }
        quickViewController.dataSource = self
        quickViewController.reloadData()
        DispatchQueue.main.async {
            self.presentationController!.present(self.quickViewController, animated: true, completion: nil)
        }
    }
    
    
    private func pickerController(_ controller: UIDocumentPickerViewController, didSelect file: URL?) {
        self.delegate?.didSelect(file: file)
      controller.dismiss(animated: true, completion: nil)
    }
    
   private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        let alpha = color.cgColor.alpha
        let opaque = alpha == 1
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func downloadfile(item: String, completion: @escaping (_ success: Bool,_ fileLocation: URL?, _ error: String?) -> Void){
        var fileUrl: URL!
        if let itemUrl = URL(string: item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            fileUrl = itemUrl
        } else if let itemUrl = URL(string: item) {
            fileUrl = itemUrl
        }
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileUrl.lastPathComponent)
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            do {
                try FileManager.default.removeItem(at: destinationUrl)
            }
            catch {
                print("Error while removing file from directory")
            }
        }
        
        // you can use NSURLSession.sharedSession to download the data asynchronously
        URLSession.shared.downloadTask(with: fileUrl, completionHandler: { (location, response, error) -> Void in
            guard let tempLocation = location, error == nil else {
                completion(false, nil, error?.localizedDescription)
                return
            }
            do {
                // after downloading your file you need to move it to your destination url
                try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                print("File moved to documents folder")
                completion(true, destinationUrl, nil)
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(false, nil, error.localizedDescription)
            }
        }).resume()
    }
    
}

extension FileAttachment {
    
    func getDirectoryPath() -> URL? {
            
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("TephraDocs")
            
            if let url = URL(string: path){
                return url
            }
            print("PATH>>>>>>>>>>>>> \(path)")
            return nil
        }
        
        //save image into document directory
        func saveImageDocumentDirectory(image: UIImage? = nil, video: Data? = nil, imageName: String) {
            
            let fileManager = FileManager.default
            
            if let path = getDirectoryPath()?.absoluteString {
                
                if !fileManager.fileExists(atPath: path) {
                    try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                }
                
                let url = URL(string: path)
                let imagePath = url!.appendingPathComponent(imageName)
                let urlString: String = imagePath.absoluteString
                
                if video != nil {
                    fileManager.createFile(atPath: urlString as String, contents: video, attributes: nil)
                } else {
                    let imageData = image?.jpegData(compressionQuality: 1.0)
                    fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
                }
            }
        }
        
        // get image into document Directiry
        func getImageFromDocumentDirectory(imageName: String) -> UIImage? {
           
            let fileManager = FileManager.default
            
            if let Path = getDirectoryPath(){
                
                let imagePath = Path.appendingPathComponent(imageName)
                
                let urlString: String = imagePath.absoluteString
                
                if fileManager.fileExists(atPath: urlString) {
                    
                    let image = UIImage(contentsOfFile: urlString)
                    return image!
                    
                } else {
                    
                    return nil
                }
                
            }
            
            return nil
        }
        
        
        func getImagePathFromName(imageName: String) -> String {
         
            if let Path = getDirectoryPath(){
            
                let imagePath = Path.appendingPathComponent(imageName)
                
                return imagePath.path
            
            }
            return ""
        }

        // Delete image from the document directory
        func deleteImageFromDocumentDirectory(imageName: String) {
            
            let fileManager = FileManager.default
            
            if let Path = getDirectoryPath(){
                
                let imagePath = Path.appendingPathComponent(imageName)
                let urlString: String = imagePath.absoluteString
                
                if fileManager.fileExists(atPath: urlString) {
                    do {
                        try fileManager.removeItem(atPath: urlString)
                    } catch {
                        print("Couldn't delete Image directory")
                    }
                }
            }
        }
        
    // Get video URL
        func getVideoFromDocumentDirectory(videoName: String) -> URL {
            
            let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString)
            let strDocumentsUrl = documentsDirectory.appendingPathComponent(videoName)
            return URL(fileURLWithPath: strDocumentsUrl)
            
    //        let strDocumentsUrl = getDirectoryPath()!.absoluteString + videoName
    //        return URL(fileURLWithPath: strDocumentsUrl)
        }
        
// Delete All files
    func deleteAllFiles() {
        if let documentsUrl = getDirectoryPath() {
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles,.skipsSubdirectoryDescendants])
                for fileURL in fileURLs {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } catch  { print(error) }
        }
    }
}


extension FileAttachment: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileUrl = urls.first else {
            return
        }
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let sandboxFileUrl = url.appendingPathComponent(fileUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: sandboxFileUrl.path) {
            print("Already Exists Do nothing")
            self.pickerController(controller, didSelect: sandboxFileUrl)
        } else {
            do {
                try FileManager.default.copyItem(at: fileUrl, to: sandboxFileUrl)
                self.pickerController(controller, didSelect: sandboxFileUrl)
            } catch {
                self.pickerController(controller, didSelect: nil)
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension FileAttachment:QLPreviewControllerDataSource {
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let file = files[index]
        return file as QLPreviewItem
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return files.count
    }
}

extension FileAttachment: QLPreviewControllerDelegate {
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        if quickViewController != nil {
            quickViewController.dismiss(animated: true, completion: nil)
        }
    }
}

class CustomDocumentPickerViewController: UIDocumentPickerViewController {

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    UINavigationBar.appearance().tintColor = .clear
    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
  }

  override func viewWillDisappear(_ animated: Bool) {

    UINavigationBar.appearance().tintColor = UIColor.white
    UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
    super.viewWillDisappear(animated)

  }

}
