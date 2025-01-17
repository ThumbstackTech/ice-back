//
//  ExtensionUIViewController.swift
//  OnManicLine
//
//  Created by CTPLMac6 on 16/11/18.
//  Copyright © 2018 CTPLMac7. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI
import DropDown
var AlertBlockKey: UInt8 = 0

// MARK: A type for our action block closure

typealias BlockButtonActionBlock = (_ sender: UIButton) -> Void
typealias BlockAlertBlock = (_ buttonIndexs: Int) -> Void
typealias BlockAlertOkAction = (_ action: UIAlertAction) -> Void
typealias alertActionHandler = ((UIAlertAction) -> ())?

// MARK: Convert all action block closure to variable object

class AlertBlockWrapper : NSObject
{
    var block : BlockAlertBlock
    init(block: @escaping BlockAlertBlock)
    {
        self.block = block
    }
}

var sortedContactKeys = [String]()

var objImagePickerController: UIImagePickerController?


extension UIViewController {
    
    //MARK: - Append Controller To NavigationStack
    func appendControllerToNavigationStack() {
        if var navstack = navigationController?.viewControllers {
            let arrFilter = appDelegate.arrNavigationStack.filter { !navstack.contains($0) }
            navstack.append(contentsOf: arrFilter)
            navigationController?.setViewControllers(navstack, animated: false)
        }
    }
}

extension UIViewController: UIAlertViewDelegate
{

    
    func presentAlertViewWithTwoButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func presentAlertViewWithOneButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
 
        self.present(alertController, animated: true, completion: nil)
    }
    
   
    // MARK:
    // MARK: Use for alert messages
    // MARK:
    
    func showAlert(_ message: String) -> Void
    {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alertWithTitle(_ title: String, message: String) -> Void {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showWithOkAction(title: String?, message: String?, cancelTitle: String, other: NSArray?,clicked: @escaping BlockAlertOkAction) -> Void {
        
        if #available(iOS 9.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: clicked))
            
            if other != nil {
                for addButton in other! {
                    let OKAction = UIAlertAction(title: String(describing: addButton), style: .default) { (action) in
                        let index = other?.index(of: action.title!)
                        let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                        wrapper.block(index!)
                    }
                    alertController.addAction(OKAction)
                }
            }
            
            self.present(alertController, animated: true) {
                
            }
        } else {
            let alert:UIAlertView = UIAlertView()
            
            if (title != nil)
            {
                alert.title = title!
            }
            if (message != nil)
            {
                alert.message = message!
            }
            alert.addButton(withTitle: cancelTitle)
            if (other != nil)
            {
                for addButton in other! {
                    alert.addButton(withTitle: String(describing: addButton))
                }
            }
            
            alert.delegate = self
            alert.show()
        }
        
    }
    
    func show(title: String?, message: String?, cancelTitle: String, other: NSArray?,clicked: @escaping BlockAlertBlock) -> Void {
        
        if #available(iOS 9.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
                let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                wrapper.block(0)
            }
            alertController.addAction(cancelAction)
            
            if other != nil {
                for addButton in other! {
                    let OKAction = UIAlertAction(title: String(describing: addButton), style: .default) { (action) in
                        var index = other?.index(of: action.title!)
                        index = index! + 1
                        let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                        wrapper.block(index!)
                    }
                    alertController.addAction(OKAction)
//                    objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
            
            objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.present(alertController, animated: true) {
                
            }
        } else {
            let alert:UIAlertView = UIAlertView()
            
            if (title != nil)
            {
                alert.title = title!
            }
            if (message != nil)
            {
                alert.message = message!
            }
            alert.addButton(withTitle: cancelTitle)
            
            
            if (other != nil)
            {
                for addButton in other! {
                    alert.addButton(withTitle: String(describing: addButton))
                }
            }
            
            objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            alert.delegate = self
            alert.show()
        }
    }
    
    
    //MARK: - Download PDF
    func downloadPDF(from url: URL,filename:String, completion: @escaping (Bool) -> Void) {
        
            let task = URLSession.shared.downloadTask(with: url) { (tempLocalURL, response, error) in
                if error != nil {
                    completion(false)
                    return
                }
                
                guard let tempLocalURL = tempLocalURL else {
                    _ = NSError(domain: "DownloadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to download the file"])
                    completion(false)
                    return
                }
                let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let foldePath = documentsDirectory.appendingPathComponent("Invoice")
                let fileURL = foldePath.appendingPathComponent("\(filename)_\(currentTimeStamp).pdf")
                
                do {
                    try FileManager.default.moveItem(at: tempLocalURL, to: fileURL)
                    completion(true)
                } catch {
                    completion(false)
                }
            }
            task.resume()
        
    }
  
    // MARK:
    // MARK: Use for open acction sheet
    // MARK:
    
    func showActionSheet(title: String?, message: String?, cancelTitle: String, other: NSArray?,clicked: @escaping BlockAlertBlock) -> Void {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
            wrapper.block(-1)
        }
        alertController.addAction(cancelAction)
        
        if other != nil {
            for addButton in other! {
                let OKAction = UIAlertAction(title: String(describing: addButton), style: .default) { (action) in
//                   dPrint(action.title!)
                    let index  = other?.index(of: action.title!)
                    let wrapper = objc_getAssociatedObject(self, &AlertBlockKey) as! AlertBlockWrapper
                    wrapper.block(index!)
                }
                alertController.addAction(OKAction)
            }
        }
        
        objc_setAssociatedObject(self, &AlertBlockKey, AlertBlockWrapper(block: clicked), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true) {
            
        }
    }
    
    func presentActionsheetWithTwoButtons(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertAction.Style , btnOneTapped:alertActionHandler , btnTwoTitle:String  , btnTwoStyle:UIAlertAction.Style , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: btnTwoStyle, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func topMostViewController() -> UIViewController {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?
            .presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
  
}


extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
    }
    
    public func hideTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
}
protocol DropDownSelectDelegate{
    func didSelect(value:String)
    func didCancel()
}
extension UIViewController
{
    
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool, isHidden : Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor
            navBarAppearance.shadowColor = backgoundColor
            
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.layoutIfNeeded()
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            
            navigationController?.navigationBar.tintColor = .white
            navigationItem.title = title
            navigationController?.navigationBar.isHidden = isHidden
            
          //  navigationController?.setStatusBar(backgroundColor: backgoundColor)

        } else {
          
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.layoutIfNeeded()
            
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
            navigationController?.navigationBar.isHidden = isHidden
            
           // navigationController?.setStatusBar(backgroundColor: backgoundColor)
        }
    }
    
    //MARK: - Drop Down
    func dropDown(data:[String],source:UIButton,dropDownDelegate:DropDownSelectDelegate){
        let serviceDropDown = DropDown()
        serviceDropDown.dataSource = data//4
        serviceDropDown.anchorView = source //5
        serviceDropDown.bottomOffset = CGPoint(x: 0, y: source.frame.size.height) //6
        serviceDropDown.show() //7
        serviceDropDown.layer.cornerRadius = 10
        var value:String = ""
        serviceDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
            value = item
            dropDownDelegate.didSelect(value: value)
            //  sender.setTitle(item, for: .normal) //9
        }
        serviceDropDown.cancelAction = {
            dropDownDelegate.didCancel()
        }
    }
    
   
}
extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}


typealias imagePickerControllerCompletionHandler = ((_ image:UIImage? , _ info:[UIImagePickerController.InfoKey : Any]?) -> ())

// MARK: - Extension of UIViewController For UIImagePickerController - Select Image From Camera OR PhotoLibrary

extension UIViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        
        static var imagePickerController = "imagePickerController"
        static var imagePickerControllerCompletionHandler = "imagePickerControllerCompletionHandler"
    }
    
    /// A Computed Property of UIImagePickerController , If its already in memory then return it OR not then create new one and store it in memory reference.
    private var imagePickerController:UIImagePickerController? {
        
        if let imagePickerController = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerController) as? UIImagePickerController {
            
            return imagePickerController
        } else {
            return self.addImagePickerController()
        }
    }
    
    /// A Private method used to create a UIImagePickerController and store it in a memory reference.
    ///
    /// - Returns: return a newly created UIImagePickerController.
    private func addImagePickerController() -> UIImagePickerController? {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerController, imagePickerController, .OBJC_ASSOCIATION_RETAIN)
        
        return imagePickerController
    }
    
    /// A Private method used to set the sourceType of UIImagePickerController
    ///
    /// - Parameter sourceType: A Enum value of "UIImagePickerControllerSourceType"
    private func setImagePickerControllerSourceType(sourceType:UIImagePickerController.SourceType) {
        
        self.imagePickerController?.sourceType = sourceType
    }
    
    /// A Private method used to set the Bool value for allowEditing OR Not on UIImagePickerController.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func setAllowEditing(allowEditing:Bool) {
        self.imagePickerController?.allowsEditing = allowEditing
    }
    
    /// This method is used to present the UIImagePickerController on CurrentController for select the image from Camera or PhotoLibrary.
    ///
    /// - Parameters:
    ///   - allowEditing: Pass the Bool value for allowEditing OR Not on UIImagePickerController.
    ///   - imagePickerControllerCompletionHandler: This completionHandler contain selected image AND info Dictionary to let you help in CurrentController. Both image AND info Dictionary might be nil , in this case to prevent the crash please use if let OR guard let.
    func presentImagePickerController(allowEditing:Bool , imagePickerControllerCompletionHandler:@escaping imagePickerControllerCompletionHandler) {
        
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: "Take A Photo", btnOneStyle: .default, btnOneTapped: { (action) in
            
            self.takeAPhoto()
            
        }, btnTwoTitle: "Choose From Gallery", btnTwoStyle: .default) { (action) in
            
            self.chooseFromPhone(allowEditing:allowEditing)
        }
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler:@escaping imagePickerControllerCompletionHandler) {
        self.takeAPhoto()
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// A private method used to select the image from camera.
    private func takeAPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            self.setImagePickerControllerSourceType(sourceType: .camera)
            self.setAllowEditing(allowEditing: false)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {
            
            self.showAlert("Your device does not support camera")
//            self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: "Your device does not support camera", btnOneTitle: "Ok", btnOneTapped: nil)
        }
    }
    
    /// A private method used to select the image from photoLibrary.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func chooseFromPhone(allowEditing:Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            self.setImagePickerControllerSourceType(sourceType: .photoLibrary)
            self.setAllowEditing(allowEditing: allowEditing)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {}
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            
            if let allowEditing = self.imagePickerController?.allowsEditing {
                
                var image:UIImage?
                
                if allowEditing {
                    
                    image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                    
                } else {
                    
                    image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                }
                
                if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                    
                    imagePickerControllerCompletionHandler(image, info)
                }
            }
        }
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            
            if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                
                imagePickerControllerCompletionHandler(nil, nil)
            }
        }
    }
    
    
    
}

enum PHAssetType : Int {
    case unknown
    case image
    case video
    case audio
}


typealias phAssetControllerHandler = ((_ mediaItemCollection:PHFetchResult<PHAsset>?) -> ())
// MARK: - Extension of UIViewController For MPMediaPickerController - Select Video/Image From gallery
extension UIViewController {
    /// This Private Structure is used to create all AssociatedAssetKey which will be used within this extension.
    private struct AssociatedAssetKey {
        static var phAssetControllerHandler = "phAssetControllerHandler"
    }
    
    func phAssetController(_ type : PHAssetType?, phAssetControllerHandler:@escaping phAssetControllerHandler){
        
        objc_setAssociatedObject(self, &AssociatedAssetKey.phAssetControllerHandler, phAssetControllerHandler, .OBJC_ASSOCIATION_RETAIN)
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                var arrAssets = PHFetchResult<PHAsset>()
                switch type
                {
                case .unknown?:
                    arrAssets = PHAsset.fetchAssets(with: .unknown, options: fetchOptions)
                    
                case .image?:
                    arrAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                    
                case .video?:
                    arrAssets = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                    
                case .audio?:
                    arrAssets = PHAsset.fetchAssets(with: .audio, options: fetchOptions)
                    
                default:
                    break
                    
                }
                
               dPrint("Found \(arrAssets.count) assets")
                
                if let phAssetControllerHandler = objc_getAssociatedObject(self, &AssociatedAssetKey.phAssetControllerHandler) as? phAssetControllerHandler {
                    phAssetControllerHandler(arrAssets)
                }
                
            case .denied, .restricted, .limited:
               dPrint("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
               dPrint("Not determined yet")
               @unknown default:
               dPrint("Not determined yet")
            }
        }
        
    }
}


//MARK: - UIGestureRecognizerDelegate
extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
            navigationController?.popViewController(animated: true)
        }
        return false
    }
    
    
    
    func sharePost(url: URL, str: String){
        
        let sharedText = "\(str) : \(url)"
       dPrint(sharedText)
        
        let shareAll = [sharedText] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverPresentationController = activityViewController.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = []
            }
            
        } else {
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
}
