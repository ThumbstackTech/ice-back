import UIKit
import AVKit
import Photos
import PhotosUI

protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}



class ImagePicker: NSObject{
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    func multiple(presentationController: UIViewController){
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1 // Selection limit. Set to 0 for unlimited.
            configuration.filter = .images // he types of media that can be get.
            configuration.filter = .any(of: [.livePhotos,.images]) // Multiple types of media
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            presentationController.present(picker, animated: true)
        } else {
            // Fallback on earlier versions
        }
      
    }
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if title.isEqualTo(str: "Camera") {
                if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                    //already authorized
                    GCDMainThread.async {
                        self.pickerController.sourceType = type
                        self.pickerController.allowsEditing = false
                        self.presentationController?.present(self.pickerController, animated: true)
                    }
                } else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                        if granted {
                            //access allowed
                            GCDMainThread.async {
                                self.pickerController.sourceType = type
                                self.presentationController?.present(self.pickerController, animated: true)
                            }
                        } else {
                            let msg = "Enable permissions to access your camera for sending photos."
                            GCDMainThread.async {
                                let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                                alertController.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { _ in
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                                            // Handle
                                        })
                                    }
                                })
                                self.presentationController?.present(alertController, animated:true)
                            }
                        }
                    })
                }
            } else {
                PHPhotoLibrary.requestAuthorization { [weak self] result in
                    guard let self = self else { return }
                    
                    if result == .authorized {
                        GCDMainThread.async {
                            self.multiple(presentationController: self.presentationController!)
                        }
                    } else {
                        let msg = "Enable permissions to access your photos for sending photos."
                        GCDMainThread.async {
                            let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
                            alertController.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { _ in
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                                        // Handle
                                    })
                                }
                            })
                            self.presentationController?.present(alertController, animated:true)
                        }
                    }
                }
            }
        }
    }
    
    public func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Camera") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo Library") {
          //
            alertController.addAction(action)
        }
       
       
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        alertController.modalPresentationStyle = .fullScreen
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {

        controller.dismiss(animated: true) {

            self.delegate?.didSelect(image:image)

        }
        
    }
}


extension ImagePicker: PHPickerViewControllerDelegate {
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty {
            picker.dismiss(animated: true)
        } else {
                for i in results {
                    if i.itemProvider.canLoadObject(ofClass: UIImage.self) {
                        i.itemProvider.loadObject(ofClass: UIImage.self) { imge, error in
                            if let firstImage = imge as? UIImage {
                                GCDMainThread.async {
                                    picker.dismiss(animated: true){
                                        self.delegate?.didSelect(image:firstImage)
                                    }
                                }
                               
                            }
                        }
                    } else if i.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        
                        i.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { imgUrl, error in
                           dPrint("imgUrl = \(imgUrl as Any)")
                            
                            if let data = try? Data(contentsOf: imgUrl!){
                                let image: UIImage = UIImage(data: data)!
                                GCDMainThread.async {
                                    picker.dismiss(animated: true){
                                        self.delegate?.didSelect(image:image)
                                    }
                                }
                            }
                            
                        }
                    } else if i.itemProvider.hasItemConformingToTypeIdentifier(UTType.rawImage.identifier) {
                        
                        i.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.rawImage.identifier) { imgUrl, error in
                            if let data = try? Data(contentsOf: imgUrl!){
                                let image: UIImage = UIImage(data: data)!
                                GCDMainThread.async {
                                    picker.dismiss(animated: true){
                                        self.delegate?.didSelect(image:image)
                                    }
                                }
                            }
                        
                        }
                    }
                }
        }
    }
    
}

extension ImagePicker: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
     
        
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                self.delegate?.didSelect(image:image)
            }
        }
        
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}

